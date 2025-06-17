import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_quiz/screen/auth/register.dart';
import 'package:tic_quiz/screen/auth/reset_password_email.dart';
import 'package:tic_quiz/screen/main_page.dart';
import 'package:tic_quiz/screen/admin/admin_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      User? user = userCredential.user;

      // Set displayName if not already set (e.g., from email username)
      if (user != null && user.displayName == null) {
        String defaultName = emailController.text.split('@')[0];
        await user.updateDisplayName(defaultName);
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': defaultName,
        }, SetOptions(merge: true));
      }

      // Check if the user is an admin (e.g., based on email or role)
      if (user?.email == 'admin@gmail.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
        );
      } else {
        // Fetch role from Firestore to handle more complex role management
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get();
        String? role = userDoc['role'];
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF083DED),
                ),
              ),
              Text(
                'Welcome to the Tic Quiz',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 24),
              Text('Email'),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'hello@example.com',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Password'),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF083DED),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordByEmail(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Color(0xFF083DED)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('or continue with'),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Image.asset('assets/google.png', height: 24),
                label: const Text(
                  'Google',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      "Create now",
                      style: TextStyle(color: Color(0xFF083DED)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
