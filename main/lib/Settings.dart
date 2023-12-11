import 'package:flutter/material.dart';

class Settings_View extends StatefulWidget {
  const Settings_View({super.key});

  @override
  State<Settings_View> createState() => _Settings_ViewState();
}

class _Settings_ViewState extends State<Settings_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C3b2E),
      appBar: AppBar(
          backgroundColor: Color(0xFFF5FBF4),
          title: Text('Settings',
              style: TextStyle(
                color: Color(0xFFacbdaa),
              ))),
    );
  }
}
