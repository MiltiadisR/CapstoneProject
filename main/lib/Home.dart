import 'package:flutter/material.dart';
import 'package:main/Load_data.dart';
import 'Reservation_Details.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
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
