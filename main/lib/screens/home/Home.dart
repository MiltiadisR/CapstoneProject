import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/Load_data.dart';
import 'package:main/Reservation_Details.dart';
import '../../servises/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid: '').members,
      initialData: null,
      child: Scaffold(
        body: Consumer<QuerySnapshot?>(
          builder: (context, members, _) {
            if (members == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            String userName = _getUserName(members);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Personalized Greetings
                    Text(
                      'Hi, $userName!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),

                    // Upcoming Reservations Overview
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
                              MaterialPageRoute(
                                builder: (context) => Load_Data(),
                              ),
                            );
                          },
                          child: Text('Create Reservation'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Reservation_Details(),
                              ),
                            );
                          },
                          child: Text('Reservations'),
                        ),
                      ],
                    ),

                    // Other Card Widgets
                    CardWidget(
                        title: 'Notifications', icon: Icons.notifications),
                    CardWidget(title: 'Search Bar', icon: Icons.search),
                    CardWidget(title: 'Featured Content', icon: Icons.star),
                    CardWidget(title: 'Recent Activity', icon: Icons.history),
                    CardWidget(
                      title: 'Promotions or Announcements',
                      icon: Icons.announcement,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getUserName(QuerySnapshot members) {
    if (members.docs.isNotEmpty) {
      return members.docs[0]['name'];
    }
    return 'Guest';
  }
}

class CardWidget extends StatefulWidget {
  final String title;
  final IconData icon;

  CardWidget({required this.title, required this.icon});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
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
              Icon(widget.icon, size: 40.0, color: Colors.blue),
              SizedBox(height: 8.0),
              Text(
                widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
