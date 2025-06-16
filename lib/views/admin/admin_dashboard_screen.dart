import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_quiz/models/question.dart';
import 'package:tic_quiz/views/admin/add_question_screen.dart';
import 'package:tic_quiz/views/admin/edit_question_screen.dart';
import 'package:tic_quiz/services/firestore_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF083DED),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // Show confirmation dialog
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
            );

            // If user confirms logout
            if (shouldLogout == true) {
              try {
                await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                // Navigate to Welcome screen, replacing the current route
                Navigator.pushReplacementNamed(context, '/welcome');
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
              }
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Refreshed data')));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: FirestoreService().getQuestionsStream('quizId'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final questions = snapshot.data!;
                  if (questions.isEmpty) {
                    return const Center(child: Text('No questions available.'));
                  }
                  return ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(
                            question['text'] ?? 'No text',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Correct: ${question['options']?[question['correctIndex']] ?? 'N/A'}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Viewing: ${question['text']}',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EditQuestionScreen(
                                            question: Question.fromMap(
                                              question,
                                            ),
                                          ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  FirestoreService().deleteQuestion(
                                    'quizId',
                                    question['id'],
                                    question['imageUrl'],
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Question deleted'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddQuestionScreen()),
          );
        },
        backgroundColor: const Color(0xFF083DED),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
