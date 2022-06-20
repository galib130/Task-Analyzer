import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Models/Session.dart';
import 'package:proda/Service/TaskService.dart';
import 'package:proda/home%20screen/completedTask.dart';

enum tabStatus { Primary, Secondary }

class TaskCommands {
  var taskService = TaskService();
  var sessionCommand = SessionCommand();
  CollectionReference? tabCollection;
  CollectionReference? completedTaskCollection;
  void setTaskCollection(tabStatus status, String uid) {
    tabCollection = taskService.setTaskCollection(status, uid);
  }

  Future<void> setTask(
      Map<dynamic, dynamic> taskData, int flag, String uid) async {
    if (flag == 0)
      tabCollection = taskService.setTaskCollection(tabStatus.Primary, uid);
    else
      tabCollection = taskService.setTaskCollection(tabStatus.Secondary, uid);
    taskService.setTask(taskData, tabCollection!);
  }

  Future<void> updateTask(
      Map<dynamic, dynamic> taskData, DocumentSnapshot document) async {
    taskService.updateTask(taskData, document);
  }

  Future<void> deleteTask(DocumentSnapshot document) async {
    taskService.deleteTask(document);
  }

  //get primary completed list for suggestion
  CollectionReference getPrimaryCompleted(String uid) {
    return taskService.getPrimaryCompleted(uid);
  }

  //get secondary completed list for suggestion
  CollectionReference getSecondaryCompleted(String uid) {
    return taskService.getSecondaryCompleted(uid);
  }

  void checkbox(bool? value, DocumentSnapshot documentSnapshot, String uid,
      Map<dynamic, dynamic> data) async {
    var taskload = TaskLoad();
    var FirebaseCommand = FirebaseCommands();
    var CompletedTask;

    CompletedTask = taskload.SetTask(data);

    FirebaseCommand.UpdateCompleted(uid, CompletedTask);

    Future.delayed(const Duration(milliseconds: 300), () {
      taskService.deleteTask(documentSnapshot);
    });
  }

  void setTaskDate(String uid, int value) {
    taskService.setDate(uid, value);
  }

  void setTaskTime(String uid, TimeOfDay time, int datenow) {
    taskService.setTime(uid, time, datenow);
  }

  DocumentReference getDateTime(String uid) {
    print("i AM TASK");
    return taskService.getDateTime(uid);
  }

  void resetDateTime(String uid) {
    taskService.resetDateTime(uid);
  }
}
