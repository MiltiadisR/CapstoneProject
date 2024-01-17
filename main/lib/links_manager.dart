import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/services/auth.dart';

class LinksManager {
  final CollectionReference _icalLinksCollection =
      FirebaseFirestore.instance.collection('icalLinks');

  Future<List<String>> getSavedIcalLinks() async {
    String userId = AuthService().getCurrentUserId();

    // Check if the document exists
    bool documentExists =
        await _icalLinksCollection.doc(userId).get().then((doc) => doc.exists);

    if (documentExists) {
      DocumentSnapshot snapshot = await _icalLinksCollection.doc(userId).get();

      // Use the `data()` method with a specified type (Map<String, dynamic>)
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('icalLinks')) {
        List<String> icalLinks = List<String>.from(data['icalLinks'] ?? []);
        return icalLinks;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
