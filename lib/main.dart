import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/Login.dart';
import 'package:tic_quiz/pages/landing.dart';
import 'package:tic_quiz/pages/new_password.dart';

import 'package:tic_quiz/pages/register.dart';
import 'package:tic_quiz/pages/reset_password_email.dart';
import 'package:tic_quiz/pages/reset_password_phone.dart';
import 'package:tic_quiz/pages/verification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_quiz/pages/landing.dart'; // your splash screen
import 'package:tic_quiz/pages/welcome.dart';
import 'package:tic_quiz/routes/app_routes.dart'; // this file

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
      title: 'Tic Quiz',
      debugShowCheckedModeBanner: false,
      initialRoute: 'landing', 
      // routes: {
      //   'landing': (context) => const MyLanding(),
      //   'welcome': (context) => const Welcome(),
      //   'login': (context) => LoginScreen(),

      //   'register': (context) => const Register(),
      //   'reset_password': (context) => const ResetPasswordByPhone(),
      //   'reset_password_email': (context) => const ResetPasswordByEmail(),
      //   'verification': (context) => const VerificationPassword(),
      //   'new_password': (context) => const NewPassword(),
      
      // },
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MyLanding(), // Splash screen
      routes: AppRoutes.routes,
    );
  }
}
