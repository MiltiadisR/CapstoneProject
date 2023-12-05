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
      appBar: AppBar(
        title: Text('Settings'),
      ),
    );
  }
}
