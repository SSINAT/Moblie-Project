// exit_dialog.dart
import 'package:flutter/material.dart';

class ExitDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Exit'),
      content: Text('Are you sure you want to exit?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/startQuiz'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Exit', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}
