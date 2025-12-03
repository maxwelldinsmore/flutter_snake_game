import 'package:flutter/foundation.dart';

// Enums for the direction, grid size, snake speed, apple spawn rate, and theme.
enum Direction { up, down, left, right }
enum GridSize { small, medium, large }
enum SnakeSpeed { slow, medium, fast }
enum AppleSpawnRate { normal, fast }
enum GameTheme { retro, dark, light }

class AppProvider extends ChangeNotifier {
  // Grid size setting
  GridSize currentGridSize = GridSize.medium;
  // method to update grid size
  void updateGridSize(GridSize newSize) {
    if (currentGridSize != newSize) {
      currentGridSize = newSize;
      notifyListeners(); // Notify listeners of the change
    }
  }

  // Snake speed setting
  SnakeSpeed currentSpeed = SnakeSpeed.medium;
  // method to update snake speed
  void updateSnakeSpeed(SnakeSpeed newSpeed) {
    if (currentSpeed != newSpeed) {
      currentSpeed = newSpeed;
      notifyListeners(); // Notify listeners of the change
    }
  }

  // Apple spawn rate setting
  AppleSpawnRate currentAppleSpawnRate = AppleSpawnRate.normal;
  // method to update apple spawn rate
  void updateAppleSpawnRate(AppleSpawnRate newRate) {
    if (currentAppleSpawnRate != newRate) {
      currentAppleSpawnRate = newRate;
      notifyListeners(); // Notify listeners of the change
    }
  }

  // Theme setting
  GameTheme currentTheme = GameTheme.retro;
  // method to update theme
  void updateTheme(GameTheme newTheme) {
    if (currentTheme != newTheme) {
      currentTheme = newTheme;
      notifyListeners(); // Notify listeners of the change
    }
  }
}