import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../providers/providers.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Task? _task;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(taskNotifierProvider);

    return tasksState.when(
      data: (tasks) {
        _task = tasks.firstWhere((task) => task.id == widget.taskId);

        if (!_isEditing) {
          _titleController.text = _task!.title;
          _descriptionController.text = _task!.description ?? '';
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Task Details'),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  if (_isEditing) {
                    // Save changes
                    if (_titleController.text.isNotEmpty) {
                      ref.read(taskNotifierProvider.notifier).updateTaskDetails(
                            _task!,
                            _titleController.text,
                            _descriptionController.text.isEmpty
                                ? null
                                : _descriptionController.text,
                          );
                    }
                  }
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEditing) ...[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: 5,
                  ),
                ] else ...[
                  Text(
                    _task!.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_task!.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _task!.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Status: '),
                      Chip(
                        label: Text(
                          _task!.isCompleted ? 'Completed' : 'Pending',
                        ),
                        backgroundColor: _task!.isCompleted
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created: ${_formatDate(_task!.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 24),
                if (!_isEditing)
                  ElevatedButton.icon(
                    onPressed: () {
                      ref
                          .read(taskNotifierProvider.notifier)
                          .toggleTaskCompletion(_task!);
                    },
                    icon: Icon(_task!.isCompleted
                        ? Icons.check_box_outline_blank
                        : Icons.check_box),
                    label: Text(_task!.isCompleted
                        ? 'Mark as Incomplete'
                        : 'Mark as Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _task!.isCompleted ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
