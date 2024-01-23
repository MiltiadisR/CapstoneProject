import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:main/ical_links_service.dart';
import 'package:main/services/auth.dart';

class Reservation_Details extends StatefulWidget {
  const Reservation_Details({super.key});

  @override
  State<Reservation_Details> createState() => _Reservation_DetailsState();
}

class _Reservation_DetailsState extends State<Reservation_Details> {
  @override
  Widget build(BuildContext context) {
    return TestIcal();
  }
}

class TestIcal extends StatefulWidget {
  const TestIcal({Key? key}) : super(key: key);

  @override
  State<TestIcal> createState() => _TestIcalState();
}

class _TestIcalState extends State<TestIcal> {
  String? propertyFilter;
  static List<Map<String, dynamic>> allEvents = [];
  final IcalLinksService _icalLinksService = IcalLinksService();
  late List<String> _icalDataList;

  @override
  void initState() {
    super.initState();

    _fetchIcalData().then((jsonDataList) {
      setState(() {
        _icalDataList = jsonDataList;
        allEvents = getAllEvents(_icalDataList);
      });
    });
  }

  Future<List<String>> _fetchIcalData() async {
    try {
      return await _getIcalDataList();
    } catch (error) {
      print('Error fetching iCal data: $error');
      // Handle errors as needed
      return [];
    }
  }

  String userId = AuthService().getCurrentUserId();

  Future<List<String>> getUrls() async {
    List<String> savedIcalLinks =
        await _icalLinksService.getSavedIcalLinks(userId);
    return savedIcalLinks;
  }

  Future<List<String>> _initializeIcalDataList() async {
    _icalDataList = await _getIcalDataList();
    return _icalDataList;
  }

  Future<List<String>> _getIcalDataList() async {
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

    // Filter out events with end dates earlier than today
    DateTime today = DateTime.now();
    allEvents = allEvents.where((event) {
      DateTime endDate = DateTime.parse(event['dtend']['dt']);
      return endDate.isAfter(today);
    }).toList();

    // Sort the list by the 'dtstart' key
    allEvents.sort((a, b) {
      DateTime dateA = DateTime.parse(a['dtstart']['dt']);
      DateTime dateB = DateTime.parse(b['dtstart']['dt']);
      return dateA.compareTo(dateB);
    });

    // Apply property filter if selected
    if (propertyFilter != null && propertyFilter != 'All') {
      allEvents = allEvents
          .where((event) =>
              event['summary']
                  ?.toLowerCase()
                  .contains(propertyFilter!.toLowerCase()) ??
              false)
          .toList();
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

    return Column(
      children: [
        ListTile(
          title: Text('$location - $guestName'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start: $startDate | End: $endDate'),
              SizedBox(height: 4),
              Text(
                'Phone Number: $phoneNumber',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Divider(), // Add a Divider after each ListTile
      ],
    );
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
      appBar: AppBar(
        backgroundColor: Color(0xFFF5FBF4),
        title: Text('Reservations',
            style: TextStyle(
              color: Color(0xFFacbdaa),
            )),
      ),
      body: Column(
        children: [
          //ElevatedButton(
          //onPressed: () async {
          //List<String> jsonDataList = await Future.wait(_icalDataList);
          //allEvents.clear(); // Clear the list before applying the filter
          //allEvents.addAll(getAllEvents(jsonDataList));
          //print(allEvents);
          //},
          //child: Text('Print Events'),
          //),
          DropdownButton<String>(
            value: propertyFilter,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            dropdownColor: Color(0xFF051908),
            hint: Text(
              'Select Property',
              style: TextStyle(color: Color(0xFFF5FBF4)),
            ),
            onChanged: (String? newValue) {
              print("Selected Property: $newValue");
              setState(() {
                propertyFilter = newValue;
              });
            },
            items: [
              'All',
              'Elegant & Pool',
              'Family',
              'Garden & Pool',
              'Lake & Pool',
              'Onore Villa',
              'Private & Pool',
              'Sea Suite',
              'Sky Suite',
              'Sunset & Pool',
              'Nikos',
              'Angeliki',
              'Delphine'
            ]
                .map<DropdownMenuItem<String>>(
                  (String property) => DropdownMenuItem<String>(
                    value: property,
                    child: Text(property,
                        style: TextStyle(
                          color: Color(0xFFF5FBF4),
                        )),
                  ),
                )
                .toList(),
          ),
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

                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(
                        10.0), // Set the width based on your needs
                    padding: EdgeInsets.all(
                        10.0), // Add padding inside the container
                    decoration: BoxDecoration(
                      color:
                          Color(0xFFF5FBF4), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          16.0), // Set the radius for rounded edges
                    ),
                    child: ListView.builder(
                      itemCount: allEvents.length,
                      itemBuilder: (context, index) {
                        return buildEventWidget(allEvents[index]);
                      },
                    ),
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
