import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_quiz/screen/welcome.dart';
import 'package:tic_quiz/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_quiz/services/firestore_service.dart';

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
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Arial'),
      home: const Root(),
      routes: AppRoutes.routes, // Use the defined routes
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool _isLoading = true;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final isAdmin = await _firestoreService.isAdmin(user.uid);
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            isAdmin ? AppRoutes.admin : AppRoutes.main,
          );
        }
      } catch (e) {
        print('Error checking admin status: $e');
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : const Welcome();
  }
}
