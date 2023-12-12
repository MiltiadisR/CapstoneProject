import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CO\nDE',
              style: TextStyle(
                  fontSize: 80, fontWeight: FontWeight.bold, height: 1),
            ),
            Text('Verification',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text(
              'Enter the verification code send at ' + 'test@gmail.com',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code) {
                print('OTP is => $code');
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {}, child: Text('Next'))
          ],
        ),
      ),
    );
  }
}
