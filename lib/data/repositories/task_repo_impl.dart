import 'dart:async';

import 'package:excel_manager/core/result/result.dart';
import 'package:excel_manager/data/data_sources/local/task_ds.dart';
import 'package:excel_manager/data/data_sources/remote/mock_api.dart';
import 'package:excel_manager/data/models/task_model.dart';
import 'package:excel_manager/domain/entities/task.dart' as d;
import 'package:excel_manager/domain/repositories/task_repo.dart';

extension on TaskModel {
  d.Priority toDomainPriority() => switch (priority) {
    PriorityAdapterEnum.low => d.Priority.low,
    PriorityAdapterEnum.medium => d.Priority.medium,
    PriorityAdapterEnum.high => d.Priority.high,
  };
  d.Task toEntity() => d.Task(
    id: id, projectId: projectId, title: title, note: note,
    completed: completed, priority: toDomainPriority(),
    dueAt: dueAt, createdAt: createdAt, updatedAt: updatedAt, dirty: dirty,
  );
}

extension on d.Priority {
  PriorityAdapterEnum toModel() => switch (this) {
    d.Priority.low => PriorityAdapterEnum.low,
    d.Priority.medium => PriorityAdapterEnum.medium,
    d.Priority.high => PriorityAdapterEnum.high,
  };
}

extension TaskEntityToModel on d.Task {
  TaskModel toModel() => TaskModel(
    id: id, projectId: projectId, title: title, note: note,
    completed: completed, priority: priority.toModel(),
    dueAt: dueAt, createdAt: createdAt, updatedAt: updatedAt, dirty: dirty,
  );
}

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required this.local, required this.remote});
  final TaskLocalDataSource local;
  final MockApi remote;

  @override
  Future<Result<d.Task>> create(d.Task t) async {
    try {
      final now = DateTime.now();
      final model = t.copyWith(updatedAt: now, dirty: true).toModel();
      await local.upsert(model);
      // fire-and-forget sync simulated:
      unawaited(remote.upsertTask(model));
      return Success(model.toEntity());
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<d.Task>> update(d.Task t) async {
    try {
      final model = t.copyWith(updatedAt: DateTime.now(), dirty: true).toModel();
      await local.upsert(model);
      unawaited(remote.upsertTask(model));
      return Success(model.toEntity());
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await local.delete(id);
      unawaited(remote.deleteTask(id));
      return const Success(null);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<List<d.Task>>> byProject(String projectId) async {
    try {
      final list = await local.byProject(projectId);
      return Success(list.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Failure(e);
    }
  }




  @override
  Future<Result<List<d.Task>>> getOverdue() async {
    try {
      final list = await local.getOverdue(DateTime.now());
      return Success(list.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<void>> markComplete(String id, {required bool isComplete}) async {
    try {
      final existing = local.get(id);
      if (existing == null) return const Failure('Task not found');
      final updated = existing
        ..completed = isComplete
        ..updatedAt = DateTime.now()
        ..dirty = true;
      await local.upsert(updated);
      unawaited(remote.upsertTask(updated));
      return const Success(null);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
