import 'package:flutter/material.dart';
import '../database.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final username = _usernameCtrl.text.trim();
      final password = _passwordCtrl.text;
      await _db.createUserdata({'username': username, 'password': password});
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = 'Register error: $e';
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
          // SNAKE Logo at the top
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'lib/assets/svg/SnakeLogo2.png',
                height: 150,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFFFF0000),
                      fontSize: 48,
                      fontFamily: 'arcade',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // const Text(
                  //   'sign up',
                  //   style: TextStyle(
                  //     color: Color(0xFFE4FF19),
                  //     fontSize: 36,
                  //     fontFamily: 'arcade',
                  //   ),
                  // ),
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
                        hintText: 'Choose a username',
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
                        hintText: 'Choose a password',
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
                  // --- SVG Sign Up Button ---
                  GestureDetector(
                    onTap: _loading ? null : _register,
                    child: SvgPicture.asset(
                      'lib/assets/svg/signup_button.svg',
                      height: 45, // Increase height if needed
                    ),
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
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'log in here',
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
