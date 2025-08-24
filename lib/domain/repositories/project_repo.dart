import 'package:excel_manager/core/result/result.dart';
import 'package:excel_manager/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<Result<Project>> create(String name);
  Future<Result<void>> delete(String id);
  Future<Result<List<Project>>> getAll();
}

