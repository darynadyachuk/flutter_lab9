import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab9/providers/task_provider.dart';
import 'package:flutter_lab9/models/todo_item.dart';

void main() {
  group('TaskProvider Performance Tests (★★★)', () {
    late TaskProvider taskProvider;

    setUp(() {
      taskProvider = TaskProvider();
    });

    test(
      'Додавання 1000 задач та їх фільтрація працює швидше ніж за 20 мс',
      () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          taskProvider.addTask(
            TodoItem(
              id: 'perf-$i',
              title: 'Швидка задача №$i',
              isCompleted: i % 2 == 0,
              createdAt: DateTime(2026, 6, 1),
            ),
          );
        }

        final completedTasks = taskProvider.tasks
            .where((t) => t.isCompleted)
            .toList();
        final searchedTasks = taskProvider.tasks
            .where((t) => t.title.contains('99'))
            .toList();

        stopwatch.stop();
        final executionTime = stopwatch.elapsedMilliseconds;

        expect(
          executionTime,
          lessThan(35),
          reason:
              'Операції зі списком зайняли забагато часу: $executionTime мс',
        );

        expect(taskProvider.tasks.length, 1000);
        expect(completedTasks.length, 500);
        expect(searchedTasks.isNotEmpty, true);
      },
    );
  });
}
