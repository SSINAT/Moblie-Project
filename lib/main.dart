import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/landing.dart';
import 'package:tic_quiz/pages/welcome.dart';

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
      initialRoute: 'landing', 
      routes: {
        'landing': (context) => const MyLanding(),
        'welcome': (context) => const Welcome(),
      },
    );
  }
}