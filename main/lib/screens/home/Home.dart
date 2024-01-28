import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/Notifications.dart';
import 'package:main/Reservation_Details.dart';
import 'package:main/Reservation_Details_only_one.dart';
import 'package:main/Settings.dart';
import 'package:main/services/auth.dart';
import '../../services/database.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid: '').members,
      initialData: null,
      child: Scaffold(
        backgroundColor: Color(0xFF0C3b2E),
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
                    Text(
                      'Hi, $userName!',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF4FBF9)),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: CardWidget(
                              title: 'Upcoming Reservations',
                              icon: Icons.calendar_today,
                              path: Reservation_Details()),
                        ),
                        FittedBox(
                            fit: BoxFit.contain,
                            child: CardWidget(
                                title: 'Your iCal Links',
                                icon: Icons.data_object_outlined,
                                path: Settings_View())),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         Navigator.of(context).push(
                    //           MaterialPageRoute(
                    //             builder: (context) => Load_Data(),
                    //           ),
                    //         );
                    //       },
                    //       child: Text('Create Reservation'),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         Navigator.of(context).push(
                    //           MaterialPageRoute(
                    //             builder: (context) => Reservation_Details(),
                    //           ),
                    //         );
                    //       },
                    //       child: Text('Reservations'),
                    //     ),
                    //   ],
                    // ),
                    CardWidget(
                        title: 'Notifications',
                        icon: Icons.notifications,
                        path: Notifications_View()),
                    SizedBox(height: 50.0),
                    Text(
                      'Accommodations',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5FBF4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    userName == 'Miltiadis Raptis'
                        ? CarouselDemo()
                        : Container(),
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
    final userId = _auth.getCurrentUserId();

    if (members.docs.isNotEmpty) {
      // we try to get the name of the user
      final userDoc = members.docs.firstWhere(
        (doc) => doc.id == userId,
      );
      return userDoc['name'];
    }
    return 'Guest';
  }

  //List _geticals(QuerySnapshot ICALLINKS) {
  // final userId = _auth.getCurrentUserId();

  // if (ICALLINKS.docs.isNotEmpty) {
  //Here we try to find if the user has the  Find the document corresponding to the logged-in user
  //final userDoc = ICALLINKS.docs.firstWhere(
  //(doc) => doc.id == userId,
  //);
  //return userDoc['icalLinks'];
  //}
  // return [];
  //}
}

class CarouselDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Onore Villa',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Onore Villa'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Elegant & Pool',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Elegant & Pool'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Family',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Family'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Garden & Pool',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Garden & Pool'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Lake & Pool',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Lake & Pool'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Private & Pool',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Private & Pool'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Sea Suite',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Sea Suite'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Sky Suite',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Sky Suite'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Sunset & Pool',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Sunset & Pool'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Nikos',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Nikos'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Angeliki',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Angeliki'),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: RoomWidget(
            title: 'Delphine',
            icon: Icons.home_outlined,
            path: Reservation_Details_only_one(name: 'Delphine'),
          ),
        ),
      ],
      options: CarouselOptions(
        height: 120,
        aspectRatio: 16 / 9,
        viewportFraction: 0.2,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 1000),
        autoPlayCurve: Curves.decelerate,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          // Callback function when the page changes
          print('Page changed to index $index');
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget path;

  CardWidget({required this.title, required this.icon, required this.path});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 120.0,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Color(0xFFF5FBF4),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => widget.path,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(widget.icon, size: 40.0, color: Colors.blue),
                SizedBox(height: 8.0),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoomWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget path;

  RoomWidget({required this.title, required this.icon, required this.path});

  @override
  State<RoomWidget> createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Color(0xFFF5FBF4),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => widget.path,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 80.0, color: Colors.blue),
                SizedBox(height: 1.0),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
