import 'package:flutter/material.dart';

class GameSettingsScreen extends StatefulWidget {
  const GameSettingsScreen({super.key});

  @override
  State<GameSettingsScreen> createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  String _difficulty = 'easy';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Game Settings',
              style: TextStyle(
                color: Color(0xFFE4FF19),
                fontSize: 48,
                fontFamily: 'arcade',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sound',
                style: TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 36,
                  fontFamily: 'arcade',
                ),
              ),
              Switch(
                value: _soundEnabled,
                onChanged: (value) => setState(() => _soundEnabled = value),
                activeColor: const Color(0xFFE4FF19),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Music',
                style: TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 36,
                  fontFamily: 'arcade',
                ),
              ),
              Switch(
                value: _musicEnabled,
                onChanged: (value) => setState(() => _musicEnabled = value),
                activeColor: const Color(0xFFE4FF19),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Difficulty',
            style: TextStyle(
              color: Color(0xFFE4FF19),
              fontSize: 36,
              fontFamily: 'arcade',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildRadio('easy', 'Easy'),
              const SizedBox(width: 16),
              _buildRadio('medium', 'Medium'),
              const SizedBox(width: 16),
              _buildRadio('hard', 'Hard'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(String value, String label) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _difficulty,
          onChanged: (val) => setState(() => _difficulty = val!),
          activeColor: const Color(0xFFE4FF19),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE4FF19),
            fontSize: 24,
            fontFamily: 'arcade',
          ),
        ),
      ],
    );
  }
}
