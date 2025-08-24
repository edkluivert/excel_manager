import 'package:excel_manager/application/ai/ai_assistant_cubit.dart';
import 'package:excel_manager/application/task/task_cubit.dart';
import 'package:excel_manager/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({
    required this.projectId,
    required this.aiAssistantCubit,
    required this.taskCubit,
    super.key,});

  final String projectId;
  final AiAssistantCubit aiAssistantCubit;
  final TaskCubit taskCubit;


  @override State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {


  final _ctrl = TextEditingController(
      text: 'Plan my week with 3 work tasks and 2 wellness tasks.');


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.aiAssistantCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('AI Assistant')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'Describe the tasks you want…',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => widget.aiAssistantCubit.generate(_ctrl.text),
                ),
              ),
              minLines: 1, maxLines: 4,
            ),
            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<AiAssistantCubit, AiAssistantState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  if (state.tasks.isEmpty) {
                    return const Center(child: Text('No suggestions yet'));
                  }
                  return ListView.separated(
                    itemCount: state.tasks.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, i) {
                      final t = state.tasks[i];
                      return ListTile(
                        title: Text(t.title),
                        subtitle: Text([
                          if (t.note != null) t.note!,
                          'Priority: ${t.priority.name}',
                          if (t.dueAt != null) 'Due: ${t.dueAt}',
                        ].join(' • ')),
                        trailing: ElevatedButton(
                          child: const Text('Import'),
                          onPressed: () async {
                            widget.taskCubit.addTask(
                              TaskAdapter.fromGenerated(t,
                                  widget.projectId,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Imported')));

                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
