import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Models/Task.dart';
import 'package:proda/notification/notification.dart';

class TaskProvider with ChangeNotifier {
  Map<dynamic, dynamic>? taskMap;
  String? SetTime;
  Timestamp? time;
  DateTime totalDate = DateTime.now().subtract(Duration(seconds: 2));
  var taskCommand = TaskCommands();
  var FirebaseCommand = FirebaseCommands();
  int difference = 0;

  int date_picked = 1;
  int date_difference = 0;
  int time_difference = 0;

  int getDateDifference() {
    return date_difference;
  }

  int getTimeDifference() {
    return time_difference;
  }

  void setDateDifference(int value) {
    date_difference = value;
  }

  Future<void> postTasks(
      String? task,
      String uid,
      TextEditingController taskcontroller,
      TextEditingController descriptioncontroller,
      TextEditingController datecontroller,
      TextEditingController timecontroller,
      TextEditingController secondcontroller,
      int flag) async {
    if (task != '') {
      print("ADD  HERE");
      Timestamp time = Timestamp.fromDate(DateTime.now());
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

      totalDate = totalDate.add(Duration(seconds: date_difference));
    } else {
      taskCommand.setTaskDate(uid, 0);
    }
    print(date_difference.toString() + 'date difference');
    currentDate = DateTime.now().subtract(Duration(days: 3));
  }

  void TaskComplete(bool? value, DocumentSnapshot documentSnapshot, String uid,
      Map<dynamic, dynamic> data) {
    taskCommand.checkbox(value, documentSnapshot, uid, data);
  }

  void TaskUpdate(Map<dynamic, dynamic> taskMap, DocumentSnapshot document) {
    taskCommand.updateTask(taskMap, document);
  }

  Future<Null> selectTime(
      BuildContext context,
      TextEditingController timecontroller,
      TextEditingController secondcontroller,
      String uid) async {
    var temp = TimeOfDay.now();
    TimeOfDay time = TimeOfDay.now();
    int time_picked = 0;
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: temp);
    if (pickedTime != null && pickedTime != time) time = pickedTime;
    int datenow = TimeOfDay.now().hour * 3600 + TimeOfDay.now().minute * 60;

    timecontroller.clear();
    if (time.period.toString() == 'DayPeriod.am')
      timecontroller.text =
          time.hour.toString() + ':' + time.minute.toString() + 'am';
    if (time.period.toString() == 'DayPeriod.pm')
      timecontroller.text =
          time.hour.toString() + ':' + time.minute.toString() + 'pm';
    time_difference = 0;

    time_picked = 0;
    // time_difference= difference;

    time_difference = (time.minute * 60 + time.hour * 3600) - datenow;
    secondcontroller.text = DateTime.now().second.toString() +
        DateTime.now().hour.toString() +
        DateTime.now().minute.toString() +
        DateTime.now().millisecond.toString() +
        TimeOfDay.now().period.toString();
    taskCommand.setTaskTime(uid, time, datenow);
    totalDate = totalDate.add(Duration(seconds: time_difference));
    //print(difference.toString() + "time");
    print(time_difference.toString() + 'time difference');

    time = time.replacing(hour: time.hour, minute: time.minute - 2);
  }

  Future<void> setNotification(String datecontroller, String timecontroller,
      String secondcontroller, String taskcontroller, String uid) async {
    DateTime compareDate = DateTime.now();

    var get_datetime_data = await taskCommand.getDateTime(uid).get();

    var datetime_data;
    if (get_datetime_data.data() != null)
      datetime_data = get_datetime_data.data() as Map;

    print(uid + " uid");

    difference = date_difference + time_difference;

    NotificationApi.showScheduledNotification(
        id: (datecontroller.trim() +
                timecontroller.trim() +
                secondcontroller.trim())
            .hashCode,
        title: taskcontroller,
        body: 'Hey you added this task',
        scheduledDate: DateTime.now().add(Duration(
            seconds: (datetime_data['date difference'] * 24 * 3600 +
                datetime_data['time difference']))));

    totalDate = compareDate;
    date_difference = 0;
    time_difference = 0;
    difference = 0;
    taskCommand.resetDateTime(uid);
  }

  //void resetDateTime(String uid) {}

  void moveTask(String uid, Map<dynamic, dynamic> taskMap,
      DocumentSnapshot document, int value) {
    taskCommand.setTask(taskMap, value - 1, uid);
    taskCommand.deleteTask(document);
  }
}
