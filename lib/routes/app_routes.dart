import 'package:flutter/material.dart';
import 'package:tic_quiz/screen/main_page.dart';
import 'package:tic_quiz/screen/quiz/exit_dialog.dart';
import 'package:tic_quiz/screen/quiz/quiz_page.dart';
import 'package:tic_quiz/screen/quiz/result_congrats.dart';
import 'package:tic_quiz/screen/quiz/result_failed.dart';
import 'package:tic_quiz/screen/quiz/startQuiz_page.dart';
import 'package:tic_quiz/screen/auth/login.dart';
import 'package:tic_quiz/screen/auth/new_password.dart';
import 'package:tic_quiz/screen/auth/register.dart';
import 'package:tic_quiz/screen/auth/reset_password_email.dart';
import 'package:tic_quiz/screen/auth/reset_password_phone.dart';
import 'package:tic_quiz/screen/auth/verification.dart';
import 'package:tic_quiz/screen/home_page.dart';
import 'package:tic_quiz/screen/welcome.dart';
import 'package:tic_quiz/screen/admin/admin_dashboard_screen.dart'; // Import AdminDashboardScreen

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
  static const String main =
      '/main'; // Renamed from 'home' to match previous logic
  static const String admin = '/admin'; // Admin route

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
    login: (context) =>  LoginScreen(),
    signup: (context) => const Register(),
    resetPasswordByPhone: (context) => const ResetPasswordByPhone(),
    resetPasswordByEmail: (context) => const ResetPasswordByEmail(),
    verificationPassword: (context) => const VerificationPassword(),
    newPassword: (context) => const NewPassword(),
    admin:
        (context) =>
            const AdminDashboardScreen(), // Updated to use AdminDashboardScreen
    startQuiz: (context) => const StartQuizPage(),
    quizPage: (context) => const QuizPage(),
    win: (context) => const WinPage(), // Corrected to match import
    lose: (context) => const LossPage(), // Corrected to match import
    exitDialog: (context) =>  ExitDialog(), // Corrected to match import
    main: (context) => const MainScreen(),
  };
}

// Remove the placeholder AdminScreen since it's no longer needed
// class AdminScreen extends StatelessWidget { ... } can be deleted
