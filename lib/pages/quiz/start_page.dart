import 'package:flutter/material.dart';
import 'package:tic_quiz/routes/app_routes.dart';

class StartQuizPage extends StatelessWidget {
  const StartQuizPage({super.key});

  Widget _buildLetterBox(String letter, Color color) {
    return Container(
      width: 120,
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 78,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Time'),
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLetterBox('C', Colors.blue),
                  const SizedBox(width: 10),
                  _buildLetterBox('O', Colors.red),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLetterBox('D', Colors.yellow),
                  const SizedBox(width: 10),
                  _buildLetterBox('E', Colors.blue),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Are you ready?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.quizPage),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}