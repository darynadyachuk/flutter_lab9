import 'package:flutter/foundation.dart';
import '../models/todo_item.dart'; // Імпортуємо саме твою модель

enum TaskFilter { all, active, completed }

class TaskProvider extends ChangeNotifier {
  final List<TodoItem> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  List<TodoItem> get tasks => _getFilteredTasks();
  TaskFilter get filter => _filter;

  void addTask(TodoItem task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  List<TodoItem> _getFilteredTasks() {
    switch (_filter) {
      case TaskFilter.active:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return _tasks;
    }
  }
}
