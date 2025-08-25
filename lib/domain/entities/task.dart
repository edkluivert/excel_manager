import 'package:equatable/equatable.dart';
import 'package:excel_manager/data/ai/ai_service.dart';
import 'package:uuid/uuid.dart';

enum Priority { low, medium, high }

class Task extends Equatable {

  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.completed = false,
    this.priority = Priority.medium,
    this.dueAt,
    this.dirty = false,
  });
  final String id;
  final String projectId;
  final String title;
  final String? note;
  final bool completed;
  final Priority priority;
  final DateTime? dueAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool dirty;

  Task copyWith({
    String? id,
    String? projectId,
    String? title,
    String? note,
    bool? completed,
    Priority? priority,
    DateTime? dueAt,
    DateTime? updatedAt,
    bool? dirty,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      note: note ?? this.note,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      dueAt: dueAt ?? this.dueAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
    );
  }


  @override List<Object?> get props =>
      [id, projectId, title, note, completed, priority, dueAt, createdAt, updatedAt, dirty];
}




class TaskAdapter {
  static Task fromGenerated(GeneratedTask g, String projectId) {
    return Task(
      id: const Uuid().v4(),
      projectId: projectId,
      title: g.title,
      note: g.note,
      priority: g.priority,
      dueAt: g.dueAt,
      completed: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
