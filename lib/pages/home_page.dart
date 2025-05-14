import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("You have attempted a total 40 quizzes!", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: CircularProgressIndicator(
                      value: 40 / 50,
                      strokeWidth: 10,
                      color: Colors.green,
                    ),
                  ),
                  const Text("40/50\nquiz played", textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Featured Categories", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryIcon("assets/icons/cpp.png", "C++"),
                _buildCategoryIcon("assets/icons/java.png", "Java"),
                _buildCategoryIcon("assets/icons/html.png", "HTML"),
                _buildCategoryIcon("assets/icons/python.png", "Python"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String asset, String label) {
    return Column(
      children: [
        Image.asset(asset, width: 40, height: 40),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
