import 'package:flutter/material.dart';
import 'Reservation_Details.dart';
import 'Notifications.dart';
import 'Settings.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMenuItem(
              icon: Icons.settings,
              title: "Settings",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Settings_View()),
                );
              },
            ),
            buildMenuItem(
              icon: Icons.note_add_outlined,
              title: "Reservation Details",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Reservation_Details()),
                );
              },
            ),
            buildMenuItem(
              icon: Icons.notifications,
              title: "Notifications",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Notifications_View()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.blue,
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
