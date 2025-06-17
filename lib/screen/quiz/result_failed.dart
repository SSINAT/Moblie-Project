import 'package:flutter/material.dart';
import 'package:tic_quiz/routes/app_routes.dart';
import 'result_layout.dart';

class LossPage extends StatelessWidget {
  const LossPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int? score = ModalRoute.of(context)?.settings.arguments as int?;

    return Scaffold(
      body: ResultLayout(
        icon: const Icon(
          Icons.sentiment_very_dissatisfied,
          size: 100,
          color: Colors.red,
        ),
        title: 'You Lose',
        score: score ?? 0,
        message: 'Score',
        playAgainButtonText: 'Play Again',
        homeButtonText: 'Home',
        onPlayAgainPressed:
            () => Navigator.pushReplacementNamed(
              context,
              AppRoutes.main,
              arguments: 1, // Set index to StartQuizPage
            ),
        onHomePressed:
            () => Navigator.pushReplacementNamed(
              context,
              AppRoutes.main,
              arguments: 0, // Set index to HomePage
            ),
      ),
    );
  }
}
