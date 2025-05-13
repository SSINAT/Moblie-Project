import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/Login.dart';
import 'package:tic_quiz/pages/landing.dart';

import 'package:tic_quiz/pages/register.dart';
import 'package:tic_quiz/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        'login': (context) => LoginScreen(),

        'register': (context) => const Register(),
      
      },
    );
  }
}