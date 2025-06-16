import 'package:flutter/material.dart';
import 'package:tic_quiz/views/admin/admin_dashboard_screen.dart';
import 'package:tic_quiz/views/auth/login.dart';
import 'package:tic_quiz/views/auth/register.dart';
import 'package:tic_quiz/views/home_page.dart';
import 'package:tic_quiz/views/welcome.dart';
import 'package:tic_quiz/views/auth/reset_password_phone.dart';
import 'package:tic_quiz/views/main_page.dart'; // Added MainScreen route

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String admin = '/admin';
  static const String resetPasswordByPhone = '/reset_password_phone';
  static const String main = '/main'; // New route for MainScreen

  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const Welcome(),
    login: (context) => LoginScreen(),
    signup: (context) => const Register(),
    home: (context) => const HomePage(),
    admin: (context) => const AdminDashboardScreen(),
    resetPasswordByPhone: (context) => ResetPasswordByPhone(),
    main: (context) => const MainScreen(), // Map MainScreen to /main
  };
}
