import 'package:excel_manager/application/ai/ai_assistant_cubit.dart';
import 'package:excel_manager/domain/entities/task.dart';
import 'package:excel_manager/presentation/screens/tasks/task_editor_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

// Mock AiAssistantCubit and AiAssistantState
class MockAiAssistantCubit extends Mock implements AiAssistantCubit {}
class MockAiAssistantState extends Mock implements AiAssistantState {}

void main() {
  late MockAiAssistantCubit mockAiAssistantCubit;
  late DateFormat dateFormat;

  setUp(() {
    mockAiAssistantCubit = MockAiAssistantCubit();
    dateFormat = DateFormat('EEE, MMM d, yyyy – hh:mm a');

    // Stub the state of the mock cubit
    when(() => mockAiAssistantCubit.state).thenReturn(MockAiAssistantState());
  });

  group('TaskEditorBottomSheet', () {
    testWidgets('renders new task form', (WidgetTester tester) async {
      await tester.pumpMaterialApp(
        BlocProvider.value(
          value: mockAiAssistantCubit,
          child: TaskEditorBottomSheet(aiAssistantCubit: mockAiAssistantCubit),
        ),
      );

      expect(find.text('New Task'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('No due date'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text('Suggest New Time'), findsOneWidget);
      expect(find.text('Save Task'), findsOneWidget);
    });

    testWidgets('renders edit task form with existing task', (WidgetTester tester) async {
      final task = Task(
        id: '1',
        projectId: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dueAt: DateTime.now().add(const Duration(days: 1)),
      );

      await tester.pumpMaterialApp(
        BlocProvider.value(
          value: mockAiAssistantCubit,
          child: TaskEditorBottomSheet(aiAssistantCubit: mockAiAssistantCubit, task: task),
        ),
      );

      expect(find.text('Edit Task'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Test Task'), findsOneWidget);
      expect(find.text(dateFormat.format(task.dueAt!)), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text('Suggest New Time'), findsOneWidget);
      expect(find.text('Update Task'), findsOneWidget);
    });

    testWidgets('updates due date on calendar tap', (WidgetTester tester) async {
      final task = Task(
        id: '1',
        projectId: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dueAt: DateTime.now().add(const Duration(days: 1)),
      );

      await tester.pumpMaterialApp(
        BlocProvider.value(
          value: mockAiAssistantCubit,
          child: TaskEditorBottomSheet(aiAssistantCubit: mockAiAssistantCubit, task: task),
        ),
      );

      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      // picking a new date
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });

    testWidgets('updates priority on dropdown change', (WidgetTester tester) async {
      final task = Task(
        id: '1',
        projectId: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dueAt: DateTime.now().add(const Duration(days: 1)),
      );

      await tester.pumpMaterialApp(
        BlocProvider.value(
          value: mockAiAssistantCubit,
          child: TaskEditorBottomSheet(aiAssistantCubit: mockAiAssistantCubit, task: task),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('High').last);
      await tester.pumpAndSettle();

      expect(find.text('High'), findsOneWidget);
    });

    testWidgets('calls suggestNewTime on button press', (WidgetTester tester) async {
      final task = Task(
        id: '1',
        projectId: '1',
        title: 'Test Task',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dueAt: DateTime.now().add(const Duration(days: 1)),
      );

      when(() => mockAiAssistantCubit.suggestNewTime(any(), any())).thenAnswer((_) async {});
      when(() => mockAiAssistantCubit.state).thenReturn(MockAiAssistantState());

      await tester.pumpMaterialApp(
        BlocProvider.value(
          value: mockAiAssistantCubit,
          child: TaskEditorBottomSheet(aiAssistantCubit: mockAiAssistantCubit, task: task),
        ),
      );

      await tester.tap(find.text('Suggest New Time'));
      await tester.pumpAndSettle();

      verify(() => mockAiAssistantCubit.suggestNewTime(any(), any())).called(1);
    });
  });
}

// Helper to wrap widget in MaterialApp for testing
extension PumpMaterialApp on WidgetTester {
  Future<void> pumpMaterialApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );
  }
}
