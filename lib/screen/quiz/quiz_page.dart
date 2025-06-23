import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  late List<Map<String, dynamic>> questions = [];
  final FirestoreService _firestoreService = FirestoreService();
  bool isLoading = true;
  late int pointsPerQuestion; // New variable to store points per question

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
        // Shuffle all questions and select exactly 9 (or all if less than 9)
        List<Map<String, dynamic>> shuffledQuestions =
            List<Map<String, dynamic>>.from(
              fetchedQuestions.map((q) => q.toMap()),
            )..shuffle();
        questions =
            shuffledQuestions.length >= 9
                ? shuffledQuestions.sublist(0, 9)
                : shuffledQuestions;
        isLoading = false;
        // Calculate points per question: total 100 points divided by number of questions (max 9)
        pointsPerQuestion = questions.isNotEmpty ? 100 ~/ questions.length : 0;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching questions: $e')));
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _saveScore(int totalScore) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Calculate stars based on total score percentage
        const maxScore = 100;
        double starMultiplier = totalScore / maxScore;
        int starsEarned = (starMultiplier * 10).round();
        if (totalScore < 50) {
          starsEarned = -((50 - totalScore) ~/ 10);
        }
        starsEarned = starsEarned.clamp(0, 10);

        // Fetch current stars and update
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        int currentStars = (userDoc.data()?['stars'] ?? 0) as int;
        int? newStars = currentStars + starsEarned;
        newStars = newStars.clamp(0, double.infinity) as int?;

        // Update users collection
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'stars': newStars,
          'name': user.displayName ?? 'Unknown',
          'photoUrl': user.photoURL ?? '',
        }, SetOptions(merge: true));

        // Save quiz score and stars earned to scores collection
        await FirebaseFirestore.instance.collection('scores').add({
          'userId': user.uid,
          'score': totalScore,
          'starsEarned': starsEarned,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print(
          'Saved score $totalScore, stars earned $starsEarned, new total stars $newStars for ${user.uid}',
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save score or stars: $e')),
          );
          print('Error saving score or stars: $e');
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
        score += pointsPerQuestion; // Award points based on number of questions
      }
    });
  }

  Future<void> _nextQuestion() async {
    if (questions.isEmpty) return;

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answered = false;
        selectedAnswerIndex = null;
      });
    } else {
      final totalScore = score;
      final route =
          totalScore >= (100 * 0.5)
              ? AppRoutes.win
              : AppRoutes.lose; // Adjust win threshold
      await _saveScore(totalScore);
      if (mounted) {
        Navigator.pushReplacementNamed(context, route, arguments: totalScore);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('Quiz Time'),
            ),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('Quiz Time'),
            ),
            const Center(child: Text('No questions available')),
          ],
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 20,
              ), // Reduced size to 20
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Quiz Time'),
          ),
          Expanded(
            child: Container(
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
                        currentQuestion['text'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    if (currentQuestion['imageUrl'] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Image.network(
                          currentQuestion['imageUrl']!,
                          height: 100,
                        ),
                      ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / questions.length,
                      color: Colors.orange,
                      backgroundColor: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(currentQuestion['options'].length, (
                      index,
                    ) {
                      final isCorrect =
                          index == currentQuestion['correctIndex'];
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
                          label: Text(currentQuestion['options'][index]),
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
          ),
        ],
      ),
    );
  }
}
