// Date: 2025-11-21 
// Group: Alyssa, Bilgan, Shanice, Maxwell
// Description: A Flutter implementation of the classic Snake Game.

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_snake_game/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app_provider.dart';
import 'screens/leaderboard_screen.dart';
import '../tempdata.dart' as temp_data;
import '../database.dart'; 
class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

// The main state class for the Snake Game.
class _SnakeGameState extends State<SnakeGame> {
  
  // Audio players
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _soundPlayer = AudioPlayer();
  
  // Game settings (will be updated from AppProvider).
  GridSize currentGridSize = GridSize.medium;
  SnakeSpeed currentSpeed = SnakeSpeed.medium;
  AppleSpawnRate currentAppleSpawnRate = AppleSpawnRate.normal;
  GameTheme currentTheme = GameTheme.retro;
  AppProvider? _appProvider;
  VoidCallback? _appListener;
  
  // Grid dimensions (will be calculated based on currentGridSize).
  int gridRows = 20;
  int gridCols = 20;
  int totalSquares = 400;

  // Snake position (list of square indices).
  List<int> snakePosition = [45, 44, 43];

  // Food position.
  int foodPosition = 0;

  // Direction.
  Direction direction = Direction.right;

  // Game state.
  bool gameStarted = false;
  int currentScore = 0;
  int highScore = 0;

//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------

// Initialize the game state.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    foodPosition = Random().nextInt(totalSquares);

    // Get AppProvider instance.
    final provider = context.read<AppProvider>();

    if (_appProvider != provider) {
      _appProvider = provider;

    // Initialize audio when first loading
    _initializeAudio();

    // Initial settings load.
    currentGridSize = _appProvider!.currentGridSize;
    currentSpeed = _appProvider!.currentSpeed;
    currentAppleSpawnRate = _appProvider!.currentAppleSpawnRate;
    currentTheme = _appProvider!.currentTheme;
    
    // Apply initial grid size
    setGridSize(currentGridSize);

    // Listen for settings changes.
    _appListener = () {
      setState(() {
        if (currentGridSize != _appProvider!.currentGridSize) {
          currentGridSize = _appProvider!.currentGridSize;
          setGridSize(currentGridSize);
        }
        if (currentSpeed != _appProvider!.currentSpeed) {
          currentSpeed = _appProvider!.currentSpeed;
          setSnakeSpeed(currentSpeed);
        }
        if (currentAppleSpawnRate != _appProvider!.currentAppleSpawnRate) {
          currentAppleSpawnRate = _appProvider!.currentAppleSpawnRate;
          setAppleSpawnRate(currentAppleSpawnRate);
        }
        if (currentTheme != _appProvider!.currentTheme) {
          currentTheme = _appProvider!.currentTheme;
          setTheme(currentTheme);
        }
        // Update audio when settings change
        _updateAudioSettings();
      });
    };
      _appProvider!.addListener(_appListener!);
    }
  }

  @override
  void dispose() {
    // Remove listener to avoid memory leaks.
    if (_appProvider != null && _appListener != null) {
      _appProvider!.removeListener(_appListener!);
    }
    // Dispose audio players
    _musicPlayer.dispose();
    _soundPlayer.dispose();
    super.dispose();
  }

  // Initialize audio players and start background music
  Future<void> _initializeAudio() async {
    try {
      // Set player mode for web compatibility
      await _musicPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _soundPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      
      // Set music to loop
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      
      // Check if music is enabled before playing
      if (_appProvider != null && _appProvider!.musicEnabled) {
        // Load and play background music
        await _musicPlayer.setSourceAsset('assets/audio/8-bit-music.mp3');
        await _musicPlayer.resume();
      }
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  // Update audio settings based on provider toggles
  void _updateAudioSettings() {
    if (_appProvider != null) {
      // Control background music
      if (_appProvider!.musicEnabled) {
        _musicPlayer.resume();
      } else {
        _musicPlayer.pause();
      }
    }
  }

  // Play eat sound effect
  Future<void> _playEatSound() async {
    if (_appProvider != null && _appProvider!.soundEnabled) {
      try {
        await _soundPlayer.setSourceAsset('assets/audio/snake-food-music.mp3');
        await _soundPlayer.resume();
      } catch (e) {
        print('Error playing eat sound: $e');
      }
    }
  }

  // Method to update grid size.
  //!! Settings should call this method when user changes grid size
  void setGridSize(GridSize size) {
    setState(() {
      currentGridSize = size;
      switch (size) {
        case GridSize.small:
          gridRows = 15;
          gridCols = 15;
          break;
        case GridSize.medium:
          gridRows = 20;
          gridCols = 20;
          break;
        case GridSize.large:
          gridRows = 25;
          gridCols = 25;
          break;
      }
      totalSquares = gridRows * gridCols;

      // Reset snake position based on new grid size
      int centerRow = gridRows ~/ 2;
      int centerCol = gridCols ~/ 2;
      int centerPos = centerRow * gridCols + centerCol;
      snakePosition = [centerPos, centerPos - 1, centerPos - 2];
      
      // Reset food position
      foodPosition = Random().nextInt(totalSquares);
      while (snakePosition.contains(foodPosition)) {
        foodPosition = Random().nextInt(totalSquares);
      }

      // Reset game if it's running.
      if (gameStarted) {
        gameStarted = false;
      }
    });
  }

  // Method to update snake speed.
  // !! Settings should call this method when user changes snake speed.
  void setSnakeSpeed(SnakeSpeed speed) {
    setState(() {
      currentSpeed = speed;
      
      // Reset game if it's running so new speed takes effect.
      if (gameStarted) {
        gameStarted = false;
      }
    });
  }

  // Method to update apple spawn rate.
  // !! Settings should call this method when user changes apple spawn rate.
  void setAppleSpawnRate(AppleSpawnRate rate) {
    setState(() {
      currentAppleSpawnRate = rate;
    });
  }

  // Method to update theme.
  // !! Settings should call this method when user changes theme.
  void setTheme(GameTheme theme) {
    setState(() {
      currentTheme = theme;
    });
  }

  // Get theme colors based on current theme.
  // !! Settings should call this method when user changes theme.
  Map<String, Color> getThemeColors() {
    switch (currentTheme) {
      case GameTheme.retro:
        return {
          'background': Color(0xFF0D1B2A), // Deep navy blue
          'panel': Color(0xFF1B263B), // Dark blue-grey
          'labelText': Color(0xFF00D9FF), // Cyan
          'scoreText': Color(0xFFFFD700), // Gold
          'snakeHead': Color(0xFF00FF41), // Bright neon green
          'snakeBody': Color(0xFF39FF14), // Lime green
          'food': Color(0xFFFF006E), // Hot pink
          'gridEmpty': Color(0xFF0D1B2A), // Deep navy
          'gridLine': Color(0xFF1B263B), // Dark blue-grey
          'button': Color(0xFF00FF41), // Neon green
          'buttonText': Color(0xFF0D1B2A), // Dark
          'arrow': Color(0xFF00D9FF), // Cyan
        };
      case GameTheme.dark:
        return {
          'background': Color(0xFF000000), // Pure black
          'panel': Color(0xFF1A1A1A), // Dark grey
          'labelText': Color(0xFFAAAAAA), // Light grey
          'scoreText': Color(0xFFFFFFFF), // White
          'snakeHead': Color(0xFF00FF00), // Bright green
          'snakeBody': Color(0xFF008000), // Green
          'food': Color(0xFFFF0000), // Red
          'gridEmpty': Color(0xFF000000), // Black
          'gridLine': Color(0xFF333333), // Dark grey
          'button': Color(0xFF00FF00), // Green
          'buttonText': Color(0xFF000000), // Black
          'arrow': Color(0xFFFFFFFF), // White
        };
      case GameTheme.light:
        return {
          'background': Color(0xFFF5F5F5), // Light grey
          'panel': Color(0xFFE0E0E0), // Medium grey
          'labelText': Color(0xFF424242), // Dark grey
          'scoreText': Color(0xFF000000), // Black
          'snakeHead': Color(0xFF2E7D32), // Dark green
          'snakeBody': Color(0xFF66BB6A), // Light green
          'food': Color(0xFFE53935), // Red
          'gridEmpty': Color(0xFFFFFFFF), // White
          'gridLine': Color(0xFFBDBDBD), // Grey
          'button': Color(0xFF4CAF50), // Green
          'buttonText': Color(0xFFFFFFFF), // White
          'arrow': Color(0xFF424242), // Dark grey
        };
    }
  }

  // Get the apple spawn delay based on current spawn rate setting
  int getAppleSpawnDelay() {
    switch (currentAppleSpawnRate) {
      case AppleSpawnRate.normal:
        // 0.5 second delay (default setting).
        return 500; 
      // 0.1 second delay (slightly faster).
      case AppleSpawnRate.fast:
        return 100;
    }
  }

  // Get the delay duration based on current speed setting.
  int getSpeedDelay() {
    switch (currentSpeed) {
      // 300ms delay (slower)
      case SnakeSpeed.slow:
        return 300; 
      // 200ms delay (default)
      case SnakeSpeed.medium:
        return 200; 
      // 120ms delay (faster but not crazy)
      case SnakeSpeed.fast:
        return 120; 
    }
  }


//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------


  // This method starts the game loop.
  void startGame() {
    setState(() {
      gameStarted = true;
      // Calculate center position based on current grid size
      int centerRow = gridRows ~/ 2;
      int centerCol = gridCols ~/ 2;
      int centerPos = centerRow * gridCols + centerCol;
      snakePosition = [centerPos, centerPos - 1, centerPos - 2];
      
      foodPosition = Random().nextInt(totalSquares);
      while (snakePosition.contains(foodPosition)) {
        foodPosition = Random().nextInt(totalSquares);
      }
      // Initial direction when you load the game.
      direction = Direction.right;
      currentScore = 0;
    });

    // Game loop timer.
    Timer.periodic(Duration(milliseconds: getSpeedDelay()), (timer) {
      if (!gameStarted) {
        timer.cancel();
        return;
      }

    // Check for game over.
      if (gameOver()) {
        timer.cancel();
        gameStarted = false;
        showGameOverDialog();
        updateDBScore();
        return;
      }

      // Update snake position.
      updateSnake();
    });
  }
  // Updates the players highscore in the database if current is better than prev highscore
  void updateDBScore() async {
    final db = DatabaseService();
    try {
      final userId = temp_data.userId;
      if (userId != null) {
        final userdata = await db.getUserdataById(userId);
        final existingScore = userdata?['score'] ?? 0;
        if (currentScore > existingScore) {
          await db.updateUserdata(userId, {'score': currentScore});
        }
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  //  This method updates the snake's position based on the current direction.
  void updateSnake() {
    setState(() {
      int newHead;
      
      // Moves snake.
      switch (direction) {
        case Direction.up:
          newHead = snakePosition.last - gridCols;
          break;
        case Direction.down:
          newHead = snakePosition.last + gridCols;
          break;
        case Direction.left:
          // Check if at left edge
          if (snakePosition.last % gridCols == 0) {
            newHead = -1; // Out of bounds
          } else {
            newHead = snakePosition.last - 1;
          }
          break;
        case Direction.right:
          // Check if at right edge
          if ((snakePosition.last + 1) % gridCols == 0) {
            newHead = -1; // Out of bounds
          } else {
            newHead = snakePosition.last + 1;
          }
          break;
      }
      // Add new head position
      snakePosition.add(newHead);


      // Check if snake eats food
      if (snakePosition.last == foodPosition) {
        currentScore++;
        // Play eat sound effect
        _playEatSound();
        
        // Generate new food immediately.
        // Temporarily hide food
        foodPosition = -1; 
        
        // Generate new food after delay.
        Future.delayed(Duration(milliseconds: getAppleSpawnDelay()), () {
          setState(() {
            // Ensure food does not spawn on snake.
            do {
              foodPosition = Random().nextInt(totalSquares);
            } while (snakePosition.contains(foodPosition));
          });
        });
      } else {
        // Only remove tail if food wasn't eaten.
        snakePosition.removeAt(0);
      }
    });
  }

  // Game over if you hit a wall or yourself.
  bool gameOver() {
    // Check if out of bounds.
    if (snakePosition.last < 0 || snakePosition.last >= totalSquares) {
      return true;
    }
    
    // Check if snake hits itself (need at least 5 segments before checking collision)
    if (snakePosition.length < 5) {
      return false;
    }
    
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length - 1);
    if (bodySnake.contains(snakePosition.last)) {
      return true;
    }
    return false;
  }


  // Show game over dialog.
  void showGameOverDialog() {
    if (currentScore > highScore) {
      highScore = currentScore;
    }
    
    final colors = getThemeColors();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colors['panel'],
          title: Text(
            'Game Over',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors['labelText'],
              fontSize: 32,
              fontFamily: 'arcade',
            ),
          ),
          content: Text(
            'Your score: $currentScore',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors['scoreText'],
              fontSize: 24,
              fontFamily: 'arcade',
            ),
          ),
          actions: [
            // Back to Home button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: colors['button'],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Home',
                style: TextStyle(
                  color: colors['buttonText'],
                  fontSize: 18,
                  fontFamily: 'arcade',
                ),
              ),
            ),
            // Play Again button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  gameStarted = false;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Play Again!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'arcade',
                ),
              ),
            ),
            // Leaderboard button
            TextButton(
              onPressed: () {
                // Close dialog and navigate to leaderboard.
                Navigator.of(context).pop(); 
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: colors['button'],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Leaderboard',
                style: TextStyle(
                  color: colors['buttonText'],
                  fontSize: 18,
                  fontFamily: 'arcade',
                ),
              ),
            ),
          ],
        );
      },
    );
  }



//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------



  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final currentTheme = appProvider.currentTheme;
        final colors = getThemeColors();

        return Scaffold(
          backgroundColor: colors['background'],
          appBar: AppBar(
            backgroundColor: colors['panel'],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors['labelText']),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
            ),
            title: Text(
              'Snake Game',
              style: TextStyle(
                color: colors['labelText'],
                fontFamily: 'arcade',
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // High score display at the top
              Expanded(
                child: Container(
                  color: colors['panel'],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Current Score',
                            style: TextStyle(
                              color: colors['labelText'],
                              fontSize: 16,
                              fontFamily: 'arcade',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            currentScore.toString(),
                            style: TextStyle(
                              color: colors['scoreText'],
                              fontSize: 32,
                              fontFamily: 'arcade',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'High Score',
                            style: TextStyle(
                              color: colors['labelText'],
                              fontSize: 16,
                              fontFamily: 'arcade',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            highScore.toString(),
                            style: TextStyle(
                              color: colors['scoreText'],
                              fontSize: 32,
                              fontFamily: 'arcade',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Game area in the middle
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (direction != Direction.up && details.delta.dy > 0) {
                      direction = Direction.down;
                    } else if (direction != Direction.down && details.delta.dy < 0) {
                      direction = Direction.up;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (direction != Direction.left && details.delta.dx > 0) {
                      direction = Direction.right;
                    } else if (direction != Direction.right && details.delta.dx < 0) {
                      direction = Direction.left;
                    }
                  },
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCols,
                    ),
                    itemBuilder: (context, index) {
                      // Snake head
                      if (snakePosition.last == index) {
                        return Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: colors['snakeHead'],
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: currentTheme == GameTheme.retro ? [
                              BoxShadow(
                                color: colors['snakeHead']!.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ] : null,
                          ),
                        );
                      }
                      // Snake body
                      else if (snakePosition.contains(index)) {
                        return Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: colors['snakeBody'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }
                      // Food
                      else if (foodPosition == index) {
                        return Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: colors['food'],
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: currentTheme == GameTheme.retro ? [
                              BoxShadow(
                                color: colors['food']!.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ] : null,
                          ),
                        );
                      }
                      // Empty square
                      else {
                        return Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: colors['gridEmpty'],
                            border: Border.all(
                              color: colors['gridLine']!,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              // Control buttons at the bottom
              Expanded(
                child: Container(
                  color: colors['panel'],
                  child: !gameStarted
                      ? Center(
                          child: ElevatedButton(
                            onPressed: startGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors['button'],
                              foregroundColor: colors['buttonText'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 8,
                            ),
                            child: const Text(
                              'Start Game',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (direction != Direction.right) {
                                  direction = Direction.left;
                                }
                              },
                              icon: const Icon(Icons.arrow_back, size: 40),
                              color: colors['arrow'],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (direction != Direction.down) {
                                      direction = Direction.up;
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_upward, size: 40),
                                  color: colors['arrow'],
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (direction != Direction.up) {
                                      direction = Direction.down;
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_downward, size: 40),
                                  color: colors['arrow'],
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                if (direction != Direction.left) {
                                  direction = Direction.right;
                                }
                              },
                              icon: const Icon(Icons.arrow_forward, size: 40),
                              color: colors['arrow'],
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}