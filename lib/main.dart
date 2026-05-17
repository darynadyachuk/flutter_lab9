import 'package:flutter/material.dart';
import 'screens/todo_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  await storage.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<bool> _isDarkMode = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _isDarkMode.value = StorageService().loadThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Todo List',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),

          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const TodoScreen(),
        );
      },
    );
  }

  @override
  void dispose() {
    _isDarkMode.dispose();
    super.dispose();
  }
}
