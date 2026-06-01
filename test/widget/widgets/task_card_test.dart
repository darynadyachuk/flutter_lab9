import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab9/models/todo_item.dart';
import 'package:flutter_lab9/widgets/task_card.dart';

void main() {
  group('TaskCard Widget & Interaction Tests', () {
    late TodoItem testTask;

    setUp(() {
      testTask = TodoItem(
        id: '1',
        title: 'Test Task',
        isCompleted: false,
        createdAt: DateTime(2026, 6, 1),
      );
    });

    testWidgets('displays task title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );
      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('displays checkbox', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('checkbox reflects isCompleted state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask.copyWith(isCompleted: true),
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('displays delete button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('checkbox tap calls onToggle', (WidgetTester tester) async {
      // Arrange
      var toggleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onToggle: () {
                toggleCalled = true;
              },
              onDelete: () {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      expect(toggleCalled, true);
    });

    testWidgets('delete button tap calls onDelete', (
      WidgetTester tester,
    ) async {
      // Arrange
      var deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onToggle: () {},
              onDelete: () {
                deleteCalled = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Assert
      expect(deleteCalled, true);
    });

    testWidgets('completed task shows strikethrough', (
      WidgetTester tester,
    ) async {
      // Arrange
      final completedTask = testTask.copyWith(isCompleted: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: completedTask,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Act
      final text = tester.widget<Text>(find.text('Test Task'));

      // Assert
      expect(text.style?.decoration, TextDecoration.lineThrough);
    });
  });
}
