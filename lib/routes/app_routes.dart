import 'package:flutter/material.dart';
import 'package:tic_quiz/views/admin/admin_dashboard_screen.dart';
import 'package:tic_quiz/views/auth/Login.dart';
import 'package:tic_quiz/views/auth/register.dart';
import 'package:tic_quiz/views/home_page.dart';
import 'package:tic_quiz/views/welcome.dart';
import 'package:tic_quiz/views/auth/reset_password_phone.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String admin = '/admin';
  static const String resetPasswordByPhone = '/reset_password_phone';

  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const Welcome(),
    login: (context) => LoginScreen(),
    signup: (context) => const Register(),
    home: (context) => const HomePage(),
    admin: (context) => const AdminDashboardScreen(),
    resetPasswordByPhone: (context) => ResetPasswordByPhone(),
  };
}
