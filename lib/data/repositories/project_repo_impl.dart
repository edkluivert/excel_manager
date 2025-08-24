import 'package:excel_manager/core/result/result.dart';
import 'package:excel_manager/data/data_sources/local/project_local_ds.dart';
import 'package:excel_manager/data/data_sources/remote/mock_api.dart';
import 'package:excel_manager/data/models/project_model.dart';
import 'package:excel_manager/domain/entities/project.dart';
import 'package:excel_manager/domain/repositories/project_repo.dart';

extension on ProjectModel {
  Project toEntity() => Project(id: id, name: name, createdAt: createdAt, updatedAt: updatedAt);
}

class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl({required this.local, required this.remote});
  final ProjectLocalDataSource local;
  final MockApi remote;

  @override
  Future<Result<Project>> create(String name) async {
    try {
      final localModel = await local.create(name);

      final remoteCreated = await remote.createProject(localModel.name);

      return Success(localModel.toEntity());
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await local.delete(id);
      await remote.deleteProject(id);
      return const Success(null);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<List<Project>>> getAll() async {
    try {
      final all = await local.getAll();
      return Success(all.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
