import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_lab9/services/task_api_service.dart';
@GenerateMocks([http.Client])
import 'task_api_service_test.mocks.dart';

void main() {
  group('TaskApiService (Mock Network Tests)', () {
    late TaskApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = TaskApiService(client: mockClient);
    });

    test('fetchTasks returns list of tasks on success', () async {
      // Arrange
      final mockResponse = '''
        [
          {
            "id": "1",
            "title": "Task 1",
            "isCompleted": false,
            "createdAt": "2026-02-13T10:00:00.000"
          }
        ]
      ''';

      when(
        mockClient.get(Uri.parse('https://api.example.com/tasks')),
      ).thenAnswer((_) async => http.Response(mockResponse, 200));

      // Act
      final tasks = await apiService.fetchTasks();

      // Assert
      expect(tasks.length, 1);
      expect(tasks[0].id, '1');
      expect(tasks[0].title, 'Task 1');
      expect(tasks[0].isCompleted, false);
    });

    test('fetchTasks throws exception on error', () async {
      // Arrange
      when(
        mockClient.get(Uri.parse('https://api.example.com/tasks')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(() => apiService.fetchTasks(), throwsException);
    });

    test('createTask returns created task', () async {
      // Arrange
      final mockResponse = '''
        {
          "id": "2",
          "title": "New Task",
          "isCompleted": false,
          "createdAt": "2026-02-13T10:00:00.000"
        }
      ''';

      when(
        mockClient.post(
          Uri.parse('https://api.example.com/tasks'),
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response(mockResponse, 201));

      // Act
      final task = await apiService.createTask('New Task');

      // Assert
      expect(task.id, '2');
      expect(task.title, 'New Task');
    });
  });
}
