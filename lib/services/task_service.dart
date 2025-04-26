import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_machinetask/model/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where(Filter.or(Filter('userId', isEqualTo: userId),
            Filter('sharedWith', arrayContains: userId)))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add the document ID to the data
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
    final userQuery = await _firestore
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) {
      throw Exception('User not found');
    }

    final userId = userQuery.docs.first.id;

    // Then, Update the task's sharedWith field
    await _firestore.collection('tasks').doc(taskId).update({
      'sharedWith': FieldValue.arrayUnion([userId])
    });
  }
}
