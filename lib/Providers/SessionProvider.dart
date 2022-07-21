import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Models/Session.dart';

class SessionProvider with ChangeNotifier {
  var sessionCommands = SessionCommand();

  var FirebaseCommand = FirebaseCommands();

  Future<void> updateSessionAdd(String uid, int flag, String task) async {
    if (task != '') {
      DocumentReference MetaData = FirebaseCommand.GetMetaData(uid);
      var documentdata = await sessionCommands.getSessionTimeReference(uid);
      var documentuser;
      if (documentdata.data() != null)
        documentuser = documentdata.data() as Map;
      if (documentuser != null &&
          documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now())) >
              0) {
        if (flag == 0) {
          MetaData.set(
              {"Primary": FieldValue.increment(1)}, SetOptions(merge: true));

          if (documentuser != null &&
              documentuser['time']
                      .compareTo(Timestamp.fromDate(DateTime.now())) >
                  0) {
            sessionCommands.updatePrimarySessionAdd(uid);
          }
        } else {
          MetaData.set(
              {"Secondary": FieldValue.increment(1)}, SetOptions(merge: true));
          if (documentuser != null &&
              documentuser['time']
                      .compareTo(Timestamp.fromDate(DateTime.now())) >
                  0) {
            sessionCommands.updateSecondarySessionAdd(uid);
          }
        }
      }
    }
  }

  Future<void> updateSessionComplete(
      String documnent,
      bool? value,
      DocumentSnapshot documentSnapshot,
      String uid,
      int change_state,
      Map<dynamic, dynamic> data) async {
    var FirebaseCommand = FirebaseCommands();
    var sessionCommand = SessionCommand();

    DateTime currentDate = DateTime.now();
    Timestamp time = Timestamp.fromDate(currentDate);
    CollectionReference completed_quadrant1 =
        sessionCommand.getPrimaryCompleted(uid);
    CollectionReference completed_quadrant2 =
        sessionCommand.getSecondaryCompleted(uid);
    var documentdata = await sessionCommand.getSessionTimeReference(uid);
    var documentuser;
    if (documentdata.data() != null) documentuser = documentdata.data() as Map;
    FirebaseCommand.UpdateMetaData(uid, change_state, "Subtract");
    sessionCommand.updateSessionTick(documentSnapshot, value);
    if (change_state == 0) {
      if (documentuser != null &&
          documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now())) >
              0) {
        sessionCommand.updatePrmarySessionCompleteTask(uid);
        sessionCommand.updateCompletedTask(
            completed_quadrant1, documnent, time);
        sessionCommand.updatePrimaryAverageSessionCompleteTask(uid);
      }
    } else {
      if (documentuser != null &&
          documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now())) >
              0) {
        sessionCommand.updateSecondarySession(uid);
        sessionCommand.updateCompletedTask(
            completed_quadrant2, documnent, time);
        sessionCommand.updateSecondaryAverageSessionCompleteTask(uid);
      }
    }
  }

  void setSession(String uid) async {
    var today = new DateTime.now();
    var addwithtoday = new DateTime.now();

    addwithtoday = today.add(new Duration(days: 7));
    DateTime currentdate = DateTime.now();
    addwithtoday = currentdate.add(new Duration(days: 7));
    Timestamp time = Timestamp.fromDate(addwithtoday);

    sessionCommands.setNewSession(uid, time);
    Fluttertoast.showToast(
        msg: "New Session Added", backgroundColor: Colors.blue);
  }

  Stream<QuerySnapshot> getAverageSessionStream(String uid) {
    return sessionCommands.getAverageSessionSnapshot(uid);
  }

  void updateSessionMove(String uid, int flag) {
    sessionCommands.updateSessionMove(uid, flag);
  }

  CollectionReference getSessionData(String uid) {
    return sessionCommands.getSessionData(uid);
  }

  CollectionReference getAverageSessionData(String uid) {
    return sessionCommands.getAverageSessionData(uid);
  }

  DocumentReference getPrimarySession(String uid) {
    return sessionCommands.getPrimarySession(uid);
  }

  DocumentReference getSecondarySession(String uid) {
    return sessionCommands.getSecondarySession(uid);
  }

  DocumentReference getPrimaryAverageSession(String uid) {
    return sessionCommands.getPrimaryAverageSession(uid);
  }

  DocumentReference getSecondaryAverageSession(String uid) {
    return sessionCommands.getSecondaryAverageSession(uid);
  }

  DocumentReference getSessionTime(String uid) {
    return sessionCommands.getSessionTime(uid);
  }

  void sessionDataDeleteTask(String uid, int flag) async {
    var documentdata = await sessionCommands.getSessionTime(uid).get();
    var documentuser;
    if (documentdata.data() != null) documentuser = documentdata.data() as Map;
    if (flag == 0 &&
        documentuser != null &&
        documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now())) >
            0) {
      sessionCommands.getPrimarySession(uid).update({
        "Name": FieldValue.increment(1),
      });
      sessionCommands.getPrimaryAverageSession(uid).update({
        "Name": FieldValue.increment(1),
      });
    } else if (flag == 1 &&
        documentuser != null &&
        documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now())) >
            0) {
      sessionCommands.getSecondarySession(uid).update({
        "Name": FieldValue.increment(1),
        "color": '0xFFa531e8',
      });
      sessionCommands.getSecondaryAverageSession(uid).update({
        "Name": FieldValue.increment(1),
      });
    }
  }
}
