import 'package:flutter/material.dart';
import 'package:flutter_snake_game/snake_game.dart%20';
import '../snake_game.dart' as snake_game;

class GameSettingsScreen extends StatefulWidget {
  const GameSettingsScreen({super.key});

  @override
  State<GameSettingsScreen> createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  GridSize _gridSize = GridSize.medium;
  SnakeSpeed _snakeSpeed = SnakeSpeed.medium;
  AppleSpawnRate _appleSpawnRate = AppleSpawnRate.normal;
  GameTheme _gameTheme = GameTheme.retro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                'Grid  Size',
                style: TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 36,
                  fontFamily: 'arcade',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Grid Size Radio Buttons
                  _buildRadio<GridSize>(
                      groupValue: _gridSize,
                      values: GridSize.values,
                      labelBuilder: (val) => val.name,
                      onChanged: (val) {
                        setState(() {
                          _gridSize = val!;
                        });
                      snake_game.SnakeGame();}
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Snake  Speed',
                style: TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 36,
                  fontFamily: 'arcade',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Snake Speed Radio Buttons
                  _buildRadio('slow',
                      'Slow',
                      _snakeSpeed,
                          (val) => setState(() => _snakeSpeed = val!)),
                  const SizedBox(width: 16),
                  _buildRadio('medium',
                      'Medium',
                      _snakeSpeed,
                          (val) => setState(() => _snakeSpeed = val!)),
                  const SizedBox(width: 16),
                  _buildRadio('fast',
                      'Fast',
                      _snakeSpeed,
                          (val) => setState(() => _snakeSpeed = val!)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Apple  Spawn  Rate',
                style: TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 36,
                  fontFamily: 'arcade',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildRadio('normal',
                      'Normal',
                      _appleSpawnRate,
                          (val) => setState(() => _appleSpawnRate = val!)),
                  const SizedBox(width: 16),
                  _buildRadio('fast',
                      'Fast',
                      _appleSpawnRate,
                          (val) => setState(() => _appleSpawnRate = val!)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Game  Theme',
                style: TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 36,
                  fontFamily: 'arcade',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildRadio('retro',
                      'Retro',
                      _gameTheme,
                          (val) => setState(() => _gameTheme = val!)),
                  const SizedBox(width: 16),
                  _buildRadio('dark',
                      'Dark',
                      _gameTheme,
                          (val) => setState(() => _gameTheme = val!)),
                  const SizedBox(width: 16),
                  _buildRadio('light',
                      'Light',
                      _gameTheme,
                          (val) => setState(() => _gameTheme = val!)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // generic radio button builder that works with enums, dynamically
  // building labels
  Widget _buildRadio<T extends Enum>({required T groupValue,
    required Function (T?) onChanged,
    required List<T> values,
    required String Function(T) labelBuilder}) {
      return Column(
        children: values.map((value) {
          return Row(
            children: [
              Radio<T>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: const Color(0xFFE4FF19),
              ),
              Text(
                labelBuilder(value),
                style: const TextStyle(
                  color: Color(0xFFE4FF19),
                  fontSize: 24,
                  fontFamily: 'arcade',
                ),
              ),
            ],
          );
          }).toList(),
      );
  }
}
