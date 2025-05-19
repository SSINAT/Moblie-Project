import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/home_page.dart';
import 'package:tic_quiz/pages/quiz_page.dart';
import 'package:tic_quiz/pages/ranking_page.dart';
import 'package:tic_quiz/pages/profile_page.dart';
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
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
