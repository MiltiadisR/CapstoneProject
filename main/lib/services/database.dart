import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/services/auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // Collection Reference
  final CollectionReference testCollection =
      FirebaseFirestore.instance.collection('testdata');

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

  Future<void> deleteUserData() async {
    try {
      await testCollection.doc(uid).delete();
    } catch (error) {
      print('Error deleting user data: $error');
      throw error;
    }
  }
}
