import 'package:flutter/material.dart';
import 'package:tic_quiz/screen/home_page.dart';
import 'package:tic_quiz/screen/profile_page.dart';
import 'package:tic_quiz/screen/quiz/startQuiz_page.dart';
import 'package:tic_quiz/screen/ranking_page.dart';
import 'package:tic_quiz/shared/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Default to HomePage

  final List<Widget> _pages = [
    const HomePage(),
    const StartQuizPage(),
    const RankingPage(),
    const ProfilePage(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as int?;
    if (arguments != null) {
      setState(() {
        _currentIndex = arguments;
      });
    }
  }

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
      body: _pages[_currentIndex], // Pages are rendered here
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
