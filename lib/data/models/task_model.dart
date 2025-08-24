import 'package:hive/hive.dart';


@HiveType(typeId: 2)
enum PriorityAdapterEnum { low, medium, high }

@HiveType(typeId: 3)
class TaskModel {

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.completed = false,
    this.priority = PriorityAdapterEnum.medium,
    this.dueAt,
    this.dirty = false,
  });
  @HiveField(0) String id;
  @HiveField(1) String projectId;
  @HiveField(2) String title;
  @HiveField(3) String? note;
  @HiveField(4) bool completed;
  @HiveField(5) PriorityAdapterEnum priority;
  @HiveField(6) DateTime? dueAt;
  @HiveField(7) DateTime createdAt;
  @HiveField(8) DateTime updatedAt;
  @HiveField(9) bool dirty;
}
