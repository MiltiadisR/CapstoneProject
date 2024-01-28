import "package:flutter/material.dart";
import "package:main/shared/constants.dart";

import "forget_password_otp.dart";

class ForgetPasswordphoneScreen extends StatelessWidget {
  const ForgetPasswordphoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String contact = '';
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Phone Number',
                        prefixIcon: Icon(Icons.numbers)),
                    onChanged: (val) {
                      contact = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                  contact: contact,
                                ),
                              ),
                            );
                          },
                          child: Text('Next')))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
