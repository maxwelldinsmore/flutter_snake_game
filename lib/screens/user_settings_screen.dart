import 'package:flutter/material.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'User Settings',
                style: TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 48,
                  fontFamily: 'arcade',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Username',
              style: TextStyle(
                color: Color(0xFFE4FF19),
                fontSize: 36,
                fontFamily: 'arcade',
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _usernameCtrl,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4FAC5),
                hintText: 'Enter username',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Email',
              style: TextStyle(
                color: Color(0xFFE4FF19),
                fontSize: 36,
                fontFamily: 'arcade',
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4FAC5),
                hintText: 'Enter email',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Change avatar logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE4FF19),
                foregroundColor: Colors.black,
              ),
              child: const Text('Change Avatar', style: TextStyle(fontSize: 28, fontFamily: 'arcade')),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save settings logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE4FF19),
                foregroundColor: Colors.black,
              ),
              child: const Text('Save', style: TextStyle(fontSize: 28, fontFamily: 'arcade')),
            ),
          ],
        ),
      ),
    );
  }
}
