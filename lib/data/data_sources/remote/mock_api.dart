import 'dart:async';

import 'package:excel_manager/data/models/project_model.dart';
import 'package:excel_manager/data/models/task_model.dart';
import 'package:uuid/uuid.dart';

class MockApi {
  final _uuid = const Uuid();

  // Remote in-memory stores
  final _projects = <String, ProjectModel>{};
  final _tasks = <String, TaskModel>{};

  Duration get latency => const Duration(milliseconds: 650);

  Future<ProjectModel> createProject(String name) async {
    await Future<void>.delayed(latency);
    final now = DateTime.now();
    final p = ProjectModel(id: _uuid.v4(), name: name, createdAt: now, updatedAt: now);
    _projects[p.id] = p;
    return p;
  }

  Future<void> deleteProject(String id) async {
    await Future<void>.delayed(latency);
    _projects.remove(id);
    _tasks.removeWhere((_, t) => t.projectId == id);
  }

  Future<List<ProjectModel>> getProjects() async {
    await Future<void>.delayed(latency);
    return _projects.values.toList();
  }

  Future<TaskModel> upsertTask(TaskModel t) async {
    await Future<void>.delayed(latency);
    _tasks[t.id] = t..updatedAt = DateTime.now();
    return _tasks[t.id]!;
  }

  Future<void> deleteTask(String id) async {
    await Future<void>.delayed(latency);
    _tasks.remove(id);
  }

  Future<List<TaskModel>> getTasksByProject(String projectId) async {
    await Future<void>.delayed(latency);
    return _tasks.values.where((t) => t.projectId == projectId).toList();
  }
}
