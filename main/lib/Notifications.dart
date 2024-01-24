import 'package:flutter/material.dart';

class Notifications_View extends StatefulWidget {
  const Notifications_View({super.key});

  @override
  State<Notifications_View> createState() => _Notifications_ViewState();
}

class _Notifications_ViewState extends State<Notifications_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C3b2E),
      appBar: AppBar(
          backgroundColor: Color(0xFFF5FBF4),
          title: Text('Notifications',
              style: TextStyle(
                color: Color(0xFFacbdaa),
              ))),
      body: Container(
        alignment: Alignment.center,
        child: Text(
          'Coming soon...',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF4FBF9)),
        ),
      ),
    );
  }
}
