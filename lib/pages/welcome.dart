import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/welcome.png', 
              height: 150, 
            ),
            const SizedBox(height: 20), 
            const Text(
              'Welcome to Tic Quiz',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 43, 6, 253),
                minimumSize: const Size(250, 50),
              ),
              child: const Text(
              
                'Register',
                style: TextStyle(color: Colors.white), 
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                minimumSize: const Size(250, 50),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.black), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
