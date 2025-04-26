import 'package:flutter/foundation.dart';
import 'package:todo_list_machinetask/model/task.dart';
import 'package:todo_list_machinetask/services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToTasks(String userId) {
    _isLoading = true;
    notifyListeners();

    _taskService.getTasks(userId).listen((tasks) {
      _tasks = tasks;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }


// Add a new task to the database
  Future<void> addTask(Task task) async {
    try {
      await _taskService.addTask(task);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  // Update an existing task in the database
  Future updateTask(Task task) async {
    try {
      await _taskService.updateTask(task);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  // Delete a task from the database
  Future deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

// Task Completion
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _taskService.updateTask(updatedTask);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

// Share a task with another user
  Future<void> shareTask(String taskId, String userEmail) async {
    try {
      await _taskService.shareTask(taskId, userEmail);
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
