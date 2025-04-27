
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_machinetask/model/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(String userId) {
  final userEmail = FirebaseAuth.instance.currentUser?.email;  
  if (userEmail == null) {
    return Stream.value([]);
  }
  
  return _firestore
      .collection('tasks')
      .where(Filter.or(
        Filter('userId', isEqualTo: userId),
        Filter('sharedWith', arrayContains: userEmail)
      ))
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          if (data['sharedWith'] != null) {
          }
          return Task.fromJson(data);
        }).toList();
      });
}
// Add a new task to the database
  Future<Task> addTask(Task task) async {
    final docRef = await _firestore.collection('tasks').add(task.toJson());
    return task.copyWith(id: docRef.id);
  }

// Update an existing task in the database
  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toJson());
  }

// Delete a task from the database
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

// Share a task with another user
  Future<void> shareTask(String taskId, String userEmail) async {
    try {
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {

        await _firestore.collection('users').add({
          'email': userEmail,
          'displayName': userEmail.split('@')[0],
        });
      }

      await _firestore.collection('tasks').doc(taskId).update({
        'sharedWith': FieldValue.arrayUnion([userEmail])
      });
    } catch (e) {
      throw Exception('Failed to share task: $e');
    }
  }
}
