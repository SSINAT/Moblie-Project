import 'package:flutter/material.dart';
import 'package:tic_quiz/Login.dart';
import 'package:tic_quiz/landing.dart';
import 'package:tic_quiz/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIC Quiz',
      debugShowCheckedModeBanner: false,
      initialRoute: 'landing', // Start on the landing screen
      routes: {
        'landing': (context) => const MyLanding(),
        'welcome': (context) => const Welcome(),
        'login': (context) => LoginScreen(),

      },
    );
  }
}