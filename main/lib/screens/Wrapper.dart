import 'package:flutter/material.dart';
import 'package:main/Screens/Authenticate/authenticate.dart';
import 'package:main/models/user.dart';
import 'package:provider/provider.dart';

import '../All Screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    print(user);

    if (user == null) {
      return Authenticate();
    } else {
      return MyAppExtention();
    }
  }
}
