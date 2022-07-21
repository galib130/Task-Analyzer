import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proda/Models/Task.dart';

class TaskService {
  void updateTask(Map<dynamic, dynamic> taskData, DocumentSnapshot document) {
    document.reference.update({
      "Task.Name": taskData["Name"],
      "Task.displayName": taskData["displayName"],
      "Task.description": taskData['description'],
      "Task.time": taskData["time"],
      "Task.date": taskData["date"],
      "Task.setTime": taskData["setTime"]
    });
  }

  void updateCompletedTask(
      CollectionReference collection, String documnent, Timestamp time) {
    collection
        .doc(documnent)
        .set({"Name": documnent, "Timestamp": time, "ticked": false});
  }

  void deleteTask(DocumentSnapshot document) {
    document.reference.delete();
  }

  CollectionReference setTaskCollection(tabStatus status, String uid) {
    if (status == tabStatus.Primary) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Mytask');
    } else {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Quadrant2');
    }
  }

  void setTask(
      Map<dynamic, dynamic> taskData, CollectionReference tabCollection) {
    tabCollection.doc().set(
        {"Task": taskData, "Timestamp": taskData['Timestamp']},
        SetOptions(merge: true));
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

  void setDate(String uid, int value) {
    DocumentReference setDateReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('date and time ')
        .doc('date and time set');

    setDateReference.set({
      "date difference": value,
    }, SetOptions(merge: true));
  }

  setTime(String uid, TimeOfDay time, int datenow) {
    DocumentReference setTimeReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('date and time ')
        .doc('date and time set');
    setTimeReference.set({
      "time difference": (time.minute * 60 + time.hour * 3600) - datenow,
    }, SetOptions(merge: true));
  }

  DocumentReference getDateTime(String uid) {
    print("I am service");
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('date and time ')
        .doc('date and time set');
  }

  void resetDateTime(String uid) {
    DocumentReference dateTime = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('date and time ')
        .doc('date and time set');
    dateTime.set({
      "date difference": 0,
      "time difference": 0,
    });
  }

  Stream<QuerySnapshot> getListviewStream(int flag, String uid) {
    if (flag == 0)
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Mytask')
          .orderBy('Timestamp')
          .snapshots(includeMetadataChanges: true);
    else
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Quadrant2')
          .orderBy('Timestamp')
          .snapshots(includeMetadataChanges: true);
  }

  CollectionReference suggestionList(int flag, String uid) {
    if (flag == 0)
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Quadrant1_Complete');
    else
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Quadrant2_Complete');
  }

  Stream<QuerySnapshot> getCompletedListStream(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("Completed")
        .orderBy("Timestamp", descending: true)
        .snapshots();
  }

  CollectionReference getTabMetaData(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("MetaData");
  }

  DocumentReference getMetaData(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("MetaData")
        .doc("MetaData");
  }

  void setMetaData(
      DocumentReference documentReference, int value, String mode) {
    documentReference
        .set({mode: FieldValue.increment(value)}, SetOptions(merge: true));
  }
}
