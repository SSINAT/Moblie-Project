import 'package:flutter/material.dart';
import 'package:tic_quiz/pages/Login.dart';
import 'package:tic_quiz/pages/home_page.dart';
import 'package:tic_quiz/pages/register.dart';
import 'package:tic_quiz/pages/welcome.dart';



class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';


  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const Welcome(),
    login: (context) => const LoginScreen(),
    signup: (context) => const Register(),
    home: (context) => const HomePage(),

  };
}
