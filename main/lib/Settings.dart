import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/services/auth.dart';
import 'constants.dart';

class Settings_View extends StatefulWidget {
  @override
  _Settings_ViewState createState() => _Settings_ViewState();
}

class _Settings_ViewState extends State<Settings_View> {
  TextEditingController _icalLinkController = TextEditingController();
  CollectionReference _icalLinksCollection =
      FirebaseFirestore.instance.collection('icalLinks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C3b2E),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your iCal link:',
                style: TextStyle(color: Color(0xFFF5FBF4)),
              ),
              TextField(
                controller: _icalLinkController,
                decoration: InputDecoration(
                    hintText: 'https://your-ical-link.com',
                    hintStyle: TextStyle(color: Color(0xFFF5FBF4))),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Save the entered iCal link to Firestore
                  String userId = AuthService().getCurrentUserId();

                  // Check if the document exists
                  bool documentExists = await _icalLinksCollection
                      .doc(userId)
                      .get()
                      .then((doc) => doc.exists);

                  if (!documentExists) {
                    // If the document doesn't exist, create a new one
                    await _icalLinksCollection
                        .doc(userId)
                        .set({'icalLinks': []});
                  }

                  // Update the document with the new iCal link
                  await _icalLinksCollection.doc(userId).update({
                    'icalLinks':
                        FieldValue.arrayUnion([_icalLinkController.text])
                  }).catchError((error) {
                    print('Failed to add iCal link: $error');
                  });

                  // Clear the text field after saving
                  _icalLinkController.clear();
                },
                child: Text(
                  'Save iCal Link',
                  style: TextStyle(color: Color(0xFF051908)),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Saved iCal Links:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFF5FBF4)),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF051908),
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the value as needed
                ),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _icalLinksCollection
                      .doc(AuthService().getCurrentUserId())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.data() == null) {
                      return Text('No links saved');
                    }

                    final List<String> savedIcalLinks =
                        List<String>.from(snapshot.data?['icalLinks'] ?? []);

                    Links.addAll(savedIcalLinks);

                    return Column(
                      children: [
                        for (var link in savedIcalLinks)
                          ListTile(
                            title: Text(
                              link,
                              style: TextStyle(color: Color(0xFFF5FBF4)),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteIcalLink(link),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteIcalLink(String linkToDelete) async {
    // Delete the specified iCal link from Firestore
    String userId = AuthService().getCurrentUserId();
    await _icalLinksCollection.doc(userId).update({
      'icalLinks': FieldValue.arrayRemove([linkToDelete])
    }).catchError((error) {
      print('Failed to delete iCal link: $error');
    });
  }
}
