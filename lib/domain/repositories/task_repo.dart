import 'package:excel_manager/core/result/result.dart';
import 'package:excel_manager/domain/entities/task.dart';

abstract class TaskRepository {
  Future<Result<Task>> create(Task t);
  Future<Result<Task>> update(Task t);
  Future<Result<void>> delete(String id);
  Future<Result<List<Task>>> byProject(String projectId);
  Future<Result<void>> markComplete(String id, {required bool isComplete});
  Future<Result<List<Task>>> getOverdue();
}
