import 'package:hive/hive.dart';


@HiveType(typeId: 1)
class ProjectModel {

  ProjectModel({required this.id, required this.name,
    required this.createdAt, required this.updatedAt});
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) DateTime createdAt;
  @HiveField(3) DateTime updatedAt;
}
