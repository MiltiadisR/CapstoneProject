import 'package:flutter/material.dart';
import 'Profile.dart';
import 'Calendar_View.dart';
import 'Menu.dart';
import 'screens/Home/Home.dart';

class All_Screen extends StatefulWidget {
  const All_Screen({super.key});

  @override
  State<All_Screen> createState() => _AllScreenState();
}

class _AllScreenState extends State<All_Screen> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, // hides the debug banner
        home: MyAppExtention());
  }
}

class MyAppExtention extends StatefulWidget {
  const MyAppExtention({super.key});

  @override
  State<MyAppExtention> createState() => _MyAppExtentionState();
}

class _MyAppExtentionState extends State<MyAppExtention> {
  String title = 'App Title';
  int currentIndex = 0;
  List<Widget> body = const [
    Icon(Icons.home),
    Icon(Icons.menu),
    Icon(Icons.settings),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: currentIndex == 0
              ? Text("Home")
              : currentIndex == 1
                  ? Text("Calendar")
                  : currentIndex == 2
                      ? Text("Profile")
                      : Text("Menu")),
      body: Center(
          child: currentIndex == 0
              ? Home()
              : currentIndex == 1
                  ? Calendar_View()
                  : currentIndex == 2
                      ? Profile_View()
                      : Menu()),
      bottomNavigationBar: (BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // you need this for more than 3 items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      )),
    );
  }
}
