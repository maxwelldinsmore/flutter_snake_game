import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data - replace with real data from database
    final entries = [
      {'rank': '1', 'score': '9999', 'username': 'PlayerOne', 'color': const Color(0xFFFCFFE3)},
      {'rank': '2', 'score': '8888', 'username': 'ProSnake', 'color': const Color(0xFF2BDEAF)},
      {'rank': '3', 'score': '7777', 'username': 'GameMaster', 'color': const Color(0xFFE4FF19)},
      {'rank': '4', 'score': '6666', 'username': 'SnakeKing', 'color': const Color(0xFF4E7EE5)},
      {'rank': '5', 'score': '5555', 'username': 'TopPlayer', 'color': const Color(0xFFED1212)},
    ];

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            'leaderboard',
            style: TextStyle(
              color: Color(0xFFED1212),
              fontSize: 48,
              fontFamily: 'arcade',
            ),
          ),
          const SizedBox(height: 16),
          // Header row
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: Text(
                  'Rank',
                  style: TextStyle(
                    color: Color(0xFFE4FF19),
                    fontSize: 24,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  'Score',
                  style: TextStyle(
                    color: Color(0xFFE4FF19),
                    fontSize: 24,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              const Expanded(
                flex: 3,
                child: Text(
                  'Username',
                  style: TextStyle(
                    color: Color(0xFFE4FF19),
                    fontSize: 24,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Leaderboard entries
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          entry['rank'] as String,
                          style: TextStyle(
                            color: entry['color'] as Color,
                            fontSize: 24,
                            fontFamily: 'arcade',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry['score'] as String,
                          style: TextStyle(
                            color: entry['color'] as Color,
                            fontSize: 24,
                            fontFamily: 'arcade',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry['username'] as String,
                          style: TextStyle(
                            color: entry['color'] as Color,
                            fontSize: 24,
                            fontFamily: 'arcade',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
