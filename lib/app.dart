import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_quiz/pages/Login.dart';
import 'package:tic_quiz/pages/home_page.dart';
import 'package:tic_quiz/pages/profile_page.dart';
import 'package:tic_quiz/pages/ranking_page.dart';
import 'package:tic_quiz/pages/register.dart';
import 'package:tic_quiz/pages/welcome.dart';

class TicQuizApp extends StatelessWidget {
  const TicQuizApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Arial',
      ),
      home: const Root(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const Register(),
        '/welcome': (context) => const Welcome(),
        '/home': (context) => const HomePage(),
        // '/quiz-intro': (context) => const QuizIntroScreen(),
        // '/quiz-history': (context) => const QuizHistoryScreen(),
        '/ranking': (context) => const RankingPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

/// Decides initial screen based on auth state
class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const Welcome(); 
        }
      },
    );
  }
}
