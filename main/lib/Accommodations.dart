import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:main/Reservation_Details_only_one.dart';

class rooms extends StatefulWidget {
  const rooms({super.key});

  @override
  State<rooms> createState() => _roomsState();
}

class _roomsState extends State<rooms> {
  @override
  Widget build(BuildContext context) {
    return CarouselDemo();
  }
}

class CarouselDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C3b2E),
      appBar: AppBar(
          backgroundColor: Color(0xFFF5FBF4),
          title: Text('Accommodations',
              style: TextStyle(
                color: Color(0xFFacbdaa),
              ))),
      body: Center(
        child: CarouselSlider(
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
            aspectRatio: 9 / 16,
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
            scrollDirection: Axis.vertical,
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
      width: 400.0, // Set your desired width
      height: 200.0, // Set your desired height
      child: Card(
        elevation: 4.0,
        color: Color(0xFFF5FBF4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => widget.path,
              ),
            );
            // Add navigation or action on card tap
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 80.0, color: Color(0xFF051908)),
                SizedBox(height: 1.0),
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF051908)),
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
