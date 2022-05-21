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
    tabCollection!.doc().set(
        {"Task": taskData, "Timestamp": taskData['Timestamp']},
        SetOptions(merge: true));
  }

  Future<void> updateTask(
      Map<dynamic, dynamic> taskData, DocumentSnapshot document) async {
    document.reference.update({
      "Task.Name": taskData["Name"],
      "Task.displayName": taskData["displayName"],
      "Task.description": taskData['description'],
      "Task.time": taskData["time"],
      "Task.date": taskData["date"],
      "Task.setTime": taskData["setTime"]
    });
  }

  Future<void> deleteTask(DocumentSnapshot document) async {
    document.reference.delete();
  }
}
