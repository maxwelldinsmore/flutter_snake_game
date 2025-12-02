import 'package:flutter/material.dart';
import '../snake_game.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onTabChange;
  const HomeScreen({super.key, this.onTabChange});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Snake Game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontFamily: 'arcade',
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(context, 'Play', const Color(0xFFE4FF19), () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SnakeGame()),
              );
            }),
            const SizedBox(height: 12),
            _buildMenuItem(context, 'Settings', const Color(0xFF4E7EE5), () {
              onTabChange?.call(2); // Navigate to game settings tab (index 2)
            }),
            const SizedBox(height: 12),
            _buildMenuItem(context, 'Leaderboard', const Color(0xFFED1212), () {
              onTabChange?.call(3); // Navigate to leaderboard tab (index 3)
            }),
            const Spacer(),
            const Text(
              'made by alyssa - maxwell - bilgan - shanice',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'arcade',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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