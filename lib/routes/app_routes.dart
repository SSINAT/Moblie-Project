import 'package:flutter/material.dart';
import 'package:tic_quiz/screen/main_page.dart';
import 'package:tic_quiz/screen/quiz/exit_dialog.dart';
import 'package:tic_quiz/screen/quiz/quiz_page.dart';
import 'package:tic_quiz/screen/quiz/result_congrats.dart';
import 'package:tic_quiz/screen/quiz/result_failed.dart';

import 'package:tic_quiz/screen/quiz/startQuiz_page.dart';
import 'package:tic_quiz/screen/auth/Login.dart';
import 'package:tic_quiz/screen/auth/new_password.dart';
import 'package:tic_quiz/screen/auth/register.dart';
import 'package:tic_quiz/screen/auth/reset_password_email.dart';
import 'package:tic_quiz/screen/auth/reset_password_phone.dart';
import 'package:tic_quiz/screen/auth/verification.dart';
import 'package:tic_quiz/screen/home_page.dart';
import 'package:tic_quiz/screen/welcome.dart';

class AppRoutes {
  // Authentication routes
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPasswordByPhone = '/reset_password_phone';
  static const String resetPasswordByEmail = '/reset_password_email';
  static const String verificationPassword = '/verification_password';
  static const String newPassword = '/new_password';

  // Main app routes
  static const String main ='/main'; // Renamed from 'home' to match previous logic
  static const String admin = '/admin'; // Added admin route

  // Quiz routes
  static const String startQuiz = '/startQuiz';
  static const String quizPage = '/quiz';
  static const String win = '/win';
  static const String lose = '/lose';
  static const String home = '/home_page'; // Added home page route
  static const String exitDialog = '/exit_dialog';
  

  static final Map<String, WidgetBuilder> routes = {
    welcome: (context) => const Welcome(),
    home: (context) => const HomePage(), // Maps to Welcome as the home screen
    login: (context) => const LoginScreen(),
    signup: (context) => const Register(),
    resetPasswordByPhone: (context) => const ResetPasswordByPhone(),
    resetPasswordByEmail: (context) => const ResetPasswordByEmail(),
    verificationPassword: (context) => const VerificationPassword(),
    newPassword: (context) => const NewPassword(), // Maps to HomePage as the main screen
    admin: (context) => const AdminScreen(), // Placeholder for admin screen
    startQuiz: (context) => const StartQuizPage(),
    quizPage: (context) => const QuizPage(),
    win: (context) => const WinPage(), // Corrected to match import
    lose: (context) => const LossPage(), // Corrected to match import
    exitDialog: (context) => ExitDialog(), // Corrected to match import
    main: (context) => const MainScreen(),
  };
}

// Placeholder widget for AdminScreen
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Admin Screen')));
  }
}
