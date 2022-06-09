import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Models/Session.dart';
import 'package:proda/Models/Task.dart';

class TaskProvider with ChangeNotifier {
  Map<dynamic, dynamic>? taskMap;
  String? SetTime;
  Timestamp? time;
  var SessionCommands = SessionCommand();
  var taskCommand = TaskCommands();
  var FirebaseCommand = FirebaseCommands();
  DocumentReference? selectedSession;
  DocumentReference? selectedAvgSesion;

  int date_picked = 1;
  int date_difference = 0;
  Future<void> postTasks(
      String? task,
      String uid,
      TextEditingController taskcontroller,
      TextEditingController descriptioncontroller,
      TextEditingController datecontroller,
      TextEditingController timecontroller,
      TextEditingController secondcontroller,
      int time_difference,
      int date_difference,
      int flag) async {
    if (task != '') {
      DocumentReference MetaData = FirebaseCommand.GetMetaData(uid);
      time = Timestamp.fromDate(DateTime.now());
      taskCommand.setTaskCollection(tabStatus.Primary, uid);
      /*implement session logic for add and set up task logic for adding task*/

      if (datecontroller.text != '' && timecontroller.text != '') {
        SetTime = datecontroller.text + '    ' + timecontroller.text;
      } else if (datecontroller.text != '') {
        SetTime = datecontroller.text;
      } else
        SetTime = timecontroller.text;

      taskMap = {
        "Name": task,
        "Timestamp": time,
        "difference": time_difference + date_difference,
        "ticked": false,
        "setTime": SetTime,
        "displayName": taskcontroller.text,
        "notification id": datecontroller.text.trim() +
            timecontroller.text.trim() +
            secondcontroller.text.trim(),
        "description": descriptioncontroller.text.trim(),
        "date": datecontroller.text.trim(),
        "time": timecontroller.text.trim(),
      };
      taskCommand.setTask(taskMap!, flag, uid);
      var documentdata = await SessionCommands.getSessionTimeReference(uid);
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
            SessionCommands.updatePrimarySessionAdd(uid);
          }
        } else {
          MetaData.set(
              {"Secondary": FieldValue.increment(1)}, SetOptions(merge: true));
          if (documentuser != null &&
              documentuser['time']
                      .compareTo(Timestamp.fromDate(DateTime.now())) >
                  0) {
            SessionCommands.updatePrimarySessionAdd(uid);
          }
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter a non empty task", backgroundColor: Colors.blue);
    }
  }

  Future<Null> selectDate(
      BuildContext context,
      TextEditingController datecontroller,
      TextEditingController secondcontroller,
      String uid) async {
    DateTime currentDate = DateTime.now();
    DateTime totalDate = DateTime.now().subtract(Duration(seconds: 2));

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 4)),
        lastDate: DateTime(2029));
    if (pickedDate != null && pickedDate != currentDate)
      currentDate = pickedDate;
    datecontroller.clear();
    datecontroller.text = DateFormat('EEEE, d MMM, yyyy').format(currentDate);

    secondcontroller.text = DateTime.now().second.toString() +
        DateTime.now().hour.toString() +
        DateTime.now().minute.toString() +
        DateTime.now().millisecond.toString() +
        TimeOfDay.now().period.toString();
    DateTime datenow = DateTime.now();
    date_picked = 0;

    date_difference = 0;
    if (currentDate.day != DateTime.now().day) {
      date_difference = currentDate.difference(datenow).inSeconds;

      taskCommand.setTaskDate(uid, currentDate.day - datenow.day);

      totalDate = totalDate.add(Duration(seconds: date_difference as int));
    } else {
      taskCommand.setTaskDate(uid, 0);
    }
    print(date_difference.toString() + 'date difference');
    currentDate = DateTime.now().subtract(Duration(days: 3));
  }
}
