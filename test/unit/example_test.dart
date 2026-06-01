import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Example test - 1 + 1 should equal 2', () {
    // Arrange (підготовка)
    final a = 1;
    final b = 1;

    // Act (дія)
    final result = a + b;

    // Assert (перевірка)
    expect(result, 2);
  });
}
