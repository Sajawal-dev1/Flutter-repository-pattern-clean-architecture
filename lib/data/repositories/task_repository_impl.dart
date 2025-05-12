import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getAllTasks() async {
    return await localDataSource.getAllTasks();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    return await localDataSource.getTaskById(id);
  }

  @override
  Future<void> addTask(Task task) async {
    await localDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }
}
