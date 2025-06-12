import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/Login.dart';
import 'package:tic_quiz/pages/home_page.dart';
import 'package:tic_quiz/pages/register.dart';
import 'package:tic_quiz/pages/welcome.dart';
import 'package:tic_quiz/pages/reset_password_email.dart';
import 'package:tic_quiz/pages/reset_password_phone.dart';
import 'package:tic_quiz/pages/new_password.dart';
import 'package:tic_quiz/pages/verification.dart';



class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static const String resetPassword = '/reset_password';
  static const String resetPasswordEmail = '/reset_password_email';
  static const String verification = '/verification';
  static const String newPassword = '/new_password';
  static const String profile = '/profile';
  static const String ranking = '/ranking';
  static const String resetPasswordByPhone = '/reset_password_phone';
  static const String resetPasswordByEmail = '/reset_password_email';
  static const String verificationPassword = '/verification_password';
  static const String newPasswordPage = '/new_password_page';
  static const String resetPasswordPage = '/reset_password_page'; 


  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const Welcome(),
    login: (context) =>  LoginScreen(),
    signup: (context) => const Register(),
    home: (context) => const HomePage(),
    resetPassword: (context) => const ResetPasswordByPhone(),
    resetPasswordEmail: (context) =>  ResetPasswordByEmail(),
    verification: (context) => const VerificationPassword(),
    newPassword: (context) => const NewPassword(),
    

  };
}
