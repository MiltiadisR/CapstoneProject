import 'package:cloud_firestore/cloud_firestore.dart';

class IcalLinksService {
  final CollectionReference _icalLinksCollection =
      FirebaseFirestore.instance.collection('icalLinks');

  Future<List<String>> getSavedIcalLinks(String userId) async {
    DocumentSnapshot snapshot = await _icalLinksCollection.doc(userId).get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?; // Handle null
      if (data != null) {
        List<String> icalLinks = List<String>.from(data['icalLinks'] ?? []);
        return icalLinks;
      }
    }

    return [];
  }

  Future<void> saveIcalLink(String userId, String icalLink) async {
    // Check if the document exists
    bool documentExists =
        await _icalLinksCollection.doc(userId).get().then((doc) => doc.exists);

    if (!documentExists) {
      // If the document doesn't exist, create a new one
      await _icalLinksCollection.doc(userId).set({'icalLinks': []});
    }

    // Update the document with the new iCal link
    await _icalLinksCollection.doc(userId).update({
      'icalLinks': FieldValue.arrayUnion([icalLink])
    }).catchError((error) {
      print('Failed to add iCal link: $error');
    });
  }

  Future<void> deleteIcalLink(String userId, String linkToDelete) async {
    // Delete the specified iCal link from Firestore
    await _icalLinksCollection.doc(userId).update({
      'icalLinks': FieldValue.arrayRemove([linkToDelete])
    }).catchError((error) {
      print('Failed to delete iCal link: $error');
    });
  }
}
