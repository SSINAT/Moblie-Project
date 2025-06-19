import 'package:flutter/material.dart';
import 'package:tic_quiz/routes/app_routes.dart';
import 'result_layout.dart';

class WinPage extends StatelessWidget {
  const WinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int? score = ModalRoute.of(context)?.settings.arguments as int?;
    
    return Scaffold(
      body: ResultLayout(
        icon: const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
        title: 'Congratulations!',
        score: score ?? 0,
        message: 'You scored',
        playAgainButtonText: 'Play Again',
        homeButtonText: 'Home',
        onPlayAgainPressed: () => Navigator.pushReplacementNamed(
          context,
          AppRoutes.main,
          arguments: 1, // Set index to StartQuizPage
        ),
        onHomePressed: () => Navigator.pushReplacementNamed(
          context,
          AppRoutes.main,
          arguments: 0, // Set index to HomePage
        ),
      ),
    );
  }
}

