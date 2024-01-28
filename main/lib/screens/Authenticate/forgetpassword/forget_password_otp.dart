import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPScreen extends StatefulWidget {
  final String contact;
  OTPScreen({required this.contact});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    String contact = widget.contact;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
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
                'Enter the verification code send at $contact',
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
      ),
    );
  }
}
