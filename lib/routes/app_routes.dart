import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/login.dart';
import 'package:tic_quiz/pages/home_page.dart';
import 'package:tic_quiz/pages/quiz/exit_dialog.dart';
import 'package:tic_quiz/pages/quiz/quiz_page.dart';
import 'package:tic_quiz/pages/quiz/result_congrats.dart';
import 'package:tic_quiz/pages/quiz/result_failed.dart';
import 'package:tic_quiz/pages/quiz/start_page.dart';
import 'package:tic_quiz/pages/register.dart';
import 'package:tic_quiz/pages/welcome.dart';
import 'package:tic_quiz/pages/reset_password_email.dart';
import 'package:tic_quiz/pages/reset_password_phone.dart';
import 'package:tic_quiz/pages/new_password.dart';
import 'package:tic_quiz/pages/verification.dart';

class AppRoutes {
  // Authentication routes
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPasswordByPhone = '/reset_password_phone';
  static const String resetPasswordByEmail = '/reset_password_email';
  static const String verificationPassword = '/verification_password';
  static const String newPassword = '/new_password';

  // Quiz routes
  static const String home = '/home';
  static const String startQuiz = '/startQuiz';
  static const String quizPage = '/quiz';
  static const String win = '/win';
  static const String lose = '/lose';
  static const String exitDialog = '/exit_dialog';

  static final Map<String, WidgetBuilder> routes = {
    welcome: (context) => const Welcome(),
    login: (context) =>  LoginScreen(),
    signup: (context) => const Register(),
    resetPasswordByPhone: (context) => const ResetPasswordByPhone(),
    resetPasswordByEmail: (context) => const ResetPasswordByEmail(),
    verificationPassword: (context) => const VerificationPassword(),
    newPassword: (context) => const NewPassword(),
    home: (context) => const HomePage(),
    startQuiz: (context) => const StartQuizPage(),
    quizPage: (context) => const QuizPage(),
    win: (context) => const WinPage(),
    lose: (context) => const LossPage(),
    exitDialog: (context) =>  ExitDialog(),
  };
}