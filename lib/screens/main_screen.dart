import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'user_settings_screen.dart';
import 'game_settings_screen.dart';
import 'leaderboard_screen.dart';


class MainScreen extends StatefulWidget {
  final int initialTab;
  
  const MainScreen({super.key, this.initialTab = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialTab;
  }

  void _changeTab(int index) {
    setState(() => _selected = index);
  }

  List<Widget> get _tabs => [
    HomeScreen(onTabChange: _changeTab),
    const UserSettingsScreen(),
    const GameSettingsScreen(),
    const LeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selected, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFE4FF19),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selected,
        onTap: (i) => setState(() => _selected = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Game'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Leaderboard'),
        ],
      ),
    );
  }
}
