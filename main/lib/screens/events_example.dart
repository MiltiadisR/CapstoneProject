// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/event_details_screen.dart';
import 'package:main/ical_links_service.dart';
import 'package:main/services/auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import '../utils.dart';
import 'package:main/Settings.dart';
import 'package:main/constants.dart';

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class Event {
  final String location;
  final String guestName;
  final String phoneNumber;
  final DateTime startDateTime;
  final DateTime endDateTime;

  Event({
    required this.location,
    required this.guestName,
    required this.phoneNumber,
    required this.startDateTime,
    required this.endDateTime,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      location: map['summary']?.split('-')[0].trim() ?? 'No location',
      guestName: map['summary']?.split('-')[1].trim() ?? 'No guest name',
      phoneNumber:
          '', // You can extract the phone number similar to what you did before
      startDateTime: DateTime.parse(map['dtstart']['dt']),
      endDateTime: DateTime.parse(map['dtend']['dt']),
    );
  }
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final IcalLinksService _icalLinksService = IcalLinksService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late List<String> _icalDataList; // Store iCal data here

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // Fetch iCal data only at the start
    _fetchIcalData().then((jsonDataList) {
      setState(() {
        _icalDataList = jsonDataList;
        allEvents = getAllEvents(_icalDataList);
      });
    });
  }

  Future<List<String>> _fetchIcalData() async {
    try {
      return await getIcalDataList();
    } catch (error) {
      print('Error fetching iCal data: $error');
      // Handle errors as needed
      return [];
    }
  }

  void _onListTileTap(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: event),
      ),
    );
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Use the fetched events and filter based on the selected day
    return allEvents
        .where(
            (event) => isSameDay(DateTime.parse(event['dtstart']['dt']), day))
        .map((event) => Event.fromMap(event))
        .toList();
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    try {
      final days = daysInRange(start, end);

      return allEvents
          .where((event) {
            try {
              DateTime eventStart = parseDate(event['dtstart']['dt']);
              DateTime eventEnd = parseDate(event['dtend']['dt']);
              return days.any(
                  (day) => day.isAfter(eventStart) && day.isBefore(eventEnd));
            } catch (e) {
              print('Error parsing date for event: $event');
              return false;
            }
          })
          .map((event) => Event.fromMap(event))
          .toList();
    } catch (e) {
      print('Error in _getEventsForRange: $e');
      return [];
    }
  }

  DateTime parseDate(String dateString) {
    try {
      // Assuming the date format is 'yyyyMMdd'
      int year = int.parse(dateString.substring(0, 4));
      int month = int.parse(dateString.substring(4, 6));
      int day = int.parse(dateString.substring(6, 8));

      return DateTime(year, month, day);
    } catch (e) {
      print('Error parsing date: $dateString');
      rethrow; // Rethrow the exception to propagate it further
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      // Update _selectedEvents based on the stored iCal data
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  String? propertyFilter;
  static List<Map<String, dynamic>> allEvents = [];

  String userId = AuthService().getCurrentUserId();

  Future<List<String>> getUrls() async {
    List<String> savedIcalLinks =
        await _icalLinksService.getSavedIcalLinks(userId);
    return savedIcalLinks;
  }

  Future<List<String>> _initializeIcalDataList() async {
    _icalDataList = await getIcalDataList();
    return _icalDataList;
  }

  Future<List<String>> getIcalDataList() async {
    List<String> urls = await getUrls();

    // Use Future.wait to execute requests concurrently
    List<Future<String>> futures = urls.map((url) => getIcalData(url)).toList();
    List<String> dataList = await Future.wait(futures);

    return dataList;
  }

  Future<String> getIcalData(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var icsObj = ICalendar.fromString(response.body);
      String result = jsonEncode(icsObj.toJson());
      return result;
    } else {
      print("Request failed with status Code: ${response.statusCode}");
      throw Exception("Failed to fetch data");
    }
  }

  List<Map<String, dynamic>> parseEvents(String jsonString) {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    if (jsonData.containsKey('data')) {
      return List<Map<String, dynamic>>.from(jsonData['data']);
    }
    return [];
  }

//----This part is for the filtering and sorting of the events----------------//
  List<Map<String, dynamic>> getAllEvents(List<String> jsonDataList) {
    List<Map<String, dynamic>> allEvents = [];
    for (String jsonData in jsonDataList) {
      allEvents.addAll(parseEvents(jsonData));
    }
    return allEvents;
  }
// ---------------------------------------------------------------------------//

  List<String> getDistinctProperties(List<Map<String, dynamic>> events) {
    Set<String> distinctProperties = Set<String>();
    for (var event in events) {
      String summary = event['summary'] ?? '';
      List<String> summaryParts = summary.split('-');
      if (summaryParts.isNotEmpty) {
        distinctProperties.add(summaryParts[0].trim());
      }
    }
    return distinctProperties.toList();
  }

  Widget buildEventWidget(Map<String, dynamic> event) {
    String phoneNumber = '';

    String description = event['description'] ?? '';
    RegExp regExp = RegExp(r'Phone Number: (.+)$');
    Match? match = regExp.firstMatch(description);
    if (match != null) {
      phoneNumber = match.group(1) ?? '';
    }

    // Extracting values from the summary
    String location = event['summary']?.split('-')[0].trim() ?? 'No location';
    String guestName =
        event['summary']?.split('-')[1].trim() ?? 'No guest name';

    // Formatting start and end dates
    String startDate = formatDate(event['dtstart']['dt']);
    String endDate = formatDate(event['dtend']['dt']);

    // Check if the start date matches the selected day
    if (startDate == formatDate(_selectedDay.toString())) {
      return Card(
        color: Color(0xFFF4FBF9),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            '$location - $guestName',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Start: $startDate',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
              Text(
                'End: $endDate',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Phone Number: $phoneNumber',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          onTap: () => _onListTileTap(event),
        ),
      );
    } else {
      // Return an empty container if the start date doesn't match
      return Container();
    }
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = "${date.day}/${date.month}/${date.year}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C3b2E),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity, // Set the width based on your needs
            padding: EdgeInsets.all(10.0), // Add padding inside the container
            decoration: BoxDecoration(
              color: Color(0xFF051908), // Set the desired background color
              borderRadius: BorderRadius.circular(
                  16.0), // Set the radius for rounded edges
            ),
            child: TableCalendar<Event>(
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Color(0xFFF5FBF4))),
              headerStyle: HeaderStyle(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5FBF4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  headerMargin: EdgeInsets.only(bottom: 10),
                  headerPadding: EdgeInsets.all(1)),
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                weekendTextStyle: TextStyle(color: Color(0xFF858585)),
                weekNumberTextStyle: TextStyle(color: Color(0xFF858585)),
                markerDecoration: BoxDecoration(
                    color: Color(0xFFB46617),
                    borderRadius: BorderRadius.circular(20)),
                defaultTextStyle: TextStyle(color: Color(0xFFF5FBF4)),

                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _initializeIcalDataList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<String> jsonDataList = snapshot.data ?? [];
                  allEvents = getAllEvents(jsonDataList);

                  return ListView.builder(
                    itemCount: allEvents.length,
                    itemBuilder: (context, index) {
                      return buildEventWidget(allEvents[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
