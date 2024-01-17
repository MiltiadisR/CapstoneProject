import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main/services/database.dart';
import '../models/user.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StreamController<CustomUser?> _userController =
      StreamController<CustomUser?>();

  Stream<CustomUser?> get userStream => _userController.stream;

  CustomUser? _userFromFirebaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  String getCurrentUserId() {
    User? user = _auth.currentUser;
    return user?.uid ?? '';
  }

  // Sign in anonymously
  Future<CustomUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      String name, String phone, String imageurl) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user!;

      // Create a new document for the  user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData(name, phone, email, password, imageurl)
          .whenComplete(
            () => Get.snackbar('Success', 'Your account has been created',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green),
          );
      return _userFromFirebaseUser(user);
      // ignore: unused_catch_stack
    } catch (error, StackTrace) {
      Get.snackbar('Error', 'Something went wrong. Try again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.red);
      print(
        error.toString(),
      );
    }
  }

  //Update Password
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Reauthenticate the user with their current password
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: oldPassword,
        );

        await currentUser.reauthenticateWithCredential(credential);

        // Update the password
        await currentUser.updatePassword(newPassword);
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
    _userController.add(null);
  }

  // Initialize the stream in the constructor
  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      CustomUser? customUser = _userFromFirebaseUser(user);
      _userController.add(customUser);
    });
  }

  Future<List<String>> getIcalLinks() async {
    try {
      String userId = getCurrentUserId();
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('icalLinks')
          .doc(userId)
          .get();

      if (document.exists) {
        final data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          final icalLinksRaw = data['icalLinks'];

          if (icalLinksRaw is List<dynamic>) {
            List<String> icalLinks =
                List<String>.from(icalLinksRaw.cast<String>());
            return icalLinks;
          }
        }
      }

      return [];
    } catch (error) {
      print('Error getting iCal links: $error');
      return [];
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Delete user document in Firestore
        await DatabaseService(uid: currentUser.uid).deleteUserData();

        // Delete user account
        await currentUser.delete();

        // Sign out the user
        await _auth.signOut();

        // Inform listeners about the user being null (signed out)
        _userController.add(null);
      }
    } catch (error) {
      print('Error deleting account: $error');
      throw error;
    }
  }

  // Dispose of the stream controller when done
  void dispose() {
    _userController.close();
  }
}
