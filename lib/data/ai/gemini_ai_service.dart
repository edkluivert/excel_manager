import 'dart:convert';

import 'package:excel_manager/core/env/env.dart';
import 'package:excel_manager/core/errors/failure.dart';
import 'package:excel_manager/data/ai/ai_service.dart';
import 'package:excel_manager/domain/entities/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GeminiAiService implements AiService {
  GeminiAiService(this._client);
  final http.Client _client;

  @override
  Future<List<GeneratedTask>> suggestTasks(String prompt) async {
    final key = Env.geminiKey;
    if (key == null || key.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY');
    }

    final res = await _client.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$key',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                'Return only a valid JSON array of tasks. Each task must have: title(string), note(string), priority(low|medium|high), dueAt(ISO8601). No extra text. Prompt: $prompt'
              }
            ]
          }
        ]
      }),
    );

    if (res.statusCode >= 400) {
      debugPrint(res.body);
      throw Exception(Failure(res.body).message);
    }

    final decoded = jsonDecode(res.body);
    final text = decoded['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (text == null) {
      throw Exception('Gemini response missing text field: ${res.body}');
    }

    final raw = text.replaceAll(RegExp(r'```json|```'), '').trim();

    late final List<dynamic> parsed;
    try {
      parsed = jsonDecode(raw.toString()) as List<dynamic>;
    } on Exception catch (e) {
      throw Exception('Failed to parse Gemini JSON: $raw');
    }

    return parsed.map((e) {
      return GeneratedTask(
        title: e['title'] as String,
        note: e['note'] as String?,
        priority: switch ((e['priority'] as String).toLowerCase()) {
          'low' => Priority.low,
          'high' => Priority.high,
          _ => Priority.medium,
        },
        dueAt: e['dueAt'] != null
            ? DateTime.tryParse(e['dueAt'] as String)
            : null,
      );
    }).toList();
  }


  @override
  Future<DateTime?> suggestNewTime(String title, DateTime? currentDue) async {
    return DateTime.now().add(const Duration(hours: 24));
  }
}
