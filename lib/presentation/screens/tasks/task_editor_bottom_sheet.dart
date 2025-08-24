import 'package:excel_manager/application/ai/ai_assistant_cubit.dart';
import 'package:excel_manager/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskEditorBottomSheet extends StatefulWidget {
  const TaskEditorBottomSheet({
    required this.aiAssistantCubit,
    this.task,
    super.key,
  });

  final Task? task;
  final AiAssistantCubit aiAssistantCubit;

  @override
  State<TaskEditorBottomSheet> createState() => _TaskEditorBottomSheetState();
}

class _TaskEditorBottomSheetState extends State<TaskEditorBottomSheet> {
  late TextEditingController titleController;
  late DateTime? currentDueAt;
  late String currentPriority;

  final List<String> priorities = ['Low', 'Medium', 'High'];
  final dateFormat = DateFormat('EEE, MMM d, yyyy – hh:mm a');

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    currentDueAt = widget.task?.dueAt;
    currentPriority = widget.task == null
        ? 'Low'
        : widget.task!.priority == Priority.low
        ? 'Low'
        : widget.task!.priority == Priority.medium
        ? 'Medium'
        : 'High';
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  String _formatDueDate(DateTime? dueAt) {
    if (dueAt == null) return "No due date";
    return dateFormat.format(dueAt);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final now = DateTime.now();
    final isOverdue = currentDueAt != null && currentDueAt!.isBefore(now);

    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? "Edit Task" : "New Task",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Text(
                  _formatDueDate(currentDueAt),
                  style: isOverdue ? TextStyle(
                    color:  Colors.red ,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ) :  Theme.of(context).textTheme.bodyLarge!,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: currentDueAt ?? now,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => currentDueAt = picked);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: currentPriority,
              items: priorities
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => currentPriority = val);
              },
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Suggestion button (AI time suggestion)
            TextButton.icon(
              icon: const Icon(Icons.schedule),
              label: const Text('Suggest New Time'),
              onPressed: () async {
                final cubit = widget.aiAssistantCubit;
                await cubit.suggestNewTime(titleController.text, currentDueAt);
                final when = cubit.state.suggestedTime;
                if (when != null) {
                  setState(() => currentDueAt = when);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Suggested: ${dateFormat.format(when)}')),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                final now = DateTime.now();

                final task = (widget.task ?? Task(
                  id: now.millisecondsSinceEpoch.toString(),
                  projectId: '', // will be injected later
                  title: '',
                  createdAt: now,
                  updatedAt: now,
                  priority: Priority.low,
                )).copyWith(
                  title: titleController.text,
                  dueAt: currentDueAt,
                  priority: currentPriority == 'Medium'
                      ? Priority.medium
                      : currentPriority == 'High'
                      ? Priority.high
                      : Priority.low,
                  updatedAt: now,
                );

                Navigator.of(context).pop(task);
              },
              child: Text(isEditing ? 'Update Task' : 'Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
