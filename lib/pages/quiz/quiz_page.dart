import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/quiz/exit_dialog.dart';
import 'package:tic_quiz/routes/app_routes.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;
  int? selectedAnswerIndex;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which language is used to enhance webpages, eg. change background colour?',
      'answers': ['CSS', 'HTML', 'PHP', 'JavaScript'],
      'correctIndex': 0,
    },
    {
      'question': 'What is the capital of France?',
      'answers': ['London', 'Berlin', 'Paris', 'Madrid'],
      'correctIndex': 2,
    },
    {
      'question': 'What is 5 × 3?',
      'answers': ['12', '15', '18', '20'],
      'correctIndex': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      });
    }
  }

  Future<void> _saveScore(int totalScore) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('scores').add({
          'userId': user.uid,
          'score': totalScore,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save score: $e')),
          );
        }
      }
    }
  }

  void _handleAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswerIndex = index;
      answered = true;
      if (index == questions[currentQuestionIndex]['correctIndex']) {
        score += 10;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answered = false;
        selectedAnswerIndex = null;
      });
    } else {
      final totalScore = score;
      final route = totalScore >= 20 ? AppRoutes.win : AppRoutes.lose;
      _saveScore(totalScore).then((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            route,
            arguments: totalScore,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => ExitDialog(),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Quiz Time'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ExitDialog(),
                );
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Question ${currentQuestionIndex + 1}/${questions.length}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    currentQuestion['question'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  color: Colors.orange,
                  backgroundColor: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 20),
                ...List.generate(currentQuestion['answers'].length, (index) {
                  final isCorrect = index == currentQuestion['correctIndex'];
                  final isSelected = index == selectedAnswerIndex;
                  Color bgColor = Colors.white;
                  Icon? icon;

                  if (answered) {
                    if (isSelected && isCorrect) {
                      bgColor = Colors.green;
                      icon = const Icon(Icons.check, color: Colors.white);
                    } else if (isSelected && !isCorrect) {
                      bgColor = Colors.red;
                      icon = const Icon(Icons.close, color: Colors.white);
                    } else if (isCorrect) {
                      bgColor = Colors.green;
                      icon = const Icon(Icons.check, color: Colors.white);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAnswer(index),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: bgColor,
                        foregroundColor: Colors.black,
                      ),
                      icon: icon ?? const SizedBox.shrink(),
                      label: Text(currentQuestion['answers'][index]),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                if (answered)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('NEXT'),
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Ranking'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, AppRoutes.home);
                break;
              case 1:
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/ranking');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          backgroundColor: Color(0xFF5C3DFF),
        ),
      ),
    );
  }
}