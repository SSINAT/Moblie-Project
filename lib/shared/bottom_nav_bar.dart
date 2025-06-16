import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      buttonBackgroundColor: const Color.fromARGB(255, 8, 0, 255),
      color: const Color.fromARGB(255, 8, 0, 255),
      height: 75,
      animationDuration: const Duration(milliseconds: 300),
      index: currentIndex,
      onTap: onTap,
      items: const [
        Icon(Icons.home_outlined, color: Colors.white),
        Icon(Icons.quiz_outlined, color: Colors.white),
        Icon(Icons.leaderboard_outlined, color: Colors.white),
        Icon(Icons.person_outline, color: Colors.white),
      ],
    );
  }
}
