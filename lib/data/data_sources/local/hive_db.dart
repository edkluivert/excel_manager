import 'package:excel_manager/data/models/project_model.dart';
import 'package:excel_manager/data/models/project_model_adapter.dart';
import 'package:excel_manager/data/models/task_model.dart';
import 'package:excel_manager/data/models/task_model_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDb {
  static const projectsBox = 'projects_box';
  static const tasksBox = 'tasks_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ProjectAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(PriorityAdapterEnumAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(TaskAdapter());
    await Future.wait([
      Hive.openBox<ProjectModel>(projectsBox),
      Hive.openBox<TaskModel>(tasksBox),
    ]);
  }

  static Box<ProjectModel> projects() => Hive.box<ProjectModel>(projectsBox);
  static Box<TaskModel> tasks() => Hive.box<TaskModel>(tasksBox);
}
