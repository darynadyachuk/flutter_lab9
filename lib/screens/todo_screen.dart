import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../services/storage_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final StorageService _storage = StorageService();

  List<TodoItem> _todos = [];
  final TextEditingController _textController = TextEditingController();
  bool _isDarkMode = false;
  bool _isLoading = true;

  static const List<String> _categories = ['Work', 'Personal', 'Shopping'];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final todos = await _storage.loadTodos();
    final isDarkMode = _storage.loadThemeMode();
    setState(() {
      _todos = todos;
      _isDarkMode = isDarkMode;
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    await _storage.saveTodos(_todos);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💾 Saved successfully'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _addTodo() {
    if (_textController.text.trim().isEmpty) return;

    final newTodo = TodoItem(
      id: DateTime.now().toString(),
      title: _textController.text.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
      category: _selectedCategory,
    );

    setState(() {
      _todos.add(newTodo);
      _selectedCategory = null;
    });

    _textController.clear();
    _saveData();
  }

  void _toggleTodo(TodoItem todo) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      }
    });
    _saveData();
  }

  void _deleteTodo(TodoItem todo) {
    setState(() {
      _todos.removeWhere((t) => t.id == todo.id);
    });
    _saveData();
  }

  void _clearCompleted() {
    setState(() {
      _todos.removeWhere((todo) => todo.isCompleted);
    });
    _saveData();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _storage.saveThemeMode(_isDarkMode);
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'Work':
        return Colors.blue.shade100;
      case 'Personal':
        return Colors.green.shade100;
      case 'Shopping':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getCategoryTextColor(String? category) {
    switch (category) {
      case 'Work':
        return Colors.blue.shade900;
      case 'Personal':
        return Colors.green.shade900;
      case 'Shopping':
        return Colors.orange.shade900;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Todo List'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: const InputDecoration(
                                  hintText: 'Add new task...',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (_) => _addTodo(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              icon: const Icon(Icons.add),
                              onPressed: _addTodo,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildCategorySelector(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '📋 Tasks (${_todos.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _todos.isEmpty
                        ? _buildEmptyState()
                        : _buildTodoList(),
                  ),
                  _buildFooter(),
                ],
              ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _categories.map((String category) {
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: _getCategoryColor(category),
              checkmarkColor: _getCategoryTextColor(category),
              labelStyle: TextStyle(
                color: isSelected
                    ? _getCategoryTextColor(category)
                    : (_isDarkMode ? Colors.white70 : Colors.black87),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (bool selected) {
                setState(() {
                  _selectedCategory = selected ? category : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No tasks yet!',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first task above',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => _toggleTodo(todo),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                if (todo.category != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(todo.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      todo.category!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryTextColor(todo.category),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTodo(todo),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    final completedCount = _todos.where((t) => t.isCompleted).length;
    final lastSaveTime = _storage.getLastSaveTime();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('✅ Completed: $completedCount/${_todos.length}'),
              if (lastSaveTime != null)
                Text(
                  '💾 Last saved: $lastSaveTime',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
          if (completedCount > 0) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _clearCompleted,
                child: const Text('Clear All Completed'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
