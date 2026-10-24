import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'data_providers/time_entry_provider.dart';
import 'pages/project_management_screen.dart';
import 'pages/home_screen.dart';
import 'pages/task_management_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(), // Main entry point, HomeScreen
          '/manage_projects': (context) =>
              ProjectManagementScreen(), // Route for managing projects
          '/manage_tasks': (context) =>
              TaskManagementScreen(), // Route for managing tasks
        },
        // Removed 'home:' since 'initialRoute' is used to define the home route
      ),
    );
  }
}
