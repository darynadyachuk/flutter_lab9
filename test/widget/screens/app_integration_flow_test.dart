import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab9/widgets/add_task_form.dart';
import 'package:flutter_lab9/widgets/task_card.dart';
import 'package:flutter_lab9/models/todo_item.dart';

void main() {
  group('End-to-End Integration Flow Tests', () {
    testWidgets('Повний цикл: створення задачі -> відображення -> видалення', (
      WidgetTester tester,
    ) async {
      String? submittedTitle;
      var isDeleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AddTaskForm(
                      onSubmit: (title) {
                        setState(() {
                          submittedTitle = title;
                        });
                      },
                    ),
                    const Divider(),
                    if (submittedTitle != null && !isDeleted)
                      TaskCard(
                        task: TodoItem(
                          id: 'int-1',
                          title: submittedTitle!,
                          isCompleted: false,
                          createdAt: DateTime(2026, 6, 1),
                        ),
                        onToggle: () {},
                        onDelete: () {
                          setState(() {
                            isDeleted = true;
                          });
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(AddTaskForm), findsOneWidget);
      expect(find.byType(TaskCard), findsNothing);

      await tester.enterText(find.byType(TextFormField), 'Інтеграційна Таска');
      await tester.tap(find.text('Add Task'));
      await tester.pumpAndSettle();

      expect(find.byType(TaskCard), findsOneWidget);
      expect(find.text('Інтеграційна Таска'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.byType(TaskCard), findsNothing);
      expect(find.text('Інтеграційна Таска'), findsNothing);
    });
  });
}
