import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lab9/utils/validators.dart';

void main() {
  group('Validators Logic Tests', () {
    group('validateTitle', () {
      test('має повертати null для валідного тайтлу (>= 3 символів)', () {
        final result = Validators.validateTitle('Купити молоко');
        expect(result, isNull);
      });

      test('має повертати помилку, якщо тайтл порожній або з пробілів', () {
        final resultEmpty = Validators.validateTitle('');
        final resultSpaces = Validators.validateTitle('   ');

        expect(resultEmpty, equals('Title cannot be empty'));
        expect(resultSpaces, equals('Title cannot be empty'));
      });

      test('має повертати помилку, якщо тайтл менше 3 символів', () {
        final result = Validators.validateTitle('Ок');
        expect(result, equals('Title must be at least 3 characters'));
      });
    });

    group('validateEmail', () {
      test('має повертати null для правильного формату email', () {
        final result = Validators.validateEmail('test@example.com');
        expect(result, isNull);
      });

      test('має повертати помилку для порожнього email', () {
        final result = Validators.validateEmail('');
        expect(result, equals('Email cannot be empty'));
      });

      test('має повертати помилку для неправильного формату email', () {
        final result = Validators.validateEmail('invalid-email.com');
        expect(result, equals('Invalid email format'));
      });
    });

    group('isTaskOverdue', () {
      test('має повертати true, якщо дата в минулому (задача прострочена)', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final result = Validators.isTaskOverdue(yesterday);

        expect(result, isTrue);
      });

      test('має повертати false, якщо дата в майбутньому', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final result = Validators.isTaskOverdue(tomorrow);

        expect(result, isFalse);
      });
    });
  });
}
