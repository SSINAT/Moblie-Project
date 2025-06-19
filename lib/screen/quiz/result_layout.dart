import 'package:flutter/material.dart';

class ResultLayout extends StatelessWidget {
  final Icon icon;
  final String title;
  final int score;
  final String message;
  final String playAgainButtonText;
  final String homeButtonText;
  final VoidCallback onPlayAgainPressed;
  final VoidCallback onHomePressed;

  const ResultLayout({
    super.key,
    required this.icon,
    required this.title,
    required this.score,
    required this.message,
    required this.playAgainButtonText,
    required this.homeButtonText,
    required this.onPlayAgainPressed,
    required this.onHomePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$message: $score',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onPlayAgainPressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(playAgainButtonText),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onHomePressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(homeButtonText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
