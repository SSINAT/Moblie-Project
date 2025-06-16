import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tic_quiz/pages/Login.dart';
import 'package:tic_quiz/pages/new_password.dart';
import 'package:tic_quiz/pages/reset_password_phone.dart';

class VerificationPassword extends StatefulWidget {
  const VerificationPassword({super.key});
  @override
  _verificationPassword createState() => _verificationPassword();
}

class _verificationPassword extends State<VerificationPassword> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Column(
              children: [
                Center(
                  child: Text(
                    "Verification",
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

            Text(
              "Enter verification code",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 48, 45, 45),
              ),
            ),
            SizedBox(height: 5),
            // TextField(
            //   decoration: InputDecoration(
            //     hintText: "Enter code here",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(14),
            //       borderSide: BorderSide(
            //         color: const Color.fromARGB(128, 211, 211, 211),
            //         width: 0.2,
            //       ),
            //     ),
            //   ),
            // ),
            PinCodeTextField(
              appContext: context,
              length: 6,

              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.circle,
                // borderRadius: BorderRadius.circular(5),
                fieldHeight: 40,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPassword()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 43, 6, 253),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Set border radius for button
                ),
              ),
              child: Text('Verify', style: TextStyle(fontSize: 16)),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "If you didn't receive the code, ",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 64, 64, 64),
                      ),
                    ),
                    SizedBox(width: 2),
                    TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LoginScreen(),
                        //   ),
                        // );
                      },
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 0, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                "Back to login",
                style: TextStyle(
                  color: const Color.fromARGB(255, 65, 64, 67),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            SizedBox(height: 80),
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
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Set border radius for button
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
