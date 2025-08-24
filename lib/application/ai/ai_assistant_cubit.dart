import 'package:equatable/equatable.dart';
import 'package:excel_manager/services/ai/ai_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ai_assistant_state.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  AiAssistantCubit(this._ai) : super(const AiAssistantState.idle());
  final AiService _ai;

  Future<void> generate(String prompt) async {
    emit(AiAssistantState.loading(prompt));
    try {
      final tasks = await _ai.suggestTasks(prompt);
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
