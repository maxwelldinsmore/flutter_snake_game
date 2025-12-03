import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_provider.dart';
import '../snake_game.dart';

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
                        context.read<AppProvider>().updateGridSize(val!);
                        }
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
                  _buildRadio<SnakeSpeed>(
                      groupValue: _snakeSpeed,
                      values: SnakeSpeed.values,
                      labelBuilder: (val) => val.name,
                      onChanged: (val) {
                        setState(() {
                          _snakeSpeed = val!;
                        });
                        context.read<AppProvider>().updateSnakeSpeed(val!);
                      }
                  )
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
                  // Apple Spawn Rate Radio Buttons
                  _buildRadio<AppleSpawnRate>(
                      groupValue: _appleSpawnRate,
                      values: AppleSpawnRate.values,
                      labelBuilder: (val) => val.name,
                      onChanged: (val) {
                        setState(() {
                          _appleSpawnRate = val!;
                        });
                        context.read<AppProvider>().updateAppleSpawnRate(val!);
                      }
                  )
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
                  // Game Theme Radio Buttons
                  _buildRadio<GameTheme>(
                      groupValue: _gameTheme,
                      values: GameTheme.values,
                      labelBuilder: (val) => val.name,
                      onChanged: (val) {
                        setState(() {
                          _gameTheme = val!;
                        });
                        context.read<AppProvider>().updateTheme(val!);
                      }
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SnakeGame()));
                  },
                  child: const Text(
                    'Start Game',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'arcade',
                    ),
                  ),
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
