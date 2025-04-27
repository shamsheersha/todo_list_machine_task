import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_list_machinetask/model/task.dart';
import 'package:todo_list_machinetask/view_models/auth_view_model.dart';
import 'package:todo_list_machinetask/view_models/task_view_model.dart';
import 'package:todo_list_machinetask/widgets/custom_text_field.dart';
import 'package:todo_list_machinetask/widgets/responsive_layout.dart';
import 'package:todo_list_machinetask/widgets/show_custom_snackbar.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _shareEmailController;
  bool _isEditing = false;
  bool _isOwner = false;
  bool _showShareForm = false;
  
  // Track the current state of the task
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task; // Initialize with the passed task
    _titleController = TextEditingController(text: _currentTask.title);
    _descriptionController = TextEditingController(text: _currentTask.description);
    _shareEmailController = TextEditingController();

    // Check if the current user is the owner of this task
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _isOwner = _currentTask.userId == authViewModel.user!.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _shareEmailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_titleController.text.trim().isEmpty) return;

    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    final updatedTask = _currentTask.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    setState(() {
      _currentTask = updatedTask;
      _isEditing = false;
    });
    
    taskViewModel.updateTask(updatedTask);
    showCustomSnackbar(context, 'Task updated successfully!');
  }

  void _toggleTaskCompletion() {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    
    // Update local state immediately
    final updatedTask = _currentTask.copyWith(isCompleted: !_currentTask.isCompleted);
    
    setState(() {
      _currentTask = updatedTask;
    });
    
    // Then update in Firebase
    taskViewModel.updateTask(updatedTask);
  }

  void _shareTask() {
    final email = _shareEmailController.text.trim();
    if (email.isEmpty) return;

    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    taskViewModel.shareTask(_currentTask.id, email);

    showCustomSnackbar(context, 'Task shared with $email');

    setState(() {
      List<String> updatedSharedWith = [..._currentTask.sharedWith, email];
      _currentTask = _currentTask.copyWith(sharedWith: updatedSharedWith);
      
      _showShareForm = false;
      _shareEmailController.clear();
    });
  }

  void _shareTaskLink() {
    SharePlus.instance.share(
      ShareParams(
        text: 'Task: ${_currentTask.title}\n\n${_currentTask.description}',
        subject: 'Check out this task',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Task Details'),
        actions: [
          if (_isOwner && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: ResponsiveLayout(
        mobileLayout: _buildMobileLayout(),
        tabletLayout: _buildTabletLayout(),
        desktopLayout: _buildDesktopLayout(),
      ),
      floatingActionButton: _isOwner && !_isEditing
          ? FloatingActionButton(
              onPressed: () => setState(() => _showShareForm = !_showShareForm),
              child: Icon(_showShareForm ? Icons.close : Icons.share),
            )
          : null,
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _isEditing
                      ? CustomTextfield(
                          hintText: 'Enter task title',
                          labelText: 'Title',
                          isPassword: false,
                          controller: _titleController,
                        )
                      : Text(
                          _currentTask.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                ),
                if (!_isEditing)
                  Checkbox(
                    value: _currentTask.isCompleted,
                    onChanged: _isOwner
                        ? (value) {
                            if (value != null) {
                              _toggleTaskCompletion();
                            }
                          }
                        : null,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _isEditing
                ? CustomTextfield(
                    hintText: 'Enter task description',
                    labelText: 'Description',
                    isPassword: false,
                    controller: _descriptionController,
                    maxLines: 5,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentTask.description.isNotEmpty
                            ? _currentTask.description
                            : 'No description provided',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created on',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      '${_currentTask.createdAt.day}/${_currentTask.createdAt.month}/${_currentTask.createdAt.year}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _shareTaskLink,
                  icon: Icon(Icons.adaptive.share),
                  label: const Text('Share Link'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareForm() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share with User',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _shareEmailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter user email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() => _showShareForm = false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _shareTask,
                  child: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollaboratorsList() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collaborators',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_currentTask.sharedWith.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('This task has no collaborators yet'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _currentTask.sharedWith.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(_currentTask.sharedWith[index]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildDetailCard(),
          ),
          if (_showShareForm) _buildShareForm(),
          _buildCollaboratorsList(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailCard(),
            if (_showShareForm) _buildShareForm(),
            _buildCollaboratorsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildDetailCard(),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                if (_showShareForm) _buildShareForm(),
                _buildCollaboratorsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}