import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            String imageurl = _getimageurl(members);

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Picture
                  buildProfilePicture(context, members),
                  SizedBox(height: 16.0),

                  // User Information
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        buildSectionTitle('User Information'),
                        buildInfoTile('Name', userName),
                        buildInfoTile('Email', useremail),
                      ],
                    ),
                  ),
                  // Add more user information fields as needed

                  // Contact Information
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF051908),
                      borderRadius: BorderRadius.circular(16.0),
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
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        buildSectionTitle('Change Password'),
                        buildPasswordChangeTile(
                            'Password', '••••••••' + userpassword),

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
                        buildAccountDeactivationTile(context),
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

  Widget buildAccountDeactivationTile(BuildContext context) {
    return ListTile(
      title: Text(
        'Deactivate/Delete Account',
        style: TextStyle(
          color: Color(0xFFF4FBF9),
          fontSize: 20,
        ),
      ),
      onTap: () {
        showDeactivationConfirmationDialog(context);
      },
    );
  }

  Future<void> showDeactivationConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Account Deactivation'),
          content:
              Text('Are you sure you want to deactivate/delete your account?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Perform the account deactivation/deletion logic here

                DatabaseService(uid: '').deleteUserData();

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Widget buildProfilePicture(BuildContext context, QuerySnapshot members) {
    String imageurl = _getimageurl(members);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (imageurl.isEmpty) {
              // Pass the context to _uploadImage method
              _uploadImage(context);
            }
          },
          child: CircleAvatar(
            radius: 80,
            backgroundImage: imageurl.isNotEmpty
                ? CachedNetworkImageProvider(imageurl)
                : null, // Set to null when imageurl is empty
            child: imageurl.isEmpty ? Icon(Icons.add, size: 40) : null,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: () {
              if (imageurl.isNotEmpty) {
                // Pass the context to _uploadImage method
                _uploadImage(context);
              }
            },
            // Set to null when imageurl is empty
            child: imageurl.isNotEmpty
                ? Text("Change Profile Picture",
                    style: TextStyle(
                      color: Color(0xFFF4FBF9),
                      fontSize: 15,
                    ))
                : null),
      ],
    );
  }

  Future<void> _uploadImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);

        // Check if the picked file is an image
        // Check if the picked file is an image
        final allowedExtensions = ['jpg', 'jpeg', 'png'];
        final fileExtension = pickedFile.path.split('.').last.toLowerCase();

        if (!allowedExtensions.contains(fileExtension)) {
          throw Exception('Invalid file format. Please choose an image.');
        }

        final userId = _auth.getCurrentUserId();
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('userimages/$userId.$fileExtension');
        print(storageRef);
        print('aaaaaaaaaaaaaaaaaaaaa');

        // Upload the image file
        await storageRef.putFile(imageFile);
        print('bbbbbbbbbbbbbbbbbbbb');

        // Get the download URL of the uploaded image
        final imageUrl = await storageRef.getDownloadURL();
        print('cccccccccccccccccccccccc');

        // Update Firestore with the download URL
        await FirebaseFirestore.instance
            .collection('testdata')
            .doc(userId)
            .update({'imageurl': imageUrl});

        // Update the user data in the provider
        Provider.of<DatabaseService>(context, listen: false).updateUserimage(
          imageUrl,
        );
      }
    } catch (error) {
      // Handle and display the error, e.g., show a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getUserName(QuerySnapshot members) {
    final userId = _auth.getCurrentUserId();

    if (members.docs.isNotEmpty) {
      // Find the document corresponding to the logged-in user
      final userDoc = members.docs.firstWhere(
        (doc) => doc.id == userId,
      );
      return userDoc['name'];
    }
    return 'Guest';
  }

  String _getUserpassword(QuerySnapshot members) {
    final userId = _auth.getCurrentUserId();

    if (members.docs.isNotEmpty) {
      // Find the document corresponding to the logged-in user
      final userDoc = members.docs.firstWhere(
        (doc) => doc.id == userId,
      );
      return userDoc['password'];
    }
    return 'password';
  }

  String _getphonenumber(QuerySnapshot members) {
    final userId = _auth.getCurrentUserId();

    if (members.docs.isNotEmpty) {
      // Find the document corresponding to the logged-in user
      final userDoc = members.docs.firstWhere(
        (doc) => doc.id == userId,
      );
      return userDoc['phone'];
    }
    return 'Phone number';
  }

  String _getemail(QuerySnapshot members) {
    final userId = _auth.getCurrentUserId();

    if (members.docs.isNotEmpty) {
      // Find the document corresponding to the logged-in user
      final userDoc = members.docs.firstWhere(
        (doc) => doc.id == userId,
      );
      return userDoc['email'];
    }

    return 'Email';
  }

  String _getimageurl(QuerySnapshot members) {
    final userId = _auth.getCurrentUserId();

    if (members.docs.isNotEmpty) {
      // Find the document corresponding to the logged-in user
      final userDoc = members.docs.firstWhere(
        (doc) => doc.id == userId,
      );
      return userDoc['imageurl'];
    }
    return 'imageurl';
  }
}
