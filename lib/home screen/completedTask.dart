import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class TaskLoad {
  String? task;
  Timestamp? time;
  String? difference;
  String? SetTime;
  String? DisplayName;
  String? NotificationId;
  String? Description;
  String? Date;
  String? Time;
  String? CompletionTime;
  Map<dynamic, dynamic>? TaskLoadMap;
  TaskLoad SetTask(Map<dynamic, dynamic> data) {
    TaskLoadMap = data['Task'];

    return this;
  }

  Map<dynamic, dynamic>? getTaskLoadMap() {
    return TaskLoadMap;
  }
}
