import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Represents one task from the REST endpoint.
class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }
}

// Fetches tasks when the todo screen watches this provider.
final todosProvider = FutureProvider<List<Todo>>((ref) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/todos'),
  );

  if (response.statusCode != 200) {
    throw Exception('Unable to load tasks.');
  }

  final data = jsonDecode(response.body) as List<dynamic>;

  return data
      .map((item) => Todo.fromJson(item as Map<String, dynamic>))
      .toList();
});

void main() {
  runApp(const ProviderScope(child: TodoApp()));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ian Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFD7BFFF)),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Flutter Todo App!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap the button below to fetch and view todos '
                'from the REST API.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Todo List'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const TodoScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: todos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Could not load tasks. Please try again.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(todosProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (tasks) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: task.completed
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  child: Icon(
                    task.completed ? Icons.check : Icons.access_time,
                    color: task.completed ? Colors.green : Colors.orange,
                  ),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.completed ? Colors.grey : null,
                  ),
                ),
                subtitle: Text('Task ID: ${task.id} | User ID: ${task.userId}'),
                trailing: Checkbox(value: task.completed, onChanged: null),
              ),
            );
          },
        ),
      ),
    );
  }
}
