import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/quiz/exit_dialog.dart';
import 'package:tic_quiz/routes/app_routes.dart';
import 'package:tic_quiz/services/firestore_service.dart';

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
  List<Map<String, dynamic>> questions = [];
  final FirestoreService _firestoreService = FirestoreService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      });
    } else {
      _fetchQuestions();
    }
  }

  Future<void> _fetchQuestions() async {
    try {
      final fetchedQuestions = await _firestoreService.getQuestions('quizId');
      setState(() {
        questions = fetchedQuestions.map((q) => q.toMap()).toList();
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching questions: $e')),
        );
        setState(() => isLoading = false);
      }
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
    if (answered || questions.isEmpty) return;

    setState(() {
      selectedAnswerIndex = index;
      answered = true;
      if (index == questions[currentQuestionIndex]['correctIndex']) {
        score += 10;
      }
    });
  }

  void _nextQuestion() {
    if (questions.isEmpty) return;

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answered = false;
        selectedAnswerIndex = null;
      });
    } else {
      final totalScore = score;
      final route = totalScore >= questions.length * 10 * 0.7
          ? AppRoutes.win
          : AppRoutes.lose;
      _saveScore(totalScore).then((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, route, arguments: totalScore);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Quiz Time', style: TextStyle(color: Colors.black)),
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Quiz Time', style: TextStyle(color: Colors.black)),
        ),
        body: const Center(
          child: Text(
            'No questions available',
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Quiz Time', style: TextStyle(color: Colors.black)),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  currentQuestion['text'],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (currentQuestion['imageUrl'] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.network(
                    currentQuestion['imageUrl']!,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                color: Colors.orange,
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),
              ...List.generate(currentQuestion['options'].length, (index) {
                final isCorrect = index == currentQuestion['correctIndex'];
                final isSelected = index == selectedAnswerIndex;
                Color bgColor = Colors.white;
                Color textColor = Colors.black87;
                Icon? icon;

                if (answered) {
                  if (isSelected && isCorrect) {
                    bgColor = Colors.green;
                    textColor = Colors.white;
                    icon = const Icon(Icons.check, color: Colors.white);
                  } else if (isSelected && !isCorrect) {
                    bgColor = Colors.red;
                    textColor = Colors.white;
                    icon = const Icon(Icons.close, color: Colors.white);
                  } else if (isCorrect) {
                    bgColor = Colors.green;
                    textColor = Colors.white;
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
                      foregroundColor: textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    icon: icon ?? const SizedBox.shrink(),
                    label: Text(
                      currentQuestion['options'][index],
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
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
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}