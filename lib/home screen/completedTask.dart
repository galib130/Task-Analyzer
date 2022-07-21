import 'package:cloud_firestore/cloud_firestore.dart';

class TaskLoad {
  String? task;
  Timestamp? time;
  String? difference;
  String? setTime;
  String? displayName;
  String? notificationId;
  String? description;
  String? date;
  String? timeLine;
  String? completionTime;
  Map<dynamic, dynamic>? taskLoadMap;
  TaskLoad setTask(Map<dynamic, dynamic> data) {
    taskLoadMap = data['Task'];

    return this;
  }

  Map<dynamic, dynamic>? getTaskLoadMap() {
    return taskLoadMap;
  }
}
