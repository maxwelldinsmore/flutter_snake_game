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

    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth < 600 ? 32.0 : (screenWidth < 900 ? 40.0 : 48.0);
    final sectionFontSize = screenWidth < 600 ? 24.0 : (screenWidth < 900 ? 30.0 : 36.0);
    final radioFontSize = screenWidth < 600 ? 18.0 : (screenWidth < 900 ? 20.0 : 24.0);
    final buttonFontSize = screenWidth < 600 ? 18.0 : (screenWidth < 900 ? 20.0 : 24.0);
    final horizontalPadding = screenWidth < 600 ? 16.0 : (screenWidth < 900 ? 20.0 : 24.0);
    final verticalSpacing = screenWidth < 600 ? 12.0 : (screenWidth < 900 ? 16.0 : 20.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          color: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Game Settings',
                  style: TextStyle(
                    color: const Color(0xFFE4FF19),
                    fontSize: titleFontSize,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing),
              SizedBox(height: verticalSpacing),
              Center(
                child: Text(
                  'Grid  Size',
                  style: TextStyle(
                    color: const Color(0xFF006400),
                    fontSize: sectionFontSize,
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
                      textColor: const Color(0xFF90EE90),
                      fontSize: radioFontSize,
                  )
                ],
              ),
              SizedBox(height: verticalSpacing),
              Center(
                child: Text(
                  'Snake  Speed',
                  style: TextStyle(
                    color: const Color(0xFF00008B),
                    fontSize: sectionFontSize,
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
                      textColor: const Color(0xFF87CEEB),
                      fontSize: radioFontSize,
                  )
                ],
              ),
              SizedBox(height: verticalSpacing),
              Center(
                child: Text(
                  'Apple  Spawn  Rate',
                  style: TextStyle(
                    color: const Color(0xFFFF0000),
                    fontSize: sectionFontSize,
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
                      textColor: const Color(0xFFFF69B4),
                      fontSize: radioFontSize,
                  )
                ],
              ),
              SizedBox(height: verticalSpacing),
              Center(
                child: Text(
                  'Game  Theme',
                  style: TextStyle(
                    color: const Color(0xFF4B0082),
                    fontSize: sectionFontSize,
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
                      textColor: const Color(0xFF9370DB),
                      fontSize: radioFontSize,
                  )
                ],
              ),
              SizedBox(height: verticalSpacing),
              Center(
                child: Text(
                  'Snake  Color',
                  style: TextStyle(
                    color: const Color(0xFFE4FF19),
                    fontSize: sectionFontSize,
                    fontFamily: 'arcade',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorRadio(
                        value: SnakeColor.green,
                        groupValue: provider.currentSnakeColor,
                        onChanged: (val) => context.read<AppProvider>().updateSnakeColor(val!),
                        label: 'green',
                        color: const Color(0xFF90EE90),
                        fontSize: radioFontSize,
                      ),
                      const SizedBox(width: 16),
                      _buildColorRadio(
                        value: SnakeColor.pink,
                        groupValue: provider.currentSnakeColor,
                        onChanged: (val) => context.read<AppProvider>().updateSnakeColor(val!),
                        label: 'pink',
                        color: const Color(0xFFFF69B4),
                        fontSize: radioFontSize,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorRadio(
                        value: SnakeColor.purple,
                        groupValue: provider.currentSnakeColor,
                        onChanged: (val) => context.read<AppProvider>().updateSnakeColor(val!),
                        label: 'purple',
                        color: const Color(0xFF9370DB),
                        fontSize: radioFontSize,
                      ),
                      const SizedBox(width: 16),
                      _buildColorRadio(
                        value: SnakeColor.blue,
                        groupValue: provider.currentSnakeColor,
                        onChanged: (val) => context.read<AppProvider>().updateSnakeColor(val!),
                        label: 'blue',
                        color: const Color(0xFF87CEEB),
                        fontSize: radioFontSize,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing * 2),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SnakeGame()));
                    },
                    child: Text(
                      'Start Game',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: buttonFontSize,
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
  Widget _buildRadio<T extends Enum>({
    required T groupValue,
    required Function (T?) onChanged,
    required List<T> values,
    required String Function(T) labelBuilder,
    Color textColor = const Color(0xFFE4FF19),
    double fontSize = 24.0,
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
                  fontSize: fontSize,
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
    double fontSize = 24.0,
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
            fontSize: fontSize,
            fontFamily: 'arcade',
          ),
        ),
      ],
    );
  }
}
