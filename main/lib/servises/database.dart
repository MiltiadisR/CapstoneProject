import 'package:cloud_firestore/cloud_firestore.dart';

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
    await testCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'imageurl': imageurl
    });
  }

  Stream<QuerySnapshot> get members {
    return testCollection.snapshots();
  }
}
