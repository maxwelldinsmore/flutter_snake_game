import 'package:flutter/material.dart';
import '../snake_game.dart';
import '../database.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onTabChange;
  const HomeScreen({super.key, this.onTabChange});

  Future<void> _signOut(BuildContext context) async {
    final db = DatabaseService();
    try {
      await db.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/svg/SnakeLogo2.png',
                  height: 150,
                ),
                const SizedBox(height: 24),
                _buildMenuItem(context, 'Play', const Color(0xFFE4FF19), () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SnakeGame()),
                  );
                }),
                const SizedBox(height: 12),
                _buildMenuItem(context, 'Game Settings', const Color(0xFF4E7EE5), () {
                  onTabChange?.call(2); // Navigate to game settings tab (index 2)
                }),
                const SizedBox(height: 12),
                _buildMenuItem(context, 'Leaderboard', const Color(0xFFED1212), () {
                  onTabChange?.call(3); // Navigate to leaderboard tab (index 3)
                }),
                const Spacer(),
                // --- Sign Out Button ---
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _signOut(context),
                    child: const Text(
                      'sign out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'arcade',
                      ),
                    ),
                  ),
                ),
                const Text(
                  'made by: alyssa - maxwell - bilgan - shanice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'arcade',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // User Settings Icon in top right
          Positioned(
            top: 24,
            right: 24,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 32),
              onPressed: () {
                onTabChange?.call(1); // Navigate to user settings tab (index 1)
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 36,
          fontFamily: 'arcade',
        ),
      ),
    );
  }
}



// NOTE: commands to run the snake game
// import 'package:flutter/material.dart';
// import 'snake_game.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SnakeGame(),
//     );
//   }
// }