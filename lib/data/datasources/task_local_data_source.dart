import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

abstract class TaskLocalDataSource {
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(String id);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<Task> taskBox;

  TaskLocalDataSourceImpl({required this.taskBox});

  @override
  Future<List<Task>> getAllTasks() async {
    return taskBox.values.toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    return taskBox.get(id);
  }

  @override
  Future<void> addTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }
}
