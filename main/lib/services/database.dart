import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // Collection Reference
  final CollectionReference testCollection =
      FirebaseFirestore.instance.collection('testdata');

  final CollectionReference icalCollection =
      FirebaseFirestore.instance.collection('icalLinks');

  Future<void> updateUserData(
    String name,
    String phone,
    String email,
    String password,
    String imageurl,
  ) async {
    try {
      await testCollection.doc(uid).set({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'imageurl': imageurl,
      });
    } catch (error) {
      print('Error updating user data: $error');
      throw error;
    }
  }

  Future<void> updateUserimage(
    String imageurl,
  ) async {
    try {
      await testCollection.doc(uid).set({
        'imageurl': imageurl,
      });
    } catch (error) {
      print('Error updating user data: $error');
      throw error;
    }
  }

  Stream<QuerySnapshot> get members {
    return testCollection.snapshots();
  }

  Stream<QuerySnapshot> get ICALLINKS {
    return icalCollection.snapshots();
  }

  Future<void> deleteUserData() async {
    try {
      await testCollection.doc(uid).delete();
    } catch (error) {
      print('Error deleting user data: $error');
      throw error;
    }
  }

  Future<void> updateUserPhoneNumber(String newPhoneNumber) async {
    await FirebaseFirestore.instance.collection('testdata').doc(uid).update({
      'phone': newPhoneNumber,
    });
  }

  Future<void> updateUserPassword(String newpassword) async {
    await FirebaseFirestore.instance.collection('testdata').doc(uid).update({
      'password': newpassword,
    });
  }
}
