import 'package:collection/collection.dart';
import 'package:excel_manager/data/data_sources/local/hive_db.dart';
import 'package:excel_manager/data/models/project_model.dart';
import 'package:uuid/uuid.dart';

class ProjectLocalDataSource {
  final _uuid = const Uuid();

  Future<ProjectModel> create(String name) async {
    final now = DateTime.now();
    final model = ProjectModel(
      id: _uuid.v4(), name: name, createdAt: now, updatedAt: now,
    );
    await HiveDb.projects().put(model.id, model);
    return model;
  }

  Future<void> delete(String id) async => HiveDb.projects().delete(id);

  Future<List<ProjectModel>> getAll() async =>
      HiveDb.projects().values.sortedBy((p) => p.createdAt).toList();
}


