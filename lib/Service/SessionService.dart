import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SessionService {
  Future<DocumentSnapshot> getSessionTimeReference(String uid) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("session_time")
        .doc("time")
        .get();
  }

  DocumentReference getSessionTime(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("session_time")
        .doc("time");
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

  CollectionReference getPrimaryCompleted(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Quadrant1_Complete');
  }

  CollectionReference getSecondaryCompleted(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Quadrant2_Complete');
  }

  void updateCompletedTask(
      CollectionReference collection, String documnent, Timestamp time) {
    collection
        .doc(documnent)
        .set({"Name": documnent, "Timestamp": time, "ticked": false});
  }

  void setSessionTime(DocumentReference documentReference, Timestamp time) {
    documentReference.set({"time": time});
  }

  void setPrimarySession(DocumentReference documentReference, Timestamp time) {
    documentReference.set({
      "Name": 0,
      "color": '0xFF34c9eb',
      "xaxis": 'Primary',
      "time": DateFormat('EEEE, d MMM, yyyy  h:mm a').format(time.toDate()),
    });
  }

  void setSecondarySession(
      DocumentReference documentReference, Timestamp time) {
    documentReference.set({
      "Name": 0,
      "color": '0xFFa531e8',
      "xaxis": 'Secondary',
      "time": DateFormat('EEEE, d MMM, yyyy  h:mm a').format(time.toDate()),
    });
  }

  void setPrimaryAvgSession(DocumentReference documentReference) {
    documentReference.set({
      "Name": FieldValue.increment(0),
      "color": '0xFFa531e8',
      "xaxis": 'Primary',
      "session": FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  void setSecondaryAvgSession(DocumentReference documentReference) {
    documentReference.set({
      "Name": FieldValue.increment(0),
      "color": '0xFF34c9eb',
      "xaxis": 'Secondary',
      "session": FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getAverageSessionSnapshot(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("average_session")
        .snapshots();
  }
}
