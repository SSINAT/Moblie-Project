import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tic_quiz/screen/auth/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmController = TextEditingController();

Future<bool> registerUser({
  required String name,
  required String password,
  required String email,
  required String confirm,
  required Function(String) onError,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    // Set displayName in FirebaseAuth
    await user?.updateDisplayName(name);

    // Save additional user info in Firestore
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'uid': user.uid,
      'email': email,
      'name': name,
      'createdAt': Timestamp.now(),
    });

    print("User registered successfully: ${user.uid}");
    onError("User registered successfully");

    return true;
  } on FirebaseAuthException catch (e) {
    print("Error registering user: $e");
    if (e.code == 'email-already-in-use') {
      onError("The account already exists for that email.");
    } else if (e.code == 'weak-password') {
      onError("The password provided is too weak.");
    } else if (e.code == 'invalid-email') {
      onError("The email address is not valid.");
    } else {
      onError("An error occurred. Please try again.");
    }
    return false;
  }
}

class _RegisterScreen extends State<Register> {
  bool _obscurePassword = true;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Column(
              children: [
                Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 40,
                      color: const Color.fromARGB(255, 43, 6, 253),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 48, 45, 45),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(128, 211, 211, 211),
                    width: 0.2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Email",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 48, 45, 45),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "example@gmail.com",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(128, 211, 211, 211),
                    width: 0.2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 48, 45, 45),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(128, 211, 211, 211),
                    width: 0.2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 48, 45, 45),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              obscureText: true,
              controller: confirmController,
              decoration: InputDecoration(
                hintText: 'Confirm your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(128, 211, 211, 211),
                    width: 0.2,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                _passwordError ?? '',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text != confirmController.text) {
                  setState(() {
                    _passwordError = "Passwords do not match.";
                  });
                  return;
                }
                setState(() {
                  _passwordError = null;
                });
                bool success = await registerUser(
                  name: nameController.text,
                  password: passwordController.text,
                  email: emailController.text,
                  confirm: confirmController.text,
                  onError:
                      (e) => setState(() {
                        _passwordError = e;
                      }),
                );
                if (success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 43, 6, 253),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Create Account', style: TextStyle(fontSize: 16)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Already have an account ? ",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 64, 64, 64),
                      ),
                    ),
                    SizedBox(width: 2),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Login Now",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 40, 4, 245),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Divider(
                    color: const Color.fromARGB(255, 19, 25, 30),
                    thickness: 1.2,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "or continue with",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 64, 64, 64),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 100,
                  child: Divider(
                    color: const Color.fromARGB(255, 19, 25, 30),
                    thickness: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                backgroundColor: const Color.fromARGB(255, 222, 222, 222),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Image.asset('assets/google_logo.png', height: 25),
                  SizedBox(width: 10),
                  Text('Google', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
