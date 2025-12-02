import 'package:flutter/material.dart';
import '../database.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import '../tempdata.dart' as temp_data;
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _db = DatabaseService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final username = _usernameCtrl.text.trim();
      final password = _passwordCtrl.text;
      final user = await _db.authenticateUser(username, password);
      if (user != null) {
        // On success navigate to main screen
        if (!mounted) return;
        temp_data.isLoggedIn = true;
        temp_data.currentUsername = username;
        temp_data.userId = user['id'] ?? '';
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
      } else {
        setState(() {
          _error = 'Invalid username or password';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Login error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Log In',
                    style: TextStyle(
                      color: Color(0xFFE4FF19),
                      fontSize: 48,
                      fontFamily: 'arcade',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'log in',
                    style: TextStyle(
                      color: Color(0xFFE4FF19),
                      fontSize: 36,
                      fontFamily: 'arcade',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Username',
                    style: TextStyle(
                      color: Color(0xFFE4FF19),
                      fontSize: 36,
                      fontFamily: 'arcade',
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: _usernameCtrl,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF4FAC5),
                        hintText: 'Enter username',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Color(0xFFE4FF19),
                      fontSize: 36,
                      fontFamily: 'arcade',
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF4FAC5),
                        hintText: 'Enter password',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_error != null) ...[
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                  ],
                  ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE4FF19),
                      foregroundColor: Colors.black,
                    ),
                    child: _loading ? const CircularProgressIndicator() : const Text('LOG IN', style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
              },
              child: const Text(
                'sign up here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 36,
                  fontFamily: 'arcade',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
