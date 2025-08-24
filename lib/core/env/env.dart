import 'package:flutter_dotenv/flutter_dotenv.dart';
enum AiProvider { mock, openai, gemini }
class Env {
  static String? get openAiKey => dotenv.env['OPENAI_API_KEY'];
  static String? get geminiKey => dotenv.env['GEMINI_API_KEY'];
  static AiProvider get aiProvider {
    final v = dotenv.env['AI_PROVIDER']?.toLowerCase() ?? 'mock';
    return {'openai': AiProvider.openai, 'gemini': AiProvider.gemini}[v]
        ?? AiProvider.mock;
  }
}
