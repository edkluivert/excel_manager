import 'package:excel_manager/domain/entities/task.dart';

class GeneratedTask {
  GeneratedTask({required this.title, this.note, this.priority
  = Priority.medium, this.dueAt});
  final String title;
  final String? note;
  final Priority priority;
  final DateTime? dueAt;

}

abstract class AiService {
  Future<List<GeneratedTask>> suggestTasks(String prompt);
  Future<DateTime?> suggestNewTime(String title, DateTime? currentDue);
}
