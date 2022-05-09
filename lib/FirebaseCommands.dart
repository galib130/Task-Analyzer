import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCommands {
  final firebaseinstance = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  DocumentReference getQuadrant1_Session(String uid) {
    DocumentReference collectquadrant1_session = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("session")
        .doc('Quadrant1');
    return collectquadrant1_session;
  }

  DocumentReference getQuadrant2_Session(String uid) {
    DocumentReference collectQuadrant2_session = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("session")
        .doc('Quadrant2');
    return collectQuadrant2_session;
  }

  void UpdateSession(DocumentReference reference, int value) {
    reference.update({
      "Name": FieldValue.increment(value),
    });
  }
}
