import 'package:equatable/equatable.dart';
import 'package:excel_manager/data/ai/ai_service.dart';
import 'package:excel_manager/data/ai/gemini_ai_service.dart';
import 'package:excel_manager/data/ai/open_ai_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ai_assistant_state.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  AiAssistantCubit(this._ai, this.openAiService, this.geminiService) : super(const AiAssistantState.idle());
  final AiService _ai;
  final OpenAiService openAiService;
  final GeminiAiService geminiService;

  Future<void> generate(String prompt) async {
    emit(AiAssistantState.loading(prompt));
    try {
     // final tasks = await _ai.suggestTasks(prompt);
     // final tasks = await openAiService.suggestTasks(prompt);
      final tasks = await geminiService.suggestTasks(prompt);
      emit(AiAssistantState.success(prompt, tasks));
    } on Exception catch (e) {
      emit(AiAssistantState.error(prompt, e.toString()));
    }
  }

  Future<void> suggestNewTime(String title, DateTime? currentDue) async {
    try {
      final when = await _ai.suggestNewTime(title, currentDue);
      emit(state.copyWith(suggestedTime: when));
    } on Exception catch (_) {}
  }
}
