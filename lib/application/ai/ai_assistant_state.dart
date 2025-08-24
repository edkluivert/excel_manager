part of 'ai_assistant_cubit.dart';

class AiAssistantState extends Equatable {

  const AiAssistantState({
    this.prompt,
    this.loading = false,
    this.tasks = const [],
    this.error,
    this.suggestedTime,
  });

  factory AiAssistantState.error(String prompt, String error) =>
      AiAssistantState(prompt: prompt, error: error);

  const AiAssistantState.idle() : this();

  factory AiAssistantState.loading(String prompt) =>
      AiAssistantState(prompt: prompt, loading: true);

  factory AiAssistantState.success(String prompt, List<GeneratedTask> tasks) =>
      AiAssistantState(prompt: prompt, tasks: tasks);
  final String? prompt;
  final bool loading;
  final List<GeneratedTask> tasks;
  final String? error;
  final DateTime? suggestedTime;

  AiAssistantState copyWith({DateTime? suggestedTime}) =>
      AiAssistantState(
        prompt: prompt,
        loading: loading,
        tasks: tasks,
        error: error,
        suggestedTime: suggestedTime ?? this.suggestedTime,
      );

  @override List<Object?> get props => [prompt, loading, tasks, error, suggestedTime];
}
