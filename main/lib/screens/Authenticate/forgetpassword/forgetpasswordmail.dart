import "package:flutter/material.dart";
import "package:main/shared/constants.dart";

class ForgetPasswordmailScreen extends StatelessWidget {
  const ForgetPasswordmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline_rounded))),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child:
                          ElevatedButton(onPressed: () {}, child: Text('Next')))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
