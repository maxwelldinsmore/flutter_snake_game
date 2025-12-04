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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    if (provider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFE4FF19)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
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
              const SizedBox(height: 25),
              // const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       'Sound',
              //       style: TextStyle(
              //         color: Color(0xFFE4FF19),
              //         fontSize: 36,
              //         fontFamily: 'arcade',
              //       ),
              //     ),
              //     Switch(
              //       value: provider.soundEnabled,
              //       onChanged: (value) => context.read<AppProvider>().updateSoundEnabled(value),
              //       activeColor: const Color(0xFFE4FF19),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 12),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       'Music',
              //       style: TextStyle(
              //         color: Color(0xFFE4FF19),
              //         fontSize: 36,
              //         fontFamily: 'arcade',
              //       ),
              //     ),
              //     Switch(
              //       value: provider.musicEnabled,
              //       onChanged: (value) => context.read<AppProvider>().updateMusicEnabled(value),
              //       activeColor: const Color(0xFFE4FF19),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Grid  Size',
                  style: TextStyle(
                    color: Color(0xFF006400),
                    fontSize: 36,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Grid Size Radio Buttons
                  _buildRadio<GridSize>(
                      groupValue: provider.currentGridSize,
                      values: GridSize.values,
                      labelBuilder: (val) => val.name,
                      onChanged: (val) => context.read<AppProvider>().updateGridSize(val!),
                      textColor: const Color(0xFF90EE90), // Light green
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Snake  Speed',
                  style: TextStyle(
                    color: Color(0xFF00008B),
                    fontSize: 36,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Snake Speed Radio Buttons
                  _buildRadio<SnakeSpeed>(
                      groupValue: provider.currentSpeed,
                      values: SnakeSpeed.values,
                      labelBuilder: (val) => val.name,
                      onChanged: (val) => context.read<AppProvider>().updateSnakeSpeed(val!),
                      textColor: const Color(0xFF87CEEB), // Light blue
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Apple  Spawn  Rate',
                  style: TextStyle(
                    color: Color(0xFFFF0000),
                    fontSize: 36,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Apple Spawn Rate Radio Buttons
                  _buildRadio<AppleSpawnRate>(
                      groupValue: provider.currentAppleSpawnRate,
                      values: AppleSpawnRate.values,
                      labelBuilder: (val) => val.name,
                      onChanged: (val) => context.read<AppProvider>().updateAppleSpawnRate(val!),
                      textColor: const Color(0xFFFF69B4), // Pink
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Game  Theme',
                  style: TextStyle(
                    color: Color(0xFF4B0082),
                    fontSize: 36,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Game Theme Radio Buttons
                  _buildRadio<GameTheme>(
                      groupValue: provider.currentTheme,
                      values: GameTheme.values,
                      labelBuilder: (val) => val.name,
                      onChanged: (val) => context.read<AppProvider>().updateTheme(val!),
                      textColor: const Color(0xFF9370DB), // Purple
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Snake  Color',
                  style: TextStyle(
                    color: Color(0xFFE4FF19),
                    fontSize: 36,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildColorRadio(
                        value: SnakeColor.green,
                        groupValue: provider.currentSnakeColor,
                        onChanged: (val) => context.read<AppProvider>().updateSnakeColor(val!),
                        label: 'green',
                        color: const Color(0xFF90EE90), // Light green
                      ),
                      _buildColorRadio(
                        value: SnakeColor.pink,
                        groupValue: provider.currentSnakeColor,
                        onChanged: (val) => context.read<AppProvider>().updateSnakeColor(val!),
                        label: 'pink',
                        color: const Color(0xFFFF69B4), // Hot pink
                      ),
                      _buildColorRadio(
                        value: SnakeColor.purple,
                        groupValue: provider.currentSnakeColor,
                        onChanged: (val) => context.read<AppProvider>().updateSnakeColor(val!),
                        label: 'purple',
                        color: const Color(0xFF9370DB), // Medium purple
                      ),
                      _buildColorRadio(
                        value: SnakeColor.blue,
                        groupValue: provider.currentSnakeColor,
                        onChanged: (val) => context.read<AppProvider>().updateSnakeColor(val!),
                        label: 'blue',
                        color: const Color(0xFF87CEEB), // Light blue
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 45),
              Center(
                child: ElevatedButton(
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
    required String Function(T) labelBuilder,
    Color textColor = const Color(0xFFE4FF19), // Default yellow, now customizable
  }) {
      return Wrap(
        spacing: 12,
        runSpacing: 8,
        children: values.map((value) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<T>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: textColor,
              ),
              Text(
                labelBuilder(value),
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontFamily: 'arcade',
                ),
              ),
            ],
          );
          }).toList(),
      );
  }

  // Build colored radio button for snake colors
  Widget _buildColorRadio({
    required SnakeColor value,
    required SnakeColor groupValue,
    required Function(SnakeColor?) onChanged,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<SnakeColor>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: color,
        ),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontFamily: 'arcade',
          ),
        ),
      ],
    );
  }
}
