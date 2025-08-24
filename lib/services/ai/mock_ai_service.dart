import 'dart:math';
import 'package:excel_manager/domain/entities/task.dart';
import 'package:excel_manager/services/ai/ai_service.dart';

class MockAiService implements AiService {
  final _rnd = Random();

  @override
  Future<List<GeneratedTask>> suggestTasks(String prompt) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final now = DateTime.now();
    // naive parse: look for numbers + keywords
    final tasks = <GeneratedTask>[
      GeneratedTask(title: 'Write weekly plan', note: 'From prompt: $prompt', dueAt: now.add(const Duration(days: 1))),
      GeneratedTask(title: 'Deep work block', note: '2h focus', priority: Priority.high),
      GeneratedTask(title: 'Stretch & hydrate', note: 'Wellness', priority: Priority.low),
      GeneratedTask(title: 'Inbox zero', note: 'Email cleanup'),
      GeneratedTask(title: 'Take a 30-min walk', note: 'Wellness',
          dueAt: now.add(const Duration(days: 2))),
    ];
    return tasks.take(5).toList();
  }

  @override
  Future<DateTime?> suggestNewTime(String title, DateTime? currentDue) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final base = currentDue ?? DateTime.now();
    return base.add(Duration(hours: [16, 20, 24].elementAt(_rnd.nextInt(3))));
  }
}
