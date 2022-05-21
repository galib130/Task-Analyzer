import 'package:cloud_firestore/cloud_firestore.dart';

enum tabStatus { Primary, Secondary }

class TaskCommands {
  CollectionReference? tabCollection;

  void setTaskCollection(tabStatus status, String uid) {
    if (status == tabStatus.Primary) {
      tabCollection = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Mytask');
    } else {
      tabCollection = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Quadrant2');
    }
  }

  Future<void> setTask(Map<dynamic, dynamic> taskData) async {
    tabCollection!.doc().set({
      "Name": taskData["Name"],
      "Timestamp": taskData["Timestamp"],
      "difference": taskData['difference'],
      "ticked": false,
      "setTime": taskData['setTime'],
      "displayName": taskData['displayName'],
      "notification id": taskData['notification id'],
      "description": taskData['description'],
      "date": taskData['date'],
      "time": taskData['time'],
    }, SetOptions(merge: true));
  }
}
