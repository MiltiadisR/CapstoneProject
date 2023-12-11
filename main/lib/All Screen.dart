import 'package:flutter/material.dart';
import 'package:main/servises/auth.dart';
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

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C3b2E),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5FBF4),
        title: currentIndex == 0
            ? Text("Home",
                style: TextStyle(
                  color: Color(0xFFacbdaa),
                ))
            : currentIndex == 1
                ? Text("Calendar", style: TextStyle(color: Color(0xFFacbdaa)))
                : currentIndex == 2
                    ? Text("Profile",
                        style: TextStyle(
                            color: Color(0xFFacbdaa),
                            fontWeight: FontWeight.bold))
                    : Text("Menu", style: TextStyle(color: Color(0xFFacbdaa))),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFA3AB92))),
            onPressed: () async {
              await _auth.signOut();
            },
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
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
            icon: Icon(Icons.home, color: Color(0xFF1e2d4c)),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month, color: Color(0xFF1e2d4c)),
              label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined, color: Color(0xFF1e2d4c)),
              label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu, color: Color(0xFF1e2d4c)), label: "Menu"),
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
