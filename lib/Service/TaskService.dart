import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proda/Controller/Task.dart';

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
}
