import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/servises/auth.dart';
import 'package:main/servises/database.dart';
import 'package:provider/provider.dart';

class Profile_View extends StatelessWidget {
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
            String userphone = _getphonenumber(members);
            String useremail = _getemail(members);
            String userpassword = _getUserpassword(members);

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("images/Miltos.jpg"),
                  ),
                  SizedBox(height: 16.0),

                  // User Information
                  Container(
                    width: double.infinity, // Set the width based on your needs
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        buildSectionTitle('User Information'),
                        buildInfoTile(
                            'Name', userName), // Use the retrieved name
                        buildInfoTile('Email', useremail),
                      ],
                    ),
                  ),
                  // Add more user information fields as needed

                  // Contact Information
                  Container(
                    width: double.infinity, // Set the width based on your needs
                    padding: EdgeInsets.all(
                        10.0), // Add padding inside the container
                    decoration: BoxDecoration(
                      color:
                          Color(0xFF051908), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          16.0), // Set the radius for rounded edges
                    ),
                    child: Column(
                      children: [
                        buildSectionTitle('Contact Information'),
                        buildEditableInfoTile('Phone Number', userphone),
                        buildEditableInfoTile('Address', '123 Main St, City'),
                      ],
                    ),
                  ),
                  // Add more contact information fields as needed

                  // Password Change
                  Container(
                    width: double.infinity, // Set the width based on your needs
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        buildSectionTitle('Change Password'),
                        buildPasswordChangeTile('Password', '••••••••'),

                        // Notification Preferences
                        buildSectionTitle('Notification Preferences'),
                        buildNotificationPreferencesTile(),

                        // Language Preferences
                        buildSectionTitle('Language Preferences'),
                        buildLanguagePreferencesTile(),

                        // Connected Accounts
                        buildSectionTitle('Connected Accounts'),
                        buildConnectedAccountsTile(),

                        // Activity History
                        buildSectionTitle('Activity History'),
                        buildActivityHistoryTile(),

                        // Privacy Settings
                        buildSectionTitle('Privacy Settings'),
                        buildPrivacySettingsTile(),

                        // Feedback and Ratings
                        buildSectionTitle('Feedback and Ratings'),
                        buildFeedbackAndRatingsTile(),

                        // Logout Option
                        buildSectionTitle('Logout Option'),
                        buildLogoutOptionTile(),

                        // Account Deactivation/Deletion
                        buildSectionTitle('Account Deactivation/Deletion'),
                        buildAccountDeactivationTile(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF4FBF9)),
      ),
    );
  }

  Widget buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Color(0xFFF4FBF9)),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildEditableInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Color(0xFFF4FBF9)),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      trailing: Icon(Icons.edit, color: Color(0xFFF4FBF9)),
      onTap: () {
        // Handle editing
      },
    );
  }

  Widget buildPasswordChangeTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Color(0xFFF4FBF9)),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      trailing: Icon(Icons.edit, color: Color(0xFFF4FBF9)),
      onTap: () {
        // Handle editing
      },
    );
  }

  Widget buildNotificationPreferencesTile() {
    return ListTile(
      title: Text(
        'Notification Preferences',
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      onTap: () {
        // Handle notification preferences
      },
    );
  }

  Widget buildLanguagePreferencesTile() {
    return ListTile(
      title: Text(
        'Language Preferences',
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      onTap: () {
        // Handle language preferences
      },
    );
  }

  Widget buildConnectedAccountsTile() {
    return ListTile(
      title: Text(
        'Connected Accounts',
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      onTap: () {
        // Handle connected accounts
      },
    );
  }

  Widget buildActivityHistoryTile() {
    return ListTile(
      title: Text(
        'Activity History',
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      onTap: () {
        // Handle activity history
      },
    );
  }

  Widget buildPrivacySettingsTile() {
    return ListTile(
      title: Text(
        'Privacy Settings',
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      onTap: () {
        // Handle privacy settings
      },
    );
  }

  Widget buildFeedbackAndRatingsTile() {
    return ListTile(
      title: Text(
        'Feedback and Ratings',
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      onTap: () {
        // Handle feedback and ratings
      },
    );
  }

  Widget buildLogoutOptionTile() {
    return ListTile(
      title: Row(
        children: [
          Icon(
            Icons.person,
            color: Color(0xFFF4FBF9),
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Logout',
            style: TextStyle(
              color: Color(0xFFF4FBF9),
              fontSize: 20,
            ),
          )
        ],
      ),
      onTap: () async {
        await _auth.signOut();
      },
    );
  }

  Widget buildAccountDeactivationTile() {
    return ListTile(
      title: Text('Deactivate/Delete Account',
          style: TextStyle(
            color: Color(0xFFF4FBF9),
            fontSize: 20,
          )),
      onTap: () {
        // Handle account deactivation/deletion
      },
    );
  }

  String _getUserName(QuerySnapshot members) {
    if (members.docs.isNotEmpty) {
      return members.docs[0]['name'];
    }
    return 'Guest';
  }

  String _getUserpassword(QuerySnapshot members) {
    if (members.docs.isNotEmpty) {
      return members.docs[0]['password'];
    }
    return 'password';
  }

  String _getphonenumber(QuerySnapshot members) {
    if (members.docs.isNotEmpty) {
      return members.docs[0]['phone'];
    }
    return 'Phone number';
  }

  String _getemail(QuerySnapshot members) {
    if (members.docs.isNotEmpty) {
      return members.docs[0]['email'];
    }
    return 'Email';
  }
}
