import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';

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
  late List<Future<String>> _icalDataList;
  String? propertyFilter;
  static List<Map<String, dynamic>> allEvents = [];

  @override
  void initState() {
    super.initState();
    _icalDataList = getIcalDataList();
  }

  List<String> getUrls() {
    return [
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/95a2a0be-00b1-4830-8742-0c43cf072878",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/aac123f5-2db7-4e7a-9d5f-7641a0527b11",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/abc6b05c-cc04-4ef4-90b2-22d1b306d597",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/928a4d5a-3930-46d2-b127-7d5b8a2c6241",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/00bcf820-1c96-4086-bc72-e23ea7a254f7",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/72be8e10-26b0-4788-a46b-c329f252ad17",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/b6204a16-a5ea-48b0-84f3-1c77362df3f6",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/553b81c8-fc4e-4068-8983-6f2f66dedb7e",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/9a1fa378-688a-4a6a-b518-36c2c9f033a0",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/1b0fc415-098a-4928-a976-78c923b6f4a4",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/e2fc4710-dc42-4650-96c9-73002628d51e",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/fb0d170e-d7b5-415c-8ecf-e90a04971b50"
    ];
  }

  List<Future<String>> getIcalDataList() {
    List<String> urls = getUrls();
    return urls.map((url) => getIcalData(url)).toList();
  }

  Future<String> getIcalData(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var icsObj = ICalendar.fromString(response.body);
      String result = jsonEncode(icsObj.toJson());
      print(result);
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
      return dateB.compareTo(dateA);
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
      appBar: AppBar(
        title: Text('Reservations'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              List<String> jsonDataList = await Future.wait(_icalDataList);
              allEvents.clear(); // Clear the list before applying the filter
              allEvents.addAll(getAllEvents(jsonDataList));
              print(allEvents);
            },
            child: Text('Print Events'),
          ),
          DropdownButton<String>(
            value: propertyFilter,
            hint: Text('Select Property'),
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
                    child: Text(property),
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: Future.wait(_icalDataList),
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
