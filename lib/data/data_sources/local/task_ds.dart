import 'package:collection/collection.dart';
import 'package:excel_manager/data/data_sources/local/hive_db.dart';
import 'package:excel_manager/data/models/task_model.dart';

class TaskLocalDataSource {
  Future<void> upsert(TaskModel t) async => HiveDb.tasks().put(t.id, t);
  Future<void> delete(String id) async => HiveDb.tasks().delete(id);

  Future<List<TaskModel>> byProject(String projectId) async =>
      HiveDb.tasks().values.where((t) => t.projectId == projectId)
          .sortedBy((t) => t.createdAt).toList();

  Future<List<TaskModel>> getOverdue(DateTime now) async =>
      HiveDb.tasks().values.where((t) => !t.completed && t.dueAt != null
          && t.dueAt!.isBefore(now)).toList();

  TaskModel? get(String id) => HiveDb.tasks().get(id);
}