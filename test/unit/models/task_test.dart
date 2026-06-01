import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab9/models/todo_item.dart';

void main() {
  group('TodoItem Model Tests', () {
    final testDate = DateTime(2026, 6, 1, 12, 0);

    test('should correctly convert to JSON Map', () {
      // Arrange
      final item = TodoItem(
        id: '1',
        title: 'Купити хліб',
        isCompleted: false,
        createdAt: testDate,
        category: 'Покупки',
      );

      // Act
      final json = item.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Купити хліб');
      expect(json['isCompleted'], false);
      expect(json['createdAt'], testDate.toIso8601String());
      expect(json['category'], 'Покупки');
    });

    test('should correctly create instance from JSON Map', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': '2',
        'title': 'Прибрати кімнату',
        'isCompleted': true,
        'createdAt': testDate.toIso8601String(),
        'category': 'Дім',
      };

      // Act
      final item = TodoItem.fromJson(json);

      // Assert
      expect(item.id, '2');
      expect(item.title, 'Прибрати кімнату');
      expect(item.isCompleted, true);
      expect(item.createdAt, testDate);
      expect(item.category, 'Дім');
    });

    test('copyWith should correctly modify specified fields', () {
      // Arrange
      final original = TodoItem(
        id: '1',
        title: 'Стара назва',
        isCompleted: false,
        createdAt: testDate,
      );

      // Act
      final updated = original.copyWith(title: 'Нова назва', isCompleted: true);

      // Assert
      expect(updated.id, original.id);
      expect(updated.title, 'Нова назва');
      expect(updated.isCompleted, true);
      expect(updated.createdAt, original.createdAt);
    });
  });
}
