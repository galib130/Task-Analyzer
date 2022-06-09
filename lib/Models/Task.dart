import 'package:cloud_firestore/cloud_firestore.dart';
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

  void checkbox(
      String documnent,
      bool? value,
      DocumentSnapshot documentSnapshot,
      String uid,
      int change_state,
      Map<dynamic, dynamic> data) async {
    var taskload = TaskLoad();
    var FirebaseCommand = FirebaseCommands();
    CollectionReference completed_quadrant1 =
        taskService.getPrimaryCompleted(uid);
    CollectionReference completed_quadrant2 =
        taskService.getSecondaryCompleted(uid);
    DateTime currentDate = DateTime.now();
    Timestamp time = Timestamp.fromDate(currentDate);
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
        taskService.updateCompletedTask(completed_quadrant1, documnent, time);
        sessionCommand.updatePrimaryAverageSessionCompleteTask(uid);
      }
    } else {
      if (documentuser != null &&
          documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now())) >
              0) {
        sessionCommand.updateSecondarySession(uid);
        taskService.updateCompletedTask(completed_quadrant2, documnent, time);
        sessionCommand.updateSecondaryAverageSessionCompleteTask(uid);
      }
    }

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
}
