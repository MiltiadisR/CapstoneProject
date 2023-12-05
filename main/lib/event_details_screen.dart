import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phoneNumber = '';
    String description = event['description'] ?? '';
    RegExp regExp = RegExp(r'Phone Number: (.+)$');
    Match? match = regExp.firstMatch(description);
    if (match != null) {
      phoneNumber = match.group(1) ?? '';
    }

    String location = event['summary']?.split('-')[0].trim() ?? 'No location';
    String guestName =
        event['summary']?.split('-')[1].trim() ?? 'No guest name';
    String startDate = formatDate(event['dtstart']['dt']);
    String endDate = formatDate(event['dtend']['dt']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '$location - $guestName',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Start Date: $startDate',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            Text(
              'End Date: $endDate',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Phone Number: $phoneNumber',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = "${date.day}/${date.month}/${date.year}";
    return formattedDate;
  }
}
