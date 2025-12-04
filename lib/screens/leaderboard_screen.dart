import 'package:flutter/material.dart';
import '../database.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardStateScreen();
}

class _LeaderboardStateScreen extends State<LeaderboardScreen> {
  final DatabaseService _db = DatabaseService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _leaderboardData = [];

  final List<Color> _colors = [
    const Color(0xFFFCFFE3),
    const Color(0xFF2BDEAF),
    const Color(0xFFE4FF19),
    const Color(0xFF4E7EE5),
    const Color(0xFFED1212),
  ];

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      final allUsers = await _db.getUserdataOnce();
      
      // Sort by score (descending), default score to 0 if not set
      allUsers.sort((a, b) {
        final scoreA = a['score'] ?? 0;
        final scoreB = b['score'] ?? 0;
        return scoreB.compareTo(scoreA);
      });

      if (mounted) {
        setState(() {
          _leaderboardData = allUsers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE4FF19),
          ),
        ),
      );
    }

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
            child: _leaderboardData.isEmpty
                ? const Center(
                    child: Text(
                      'No scores yet',
                      style: TextStyle(
                        color: Color(0xFFE4FF19),
                        fontSize: 24,
                        fontFamily: 'arcade',
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _leaderboardData.length,
                    itemBuilder: (context, index) {
                      final entry = _leaderboardData[index];
                      final rank = (index + 1).toString();
                      final score = (entry['score'] ?? 0).toString();
                      final username = entry['username'] ?? 'Unknown';
                      final color = _colors[index % _colors.length];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                rank,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 24,
                                  fontFamily: 'arcade',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                score,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 24,
                                  fontFamily: 'arcade',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                username,
                                style: TextStyle(
                                  color: color,
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
