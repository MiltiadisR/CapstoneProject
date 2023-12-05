import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';

class Loaddata {
  static late List<Map<String, dynamic>> x;

  Future<List<Map<String, dynamic>>> getEvents() async {
    List<String> urls = [
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/95a2a0be-00b1-4830-8742-0c43cf072878",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/aac123f5-2db7-4e7a-9d5f-7641a0527b11",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/abc6b05c-cc04-4ef4-90b2-22d1b306d597",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/928a4d5a-3930-46d2-b127-7d5b8a2c6241",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/00bcf820-1c96-4086-bc72-e23ea7a254f7",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/72be8e10-26b0-4788-a46b-c329f252ad17",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/b6204a16-a5ea-48b0-84f3-1c77362df3f6",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/553b81c8-fc4e-4068-8983-6f2f66dedb7e",
      "https://sync.guestyforhosts.com/bc19e1fc-037a-4e0e-abfc-4963423a4458/9a1fa378-688a-4a6a-b518-36c2c9f033a0",
    ];

    List<Future<String>> _icalDataList =
        urls.map((url) => getIcalData(url)).toList();
    List<String> jsonDataList = await Future.wait(_icalDataList);

    List<Map<String, dynamic>> allEvents = [];
    for (String jsonData in jsonDataList) {
      allEvents.addAll(parseEvents(jsonData));
    }
    x = allEvents;
    return allEvents;
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
      x = List<Map<String, dynamic>>.from(jsonData['data']);
      return x;
    }
    return [];
  }

  List<DateTime> getDateTimeList() {
    return x.map((event) {
      if (event.containsKey('start')) {
        // Assuming 'start' contains a string representation of date and time
        return DateTime.parse(event['start']);
      }
      // Return a default value if 'start' key is not present or invalid
      return DateTime.now();
    }).toList();
  }
}

class Load_Data extends StatelessWidget {
  final Loaddata loadData = Loaddata();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your App'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: loadData.getEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<Map<String, dynamic>> allEvents = snapshot.data ?? [];
              List<DateTime> dateTimeList = loadData.getDateTimeList();
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Events: ${allEvents.toString()}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'DateTime List: ${dateTimeList.toString()}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(Load_Data());
}
