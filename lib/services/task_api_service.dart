import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_item.dart';

class TaskApiService {
  final http.Client client;

  TaskApiService({required this.client});

  Future<List<TodoItem>> fetchTasks() async {
    final response = await client.get(
      Uri.parse('https://api.example.com/tasks'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TodoItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<TodoItem> createTask(String title) async {
    final response = await client.post(
      Uri.parse('https://api.example.com/tasks'),
      body: jsonEncode({'title': title}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return TodoItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }
}
