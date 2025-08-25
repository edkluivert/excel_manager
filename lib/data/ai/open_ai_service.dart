import 'dart:convert';
import 'package:excel_manager/core/env/env.dart';
import 'package:excel_manager/core/errors/failure.dart';
import 'package:excel_manager/data/ai/ai_service.dart';
import 'package:excel_manager/domain/entities/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OpenAiService implements AiService {
  OpenAiService(this._client);
  final http.Client _client;

  @override
  Future<List<GeneratedTask>> suggestTasks(String prompt) async {
    final key = Env.openAiKey;
    if (key == null || key.isEmpty) throw Exception('Missing OPENAI_API_KEY');

    final res = await _client.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {'Authorization': 'Bearer $key', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': 'gpt-3.5-turbo-instruct',
        'prompt': 'Return a JSON array of tasks with fields: title,note,priority(low|medium|high),dueAt(ISO). Prompt: $prompt'
      }),
    );
    if (res.statusCode >= 400) {
      debugPrint(res.body);
      throw Exception(Failure(res.body).message);
    }
    final text = jsonDecode(res.body)['output_text'] as String;
    final parsed = jsonDecode(text) as List<dynamic>;
    return parsed.map((e) => GeneratedTask(
      title: e['title'] as String,
      note: e['note'] as String?,
      priority: switch ((e['priority'] as String).toLowerCase()) {
        'low' => Priority.low, 'high' => Priority.high, _ => Priority.medium
      },
      dueAt: (e['dueAt'] != null) ? DateTime.tryParse(e['dueAt'] as String
      ) : null,
    )).toList();
  }

  @override
  Future<DateTime?> suggestNewTime(String title, DateTime? currentDue) async {
    return DateTime.now().add(const Duration(hours: 24));
  }
}
