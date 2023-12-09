import 'package:flutter/material.dart';
import 'package:main/Calendar_View.dart';
import 'package:main/Load_data.dart';
import 'package:main/Menu.dart';
import 'package:main/Profile.dart';
import '../../Reservation_Details.dart';

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
                    : Text("Menu"),
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                Text('Logout')
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

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home> {
  String buttonname = "Click";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Personalized Greetings
              Text(
                'Good morning, [User]!', // Replace [User] with the actual user's name
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),

              // Upcoming Reservations Overview
              // Include your upcoming reservations widget here
              // Replace PlaceholderWidget() with your actual widget
              CardWidget(
                title: 'Upcoming Reservations',
                icon: Icons.calendar_today,
              ),

              SizedBox(height: 16.0),

              // Quick Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Load_Data()),
                      );
                      setState(() {
                        buttonname = "Clicked";
                      });
                    },
                    child: Text('Create Reservation'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => Reservation_Details()),
                      );
                      setState(() {
                        buttonname = "Next Page";
                      });
                    },
                    child: Text('Reservations'),
                  ),
                ],
              ),

              // Include additional sections based on your requirements

              // Notifications
              // Include your notifications widget here
              // Replace PlaceholderWidget() with your actual widget
              CardWidget(
                title: 'Notifications',
                icon: Icons.notifications,
              ),

              // Search Bar
              // Include your search bar widget here
              // Replace PlaceholderWidget() with your actual widget
              CardWidget(
                title: 'Search Bar',
                icon: Icons.search,
              ),

              // Featured Content
              // Include your featured content widget here
              // Replace PlaceholderWidget() with your actual widget
              CardWidget(
                title: 'Featured Content',
                icon: Icons.star,
              ),

              // Recent Activity
              // Include your recent activity widget here
              // Replace PlaceholderWidget() with your actual widget
              CardWidget(
                title: 'Recent Activity',
                icon: Icons.history,
              ),

              // Promotions or Announcements
              // Include your promotions or announcements widget here
              // Replace PlaceholderWidget() with your actual widget
              CardWidget(
                title: 'Promotions or Announcements',
                icon: Icons.announcement,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  CardWidget({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          // Add navigation or action on card tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40.0, color: Colors.blue),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
