import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_quiz/pages/landing.dart'; // your splash screen
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
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MyLanding(), // Splash screen
      routes: AppRoutes.routes,
    );
  }
}
