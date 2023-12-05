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
      appBar: AppBar(
        title: Text('Notifications'),
      ),
    );
  }
}
