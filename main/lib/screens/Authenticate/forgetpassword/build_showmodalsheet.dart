import 'package:flutter/material.dart';
import 'package:main/screens/Authenticate/forgetpassword/forget_password_btn_widget.dart';
import 'package:main/screens/Authenticate/forgetpassword/forgetpasswordmail.dart';
import 'package:main/screens/Authenticate/forgetpassword/forgetpasswordphone.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildshowmodalbottomsheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Make Selection!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Select one of the options given below to reset your password.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  forgetpasswordbtnwidget(
                    btnIcon: Icons.mail_outline_rounded,
                    title: 'E-mail',
                    subtitle: 'Reset via E-mail Verification',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ForgetPasswordmailScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  forgetpasswordbtnwidget(
                    btnIcon: Icons.mobile_friendly_rounded,
                    title: 'Phone No',
                    subtitle: 'Reset via Phone Verification',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ForgetPasswordphoneScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ));
  }
}
