import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab9/widgets/task_card.dart';
import 'package:flutter_lab9/models/todo_item.dart';

void main() {
  group('TaskCard Golden Tests', () {
    testWidgets('Картка задачі виглядає ідеально', (WidgetTester tester) async {
      final task = TodoItem(
        id: 'golden-1',
        title: 'Купити молока',
        isCompleted: false,
        createdAt: DateTime(2026, 6, 1),
      );

      tester.view.physicalSize = const Size(400, 150);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TaskCard(task: task, onToggle: () {}, onDelete: () {}),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(TaskCard),
        matchesGoldenFile('goldens/task_card_perfect.png'),
      );
    });
  });
}
