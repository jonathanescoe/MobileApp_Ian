import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ian Profile App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProfileScreen(),
    );
  }
}

// MAIN PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // PROFILE ICON
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 45)),

            const SizedBox(height: 15),

            // NAME
            const Text(
              'Ian',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Computing Student',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // LOCATION AND EMAIL
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Colors.red),
                Text(' Newnan, GA   '),
                Icon(Icons.email, color: Colors.blue),
                Text(' ian@westga.com'),
              ],
            ),

            const SizedBox(height: 20),

            // BUTTONS
            OutlinedButton(
              onPressed: () {},
              child: const Text('Follow me please'),
            ),

            OutlinedButton(
              onPressed: () {},
              child: const Text('Send me a message'),
            ),
          ],
        ),
      ),
    );
  }
}
