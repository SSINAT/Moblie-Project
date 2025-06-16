import 'package:flutter/material.dart';
import 'package:tic_quiz/views/home_page.dart';
import 'package:tic_quiz/views/quiz_page.dart';
import 'package:tic_quiz/views/ranking_page.dart';
import 'package:tic_quiz/views/profile_page.dart';
import 'package:tic_quiz/shared/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const QuizPage(),
    const RankingPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentIndex],
      ), // Use SafeArea to prevent overlap
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
