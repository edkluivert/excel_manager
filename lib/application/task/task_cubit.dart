import 'package:equatable/equatable.dart';
import 'package:excel_manager/core/result/result.dart';
import 'package:excel_manager/domain/entities/task.dart';
import 'package:excel_manager/domain/repositories/task_repo.dart';
import 'package:excel_manager/services/notification/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this.repo,
      this.service,
      this.projectId) : super(const TaskState()) {
    load();
  }
  final TaskRepository repo;
  final NotificationService service;
  final String projectId;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final res = await repo.byProject(projectId);
    switch (res) {
      case Success(value: final list): emit(state.copyWith(loading: false, tasks: list));
      case Failure(:final error): emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> toggleComplete(Task t) async {
    await repo.markComplete(t.id, isComplete: !t.completed);
    await load();
  }

  Future<void> addTask(Task t) async {
    await repo.create(Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: t.title,
      note: t.note,
      priority: t.priority,
      projectId: projectId,
      createdAt: t.createdAt,
      updatedAt: t.updatedAt,
      completed: t.completed,
      dueAt: t.dueAt,
      dirty: t.dirty,
    ));
    if (t.dueAt != null) {
      await service.scheduleDue(t.id, t.title, t.dueAt!);
    }
    await load();
  }

  Future<void> updateTask(Task t) async {
    await repo.update(t);
    if (t.dueAt != null) {
      await service.scheduleDue(t.id, t.title, t.dueAt!);
    } else {
      await service.cancel(t.id);
    }
    await load();
  }

  Future<void> deleteTask(String id) async {
    await repo.delete(id);
    await service.cancel(id);
    await load();
  }

}
