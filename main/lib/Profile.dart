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

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 120,
                    backgroundImage: AssetImage("images/Miltos.jpg"),
                  ),
                  SizedBox(height: 16.0),

                  // User Information
                  buildSectionTitle('User Information'),
                  buildInfoTile('Name', userName), // Use the retrieved name
                  buildInfoTile('Email', useremail),
                  // Add more user information fields as needed

                  // Contact Information
                  buildSectionTitle('Contact Information'),
                  buildEditableInfoTile('Phone Number', userphone),
                  buildEditableInfoTile('Address', '123 Main St, City'),
                  // Add more contact information fields as needed

                  // Password Change
                  buildSectionTitle('Password Change'),
                  buildPasswordChangeTile(),

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
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget buildEditableInfoTile(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      trailing: Icon(Icons.edit),
      onTap: () {
        // Handle editing
      },
    );
  }

  Widget buildPasswordChangeTile() {
    return ListTile(
      title: Text('Change Password'),
      onTap: () {
        // Handle password change
      },
    );
  }

  Widget buildNotificationPreferencesTile() {
    return ListTile(
      title: Text('Notification Preferences'),
      onTap: () {
        // Handle notification preferences
      },
    );
  }

  Widget buildLanguagePreferencesTile() {
    return ListTile(
      title: Text('Language Preferences'),
      onTap: () {
        // Handle language preferences
      },
    );
  }

  Widget buildConnectedAccountsTile() {
    return ListTile(
      title: Text('Connected Accounts'),
      onTap: () {
        // Handle connected accounts
      },
    );
  }

  Widget buildActivityHistoryTile() {
    return ListTile(
      title: Text('Activity History'),
      onTap: () {
        // Handle activity history
      },
    );
  }

  Widget buildPrivacySettingsTile() {
    return ListTile(
      title: Text('Privacy Settings'),
      onTap: () {
        // Handle privacy settings
      },
    );
  }

  Widget buildFeedbackAndRatingsTile() {
    return ListTile(
      title: Text('Feedback and Ratings'),
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
            color: Colors.black,
          ),
          Text('Logout')
        ],
      ),
      onTap: () async {
        await _auth.signOut();
      },
    );
  }

  Widget buildAccountDeactivationTile() {
    return ListTile(
      title: Text('Deactivate/Delete Account'),
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
