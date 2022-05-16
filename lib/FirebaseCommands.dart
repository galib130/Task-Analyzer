import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proda/home%20screen/Task.dart';

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

  DocumentReference getQuadrant1_Average_Session(String uid) {
    DocumentReference collectquadrant1_session = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("average_session")
        .doc('Quadrant1');
    return collectquadrant1_session;
  }

  DocumentReference getQuadrant2_Average_Session(String uid) {
    DocumentReference collectquadrant1_session = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("average_session")
        .doc('Quadrant2');
    return collectquadrant1_session;
  }

  void UpdateSession(DocumentReference reference, int value) {
    reference.update({
      "Name": FieldValue.increment(value),
    });
  }

  void UpdateAverageSession(DocumentReference reference, int value) {
    reference.update({
      "Name": FieldValue.increment(value),
    });
  }

  CollectionReference GetCompletedList(String uid) {
    CollectionReference Completed = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("Completed");

    return Completed;
  }

  void UpdateCompleted(String uid, TaskLoad task) async {
    DocumentReference Completed = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("Completed")
        .doc();
    Completed.set({
      "Name": task.TaskLoadMap,
      "Timestamp": task.TaskLoadMap!['Timestamp']
    });
  }

  Stream<QuerySnapshot> GetCompletedListStream(String uid) {
    CollectionReference Completed = GetCompletedList(uid);

    return Completed.orderBy("Timestamp", descending: true).snapshots();
  }

  DocumentReference GetMetaData(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("MetaData")
        .doc("MetaData");
  }

  void UpdateMetaData(String uid, int flag, String status) {
    DocumentReference MetaData = GetMetaData(uid);
    int value;
    String mode;
    if (flag == 0)
      mode = "Primary";
    else
      mode = "Secondary";
    if (status == "Add")
      value = 1;
    else
      value = -1;

    MetaData.set({mode: FieldValue.increment(value)}, SetOptions(merge: true));
  }
}
