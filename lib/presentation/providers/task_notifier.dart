import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/update_task.dart';

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final GetAllTasks _getAllTasks;
  final AddTask _addTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;

  TaskNotifier({
    required GetAllTasks getAllTasks,
    required AddTask addTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
  })  : _getAllTasks = getAllTasks,
        _addTask = addTask,
        _updateTask = updateTask,
        _deleteTask = deleteTask,
        super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await _getAllTasks();
      state = AsyncValue.data(tasks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addNewTask(String title, String? description) async {
    try {
      final task = Task(
        id: const Uuid().v4(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );
      await _addTask(task);
      await loadTasks();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _updateTask(updatedTask);
      await loadTasks();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateTaskDetails(
      Task task, String title, String? description) async {
    try {
      final updatedTask = task.copyWith(
        title: title,
        description: description,
      );
      await _updateTask(updatedTask);
      await loadTasks();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> removeTask(String id) async {
    try {
      await _deleteTask(id);
      await loadTasks();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
