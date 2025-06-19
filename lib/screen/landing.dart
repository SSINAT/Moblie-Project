// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:tic_quiz/routes/app_routes.dart';

// class MyLanding extends StatefulWidget {
//   const MyLanding({super.key});

//   @override
//   State<MyLanding> createState() => _MyLandingState();
// }

// class _MyLandingState extends State<MyLanding> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         Navigator.pushReplacementNamed(context, AppRoutes.home);
//       } else {
//         Navigator.pushReplacementNamed(context, AppRoutes.welcome);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Image.asset('assets/Logo.png', height: 250),
//       ),
//     );
//   }
// }
