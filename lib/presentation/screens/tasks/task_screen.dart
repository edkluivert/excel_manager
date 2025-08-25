import 'package:excel_manager/application/ai/ai_assistant_cubit.dart';
import 'package:excel_manager/application/task/task_cubit.dart';
import 'package:excel_manager/core/di/injector.dart';
import 'package:excel_manager/data/ai/gemini_ai_service.dart';
import 'package:excel_manager/data/ai/mock_ai_service.dart';
import 'package:excel_manager/data/ai/open_ai_service.dart';
import 'package:excel_manager/domain/entities/task.dart';
import 'package:excel_manager/domain/repositories/task_repo.dart';
import 'package:excel_manager/presentation/screens/ai/ai_assistant_screen.dart';
import 'package:excel_manager/presentation/screens/tasks/task_editor_bottom_sheet.dart';
import 'package:excel_manager/services/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class TaskScreen extends StatefulWidget {

  const TaskScreen({required this.projectName, super.key,});
  final String projectName;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  late AiAssistantCubit aiAssistantCubit;
  late TaskCubit taskCubit;


  @override
  void initState() {
    super.initState();
    aiAssistantCubit = AiAssistantCubit(sl<MockAiService>(),
        sl<OpenAiService>(), sl<GeminiAiService>());
    taskCubit = TaskCubit(sl<TaskRepository>(), sl<NotificationService>(),
        widget.projectName);

    taskCubit.load();
  }


  Future<void> _openTaskEditor([Task? task]) async {
    final result = await showModalBottomSheet<Task>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TaskEditorBottomSheet(
          aiAssistantCubit: aiAssistantCubit,
          task: task,
        );
      },
    );

    if (result != null) {

      final finalTask = result.copyWith(projectId: widget.projectName);

      if (task == null) {
        taskCubit.addTask(finalTask);
      } else {
        taskCubit.updateTask(finalTask);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: aiAssistantCubit,
        ),
        BlocProvider.value(
          value: taskCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.projectName),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  taskCubit.load();
                },
              ),
              const SizedBox(width: 8),
              InkResponse(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          AiAssistantScreen(
                              projectId: widget.projectName,
                              aiAssistantCubit: aiAssistantCubit,
                              taskCubit: taskCubit
                          ),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/icons/ai.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 16),
            ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openTaskEditor,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        body:  BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if(state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if(state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }

            return state.tasks.isEmpty ?
            const Center(child: Text('No tasks available. Tap + to add.')) :
            ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Animate(
                  effects: [
                    FadeEffect(duration: 300.ms),
                    SlideEffect(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                      duration: 300.ms,
                      delay: (index * 100).ms,
                    ),
                  ],
                  child: Dismissible(
                    key: ValueKey(task),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      taskCubit.deleteTask(task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$task deleted')),
                      );
                    },
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text('Priority: ${task.priority.name}'),
                      trailing: Checkbox(
                        value: task.completed,
                        onChanged: (val) {
                         taskCubit.toggleComplete(task);
                        },
                      ),
                      onTap: () => _openTaskEditor(task),
                      
                    ),
                  ),
                );
              },
            );
          },
        ),

      ),
    );
  }
}
