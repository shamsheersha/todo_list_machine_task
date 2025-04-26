import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_machinetask/model/task.dart';
import 'package:todo_list_machinetask/view_models/auth_view_model.dart';
import 'package:todo_list_machinetask/view_models/task_view_model.dart';
import 'package:todo_list_machinetask/views/task_detail_screen.dart';
import 'package:todo_list_machinetask/widgets/custom_appbar.dart';
import 'package:todo_list_machinetask/widgets/custom_smooth_navigator.dart';
import 'package:todo_list_machinetask/widgets/custom_text_field.dart';
import 'package:todo_list_machinetask/widgets/empty_state.dart';
import 'package:todo_list_machinetask/widgets/responsive_layout.dart';
import 'package:todo_list_machinetask/widgets/task_item.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  bool _isAddingTask = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      taskViewModel.listenToTasks(authViewModel.user!.id);
    });
    super.initState();
  }
  @override
  void dispose() {
    _taskController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    
    return Scaffold(
      appBar: CustomAppBar(),
      body: ResponsiveLayout(
          mobileLayout: _buildMobileLayout(taskViewModel, authViewModel),
          tabletLayout: _buildTabletLayout(taskViewModel, authViewModel),
          desktopLayout: _buildDesktopLayout(taskViewModel, authViewModel)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAddingTask = !_isAddingTask;
            if (!_isAddingTask) {
              _taskController.clear();
              _taskDescriptionController.clear();
            }
          });
        },
        child: Icon(_isAddingTask ? Icons.close : Icons.add),
      ),
    );
  }

  Widget _buildTaskList(
      TaskViewModel taskViewModel, AuthViewModel authViewModel) {
    if (taskViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskViewModel.tasks.isEmpty) {
      return const EmptyState(
        icon: Icons.task_outlined,
        title: 'No tasks yet',
        message: 'Add your first task by clicking the + button',
      );
    }

    return ListView.builder(
      itemCount: taskViewModel.tasks.length,
      itemBuilder: (context, index) {
        final task = taskViewModel.tasks[index];
        return TaskItem(
          task: task,
          onToggle: () => taskViewModel.toggleTaskCompletion(task),
          onTap: ()=> CustomSmoothNavigator.push(context, 
            TaskDetailScreen(task: task),
          ),
          
          onDelete: () => taskViewModel.deleteTask(task.id),
        );
      },
    );
  }

  Widget _buildAddTaskUI(AuthViewModel authViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Task',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          CustomTextfield(
            controller: _taskController,
            autoFocus: true,
            isPassword: false,
            hintText: 'Task Title',
            labelText: 'Task Title',
            decoration: const InputDecoration(
              hintText: 'Enter task title',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 15,),
          CustomTextfield(
            controller: _taskDescriptionController,
            autoFocus: false,
            isPassword: false,
            hintText: 'Task Description',
            labelText: 'Task Description', 
            decoration: const InputDecoration(
              hintText: 'Enter task description',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.trim().isNotEmpty) {
                final taskViewModel =
                    Provider.of<TaskViewModel>(context, listen: false);
                final task = Task(
                  id: const Uuid().v4(),
                  title: _taskController.text.trim(),
                  description: _taskDescriptionController.text.trim(),
                  createdAt: DateTime.now(),
                  userId: authViewModel.user!.id,
                );
                taskViewModel.addTask(task);
                _taskController.clear();
                setState(() {
                  _isAddingTask = false;
                });
              }
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white)),
            child: const Text(
              'Add Task',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
      TaskViewModel taskViewModel, AuthViewModel authViewModel) {
    return Column(
      children: [
        if (_isAddingTask) _buildAddTaskUI(authViewModel),
        Expanded(
          child: _buildTaskList(taskViewModel, authViewModel),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(
      TaskViewModel taskViewModel, AuthViewModel authViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (_isAddingTask)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildAddTaskUI(authViewModel),
              ),
            ),
          Expanded(
            child: _buildTaskList(taskViewModel, authViewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
      TaskViewModel taskViewModel, AuthViewModel authViewModel) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Card(
              margin: const EdgeInsets.only(right: 12),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${authViewModel.user!.displayName}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Tasks',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                        child: _buildTaskList(taskViewModel, authViewModel)),
                  ],
                ),
              ),
            ),
          ),
          if (_isAddingTask)
            Expanded(
              flex: 2,
              child: Card(
                margin: const EdgeInsets.only(left: 12),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildAddTaskUI(authViewModel),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
