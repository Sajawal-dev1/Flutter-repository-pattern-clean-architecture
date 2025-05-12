import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/task_local_data_source.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/get_task_by_id.dart';
import '../../domain/usecases/update_task.dart';
import 'task_notifier.dart';

// Data sources
final taskBoxProvider = Provider<Box<Task>>((ref) {
  throw UnimplementedError('Box should be initialized before accessing');
});

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  final taskBox = ref.watch(taskBoxProvider);
  return TaskLocalDataSourceImpl(taskBox: taskBox);
});

// Repositories
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final localDataSource = ref.watch(taskLocalDataSourceProvider);
  return TaskRepositoryImpl(localDataSource: localDataSource);
});

// Use cases
final getAllTasksProvider = Provider<GetAllTasks>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetAllTasks(repository);
});

final getTaskByIdProvider = Provider<GetTaskById>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetTaskById(repository);
});

final addTaskProvider = Provider<AddTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return AddTask(repository);
});

final updateTaskProvider = Provider<UpdateTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return UpdateTask(repository);
});

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return DeleteTask(repository);
});

// State notifiers
final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<List<Task>>>((ref) {
  return TaskNotifier(
    getAllTasks: ref.watch(getAllTasksProvider),
    addTask: ref.watch(addTaskProvider),
    updateTask: ref.watch(updateTaskProvider),
    deleteTask: ref.watch(deleteTaskProvider),
  );
});
