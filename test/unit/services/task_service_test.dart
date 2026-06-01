import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab9/models/todo_item.dart';
import 'package:flutter_lab9/providers/task_provider.dart';

void main() {
  group('TaskProvider (State Management Tests)', () {
    late TaskProvider provider;
    final testDate = DateTime(2026, 2, 13);

    setUp(() {
      provider = TaskProvider();
    });

    test('initial state is empty', () {
      expect(provider.tasks, isEmpty);
      expect(provider.filter, TaskFilter.all);
    });

    test('addTask adds task to list', () {
      final task = TodoItem(
        id: '1',
        title: 'Test Task',
        isCompleted: false,
        createdAt: testDate,
      );

      provider.addTask(task);

      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.id, '1');
    });

    test('removeTask removes task from list', () {
      final task = TodoItem(
        id: '1',
        title: 'Test Task',
        isCompleted: false,
        createdAt: testDate,
      );
      provider.addTask(task);
      provider.removeTask('1');

      expect(provider.tasks, isEmpty);
    });

    test('toggleTask changes isCompleted status', () {
      final task = TodoItem(
        id: '1',
        title: 'Test Task',
        isCompleted: false,
        createdAt: testDate,
      );
      provider.addTask(task);
      provider.toggleTask('1');

      expect(provider.tasks.first.isCompleted, true);
    });

    test('setFilter filters tasks correctly', () {
      provider.addTask(
        TodoItem(
          id: '1',
          title: 'Active Task',
          isCompleted: false,
          createdAt: testDate,
        ),
      );
      provider.addTask(
        TodoItem(
          id: '2',
          title: 'Completed Task',
          isCompleted: true,
          createdAt: testDate,
        ),
      );

      provider.setFilter(TaskFilter.active);
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.id, '1');

      provider.setFilter(TaskFilter.completed);
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.id, '2');
    });
  });
}
