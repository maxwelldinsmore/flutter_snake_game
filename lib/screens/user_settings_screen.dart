import 'package:flutter/material.dart';
import '../tempdata.dart' as temp_data;
import '../database.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

enum SnakeColour { green, pink, purple, blue }

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _colourCtrl = TextEditingController();
  final _db = DatabaseService();
  
  String _currentColour = 'green'; // Default colour
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (temp_data.userId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await _db.getUserdataById(temp_data.userId);
      if (data != null && mounted) {
        setState(() {
          _userData = data;
          _usernameCtrl.text = data['username'] ?? temp_data.currentUsername;
          _passwordCtrl.text = data['password'] ?? '';
          _colourCtrl.text = data['colour'] ?? 'green'; // Default to green if no colour set
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    if (temp_data.userId.isEmpty) return;

    try {
      await _db.updateUserdata(temp_data.userId, {
        'username': _usernameCtrl.text,
        'password': _passwordCtrl.text,
        'colour': _currentColour,
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFE4FF19)),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    'password',
                    style: TextStyle(
                      color: Color(0xFFE4FF19),
                      fontSize: 36,
                      fontFamily: 'arcade',
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF4FAC5),
                      hintText: 'Enter password',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // const Text(
                  //   'Snake Colour',
                  //   style: TextStyle(
                  //     color: Color(0xFFE4FF19),
                  //     fontSize: 36,
                  //     fontFamily: 'arcade',
                  //   ),
                  // ),
                  // const SizedBox(height: 6),
                  // Text(
                  //   'Current: $_currentColour',
                  //   style: const TextStyle(
                  //     color: Color(0xFFF4FAC5),
                  //     fontSize: 24,
                  //     fontFamily: 'arcade',
                  //   ),
                  // ),
                  // const SizedBox(height: 6),
                  // Row(
                  //   children: [
                  //     // Snake Colour Radio Buttons
                  //     Wrap(
                  //       spacing: 12,
                  //       runSpacing: 8,
                  //       children: SnakeColour.values.map((value) {
                  //         return Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Radio<String>(
                  //               value: value.name,
                  //               groupValue: _currentColour,
                  //               activeColor: const Color(0xFFE4FF19),
                  //               onChanged: (val) {
                  //                 setState(() {
                  //                   _currentColour = val!;
                  //                 });
                  //               },
                  //             ),
                  //             Text(
                  //               value.name,
                  //               style: const TextStyle(
                  //                 color: Color(0xFFF4FAC5),
                  //                 fontSize: 20,
                  //                 fontFamily: 'arcade',
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       }).toList(),
                  //     )
                  //   ],
                  // ),
                  // TextField(
                  //   controller: _colourCtrl,
                  //   keyboardType: TextInputType.visiblePassword,
                  //   style: const TextStyle(color: Colors.black),
                  //   decoration: const InputDecoration(
                  //     filled: true,
                  //     fillColor: Color(0xFFF4FAC5),
                  //     hintText: 'Enter password',
                  //     border: OutlineInputBorder(borderSide: BorderSide.none),
                  //     contentPadding: EdgeInsets.all(10),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE4FF19),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 28, fontFamily: 'arcade')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
