import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0C3b2E),
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xFFA3AB92),
          size: 50.0,
        ),
      ),
    );
  }
}
