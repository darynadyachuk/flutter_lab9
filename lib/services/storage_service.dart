import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';

class StorageService {
  static const String _todosKey = 'todos';
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _lastSaveTimeKey = 'lastSaveTime';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveTodos(List<TodoItem> todos) async {
    try {
      final List<Map<String, dynamic>> todosJson = todos
          .map((todo) => todo.toJson())
          .toList();
      final String jsonString = json.encode(todosJson);
      await _prefs?.setString(_todosKey, jsonString);
      await _prefs?.setString(
        _lastSaveTimeKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      print('Error saving todos: $e');
    }
  }

  Future<List<TodoItem>> loadTodos() async {
    try {
      final String? jsonString = _prefs?.getString(_todosKey);
      if (jsonString == null) return [];
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => TodoItem.fromJson(json)).toList();
    } catch (e) {
      print('Error loading todos: $e');
      return [];
    }
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _prefs?.setBool(_isDarkModeKey, isDarkMode);
  }

  bool loadThemeMode() {
    return _prefs?.getBool(_isDarkModeKey) ?? false;
  }

  String? getLastSaveTime() {
    final String? timeString = _prefs?.getString(_lastSaveTimeKey);
    if (timeString == null) return null;

    final DateTime time = DateTime.parse(timeString);
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
