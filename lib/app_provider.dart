import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'database.dart';
import 'tempdata.dart' as temp_data;

// Enums for the direction, grid size, snake speed, apple spawn rate, and theme.
enum Direction { up, down, left, right }
enum GridSize { small, medium, large }
enum SnakeSpeed { slow, medium, fast }
enum AppleSpawnRate { normal, fast }
enum GameTheme { retro, dark, light }
enum SnakeColor { green, pink, purple, blue }

class AppProvider extends ChangeNotifier {
  // database service instance to save to db when settings are changed
  final DatabaseService _db = DatabaseService();
  Timer? _saveTimer; // Timer to delay saving to the database and avoid excessive writes
  bool isLoading = true; // loading flag

  // settings being watched by provider
  bool soundEnabled = true;
  bool musicEnabled = true;
  GridSize currentGridSize = GridSize.medium;
  SnakeSpeed currentSpeed = SnakeSpeed.medium;
  AppleSpawnRate currentAppleSpawnRate = AppleSpawnRate.normal;
  GameTheme currentTheme = GameTheme.retro;
  SnakeColor currentSnakeColor = SnakeColor.green;

  // load data from the database
  AppProvider(){
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // let the page know we are loading
    isLoading = true;
    notifyListeners();

    if (temp_data.userId.isEmpty) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final data = await _db.getUserdataById(temp_data.userId);
      if (data != null) {
      soundEnabled = data['soundEnabled'] ?? true;
      musicEnabled = data['musicEnabled'] ?? true;
      // load enum values from string stored in db where it matches the name of the enum
      currentGridSize = GridSize.values.firstWhere(
              (e) => e.name == data['gridSize'],
          orElse: () => currentGridSize);
      currentSpeed = SnakeSpeed.values.firstWhere(
              (e) => e.name == data['snakeSpeed'],
          orElse: () => currentSpeed);
      currentAppleSpawnRate = AppleSpawnRate.values.firstWhere(
              (e) => e.name == data['appleSpawnRate'],
          orElse: () => currentAppleSpawnRate);
      currentTheme = GameTheme.values.firstWhere(
              (e) => e.name == data['gameTheme'],
          orElse: () => currentTheme);
      currentSnakeColor = SnakeColor.values.firstWhere(
              (e) => e.name == data['snakeColor'],
          orElse: () => currentSnakeColor);
      }
    } catch (e) {
      log('Error loading user data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // method to schedule save to database after a delay
  void _scheduleSave([Duration delay = const Duration(seconds: 5)]) {
    _saveTimer?.cancel(); // Cancel any existing timer
    _saveTimer = Timer(delay, _saveNow);
  }

  // method to save current settings to database
  Future<void> _saveNow() async {
    _saveTimer = null; // Clear the timer reference
    if (temp_data.userId.isEmpty) return;
    try {
      await _db.updateUserdata(temp_data.userId, {
        'soundEnabled': soundEnabled,
        'musicEnabled': musicEnabled,
        'gridSize': currentGridSize.name,
        'snakeSpeed': currentSpeed.name,
        'appleSpawnRate': currentAppleSpawnRate.name,
        'gameTheme': currentTheme.name,
        'snakeColor': currentSnakeColor.name,
      });
    } catch (e) {
      log('Error saving user data: $e');
    }
  }

  // method to update grid size
  void updateGridSize(GridSize newSize) {
    if (currentGridSize != newSize) {
      currentGridSize = newSize;
      notifyListeners(); // Notify listeners of the change
      _scheduleSave(); // Schedule save to database
    }
  }

  // method to update snake speed
  void updateSnakeSpeed(SnakeSpeed newSpeed) {
    if (currentSpeed != newSpeed) {
      currentSpeed = newSpeed;
      notifyListeners(); // Notify listeners of the change
      _scheduleSave();
    }
  }

  // method to update apple spawn rate
  void updateAppleSpawnRate(AppleSpawnRate newRate) {
    if (currentAppleSpawnRate != newRate) {
      currentAppleSpawnRate = newRate;
      notifyListeners(); // Notify listeners of the change
      _scheduleSave();
    }
  }

  // method to update theme
  void updateTheme(GameTheme newTheme) {
    if (currentTheme != newTheme) {
      currentTheme = newTheme;
      notifyListeners(); // Notify listeners of the change
      _scheduleSave();
    }
  }

  // method to update snake color
  void updateSnakeColor(SnakeColor newColor) {
    if (currentSnakeColor != newColor) {
      currentSnakeColor = newColor;
      notifyListeners(); // Notify listeners of the change
      _scheduleSave();
    }
  }

  // method to update sound enabled
  void updateSoundEnabled(bool isEnabled) {
    if (soundEnabled != isEnabled) {
      soundEnabled = isEnabled;
      notifyListeners(); // Notify listeners of the change
      _scheduleSave();
    }
  }

  // method to update music enabled
  void updateMusicEnabled(bool isEnabled) {
    if (musicEnabled != isEnabled) {
      musicEnabled = isEnabled;
      notifyListeners(); // Notify listeners of the change
      _scheduleSave();
    }
  }

  @override
  void dispose() {
    _saveTimer?.cancel(); // Cancel any existing timer
    super.dispose();
  }
}