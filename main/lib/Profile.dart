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
            String useraddress = _getaddress(members);

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
                        buildEditableInfoTileforphonenumber(
                            'Phone Number', userphone, context),
                        buildEditableInfoTileforaddress(
                            'Address', useraddress, context),
                        SizedBox(
                          height: 10,
                        ),
                        buildSectionTitle('Change Password'),
                        buildPasswordChangeTile(
                            'Password', userpassword, context),
                      ],
                    ),
                  ),
                  // Password Change
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
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
      onTap: () {},
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

  Widget buildEditableInfoTileforphonenumber(
      String label, String value, BuildContext context) {
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
        _editPhoneNumber(context, value); // Pass the current phone number
      },
    );
  }

  Widget buildEditableInfoTileforaddress(
      String label, String value, BuildContext context) {
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
        _editadress(context, value); // Pass the current phone number
      },
    );
  }

  Future<void> _editPhoneNumber(
      BuildContext context, String currentPhoneNumber) async {
    String newPhoneNumber = ''; // Set initial value to currentPhoneNumber

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Phone Number'),
          content: TextField(
            onChanged: (value) {
              newPhoneNumber = value;
            },
            decoration: InputDecoration(
              labelText: 'New Phone Number',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Update the phone number in Firebase
                final userId = _auth.getCurrentUserId();
                await FirebaseFirestore.instance
                    .collection('testdata')
                    .doc(userId)
                    .update({'phone': newPhoneNumber});

                // Update the user data in the provider
                Provider.of<DatabaseService>(context, listen: false)
                    .updateUserPhoneNumber(newPhoneNumber);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget buildPasswordChangeTile(
      String label, String value, BuildContext context) {
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
        _editpassword(context, value);
      },
    );
  }

  Future<void> _editpassword(
      BuildContext context, String currentPhoneNumber) async {
    String newpassword = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Password'),
          content: TextField(
            onChanged: (value) {
              newpassword = value;
            },
            decoration: InputDecoration(
              labelText: 'New Password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final userId = _auth.getCurrentUserId();
                await FirebaseFirestore.instance
                    .collection('testdata')
                    .doc(userId)
                    .update({'password': newpassword});

                // Update the user data in the provider
                Provider.of<DatabaseService>(context, listen: false)
                    .updateUserPassword(newpassword);

                _auth.getCurrentUserId();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editadress(BuildContext context, String currentaddress) async {
    String newaddress = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Address'),
          content: TextField(
            onChanged: (value) {
              newaddress = value;
            },
            decoration: InputDecoration(
              labelText: 'New Address',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Update the phone number in Firebase
                final userId = _auth.getCurrentUserId();
                await FirebaseFirestore.instance
                    .collection('testdata')
                    .doc(userId)
                    .update({'address': newaddress});

                // Update the user data in the provider
                Provider.of<DatabaseService>(context, listen: false)
                    .updateUserPassword(newaddress);

                _auth.getCurrentUserId();
              },
              child: Text('Save'),
            ),
          ],
        );
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
      onTap: () {},
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
      onTap: () {},
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
    final userId = _auth.getCurrentUserId();
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
                await _auth.signOut();
                DatabaseService(uid: userId).deleteUserData();

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
          child: imageurl.isNotEmpty
              ? Text("Change Profile Picture",
                  style: TextStyle(
                    color: Color(0xFFF4FBF9),
                    fontSize: 15,
                  ))
              : SizedBox(), // Add a SizedBox if imageurl is empty
        ),
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

  String _getaddress(QuerySnapshot members) {
    final userId = _auth.getCurrentUserId();

    if (members.docs.isNotEmpty) {
      // Find the document corresponding to the logged-in user
      final userDoc = members.docs.firstWhere(
        (doc) => doc.id == userId,
      );
      return userDoc['address'];
    }
    return 'N/A';
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

      final imageUrl = userDoc['imageurl'];

      // Return the image URL if available, otherwise an empty string
      return imageUrl.isNotEmpty ? imageUrl : '';
    }

    // Return an empty string if there are no documents
    return '';
  }
}
