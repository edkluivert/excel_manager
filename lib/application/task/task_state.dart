part of 'task_cubit.dart';

class TaskState extends Equatable {
  const TaskState({this.loading = false, this.tasks = const [], this.error});
  final bool loading;
  final List<Task> tasks;
  final String? error;
  TaskState copyWith({bool? loading, List<Task>? tasks, String? error}) =>
      TaskState(loading: loading ?? this.loading, tasks: tasks ?? this.tasks, error: error);
  @override List<Object?> get props => [loading, tasks, error];
}
