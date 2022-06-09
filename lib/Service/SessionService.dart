import 'package:cloud_firestore/cloud_firestore.dart';

class SessionService {
  Future<DocumentSnapshot> getSessionTimeReference(String uid) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("session_time")
        .doc("time")
        .get();
  }

  void updateSessionTick(DocumentSnapshot documentSnapshot, bool? value) {
    documentSnapshot.reference.update({"ticked": value});
  }

  DocumentReference getSecondarySession(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("session")
        .doc('Quadrant2');
  }

  void updateSessionValueComplete(DocumentReference document) {
    document.update({"Name": FieldValue.increment(3)});
  }

  void updateSessionValueAdd(DocumentReference document) {
    document.update({
      "Name": FieldValue.increment(-1),
    });
  }

  DocumentReference getPrimarySession(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("session")
        .doc('Quadrant1');
  }

  DocumentReference getPrimaryAverageSession(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("average_session")
        .doc('Quadrant1');
  }

  DocumentReference getSecondaryAverageSession(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("average_session")
        .doc('Quadrant2');
  }
}
