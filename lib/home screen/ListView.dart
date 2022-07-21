import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proda/Providers/SessionProvider.dart';
import 'package:proda/Themes.dart';
import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Models/Task.dart';
import 'package:proda/Providers/TaskProvider.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'dart:async';

class AddList_State extends StatelessWidget {
  var TaskCommand = TaskCommands();
  Function(String, bool, DocumentSnapshot, Map<dynamic, dynamic>) checkBox;
  Function setDate;
  Function setTime;
  Function(AsyncSnapshot<QuerySnapshot>, int, int) reorder;

  TextEditingController dateController;
  TextEditingController timeController;
  MaterialColor color;

  Stream<QuerySnapshot> taskQuery;
  var FirebaseCommand = FirebaseCommands();
  createEditDialog(
      BuildContext,
      context,
      String data,
      DocumentSnapshot document,
      String description,
      Map<dynamic, dynamic> mapData,
      TextEditingController dateController,
      TextEditingController timeController,
      int flag,
      String moveButton) {
    TextEditingController updateController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    updateController.text = mapData['Task']['displayName'];
    descriptionController.text = mapData['Task']['description'];
    dateController.text = mapData['Task']['date'];
    timeController.text = mapData['Task']['time'];
    return showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              timeController.clear();
              dateController.clear();
              Navigator.pop(context);

              return false;
            },
            child: AlertDialog(
                backgroundColor: Colors.cyan,
                title: Text("Details"),
                scrollable: true,
                content: Container(
                  height: 600,
                  width: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Task'),
                      Expanded(
                        child: TextField(
                          maxLines: 1,
                          controller: updateController,
                        ),
                      ),
                      Text('Description'),
                      Expanded(
                        child: TextField(
                          maxLines: 1,
                          controller: descriptionController,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          maxLines: 1,
                          readOnly: true,
                          decoration: InputDecoration(hintText: 'Date'),
                          controller: dateController,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setDate(context);
                        },
                        child: Text('Select Date'),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          maxLines: 1,
                          decoration: InputDecoration(hintText: 'Time'),
                          controller: timeController,
                        ),
                      ),
                      ElevatedButton(
                        child: Text('Select Time'),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        onPressed: () {
                          setTime(context);
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          String uid = auth.currentUser!.uid;
                          DateTime currentDate = DateTime.now();
                          Timestamp time = Timestamp.fromDate(currentDate);
                          String setTime;
                          if (dateController.text != '' &&
                              timeController.text != '') {
                            setTime = dateController.text +
                                '    ' +
                                timeController.text;
                          } else if (dateController.text != '') {
                            setTime = dateController.text;
                          } else
                            setTime = timeController.text;
                          Map<dynamic, dynamic> taskMap = {
                            "Name": updateController.text.trim(),
                            "Timestamp": time,
                            "ticked": false,
                            "setTime": setTime,
                            "displayName": updateController.text.trim(),
                            "difference": mapData['Task']['difference'],
                            "notification id": mapData['Task']
                                ['notification id'],
                            "description": descriptionController.text.trim(),
                            "date": dateController.text.trim(),
                            "time": timeController.text.trim(),
                          };

                          context
                              .read<TaskProvider>()
                              .moveTask(uid, taskMap, document, flag);
                          context
                              .read<SessionProvider>()
                              .updateSessionMove(uid, flag);
                          FirebaseCommand.UpdateMetaData(uid, flag, 'Subtract');
                          FirebaseCommand.UpdateMetaData(uid, flag - 1, 'Add');
                          dateController.clear();
                          timeController.clear();

                          Navigator.pop(context);
                        },
                        child: Text(moveButton),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String SetTime;
                          if (dateController.text != '' &&
                              timeController.text != '') {
                            SetTime = dateController.text +
                                '    ' +
                                timeController.text;
                          } else if (dateController.text != '') {
                            SetTime = dateController.text;
                          } else
                            SetTime = timeController.text;

                          Map<dynamic, dynamic> taskMap;
                          taskMap = {
                            "Name": updateController.text,
                            "displayName": updateController.text,
                            "description": descriptionController.text,
                            "time": timeController.text,
                            "date": dateController.text,
                            "setTime": SetTime
                          };

                          //update(update_controller.text,data);
                          context
                              .read<TaskProvider>()
                              .TaskUpdate(taskMap, document);

                          dateController.clear();
                          timeController.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Edit'),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  int flag;
  AddList_State({
    required this.taskQuery,
    required this.flag,
    required this.checkBox,
    required this.setDate,
    required this.setTime,
    required this.reorder,
    required this.dateController,
    required this.timeController,
    required this.color,
  });
  var ThemeStyle = ThemeStyles();
  List list1 = [''];
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: taskQuery,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ReorderableListView(
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) {
                reorder(snapshot, newIndex, oldIndex);
              },
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<dynamic, dynamic> data =
                    document.data() as Map<dynamic, dynamic>;
                print(document.data().toString() + 'today right now');
                return Dismissible(
                    key: Key('$data'),
                    onDismissed: (dismissDirection) async {
                      //ondismissed(data['Name']);

                      context
                          .read<SessionProvider>()
                          .sessionDataDeleteTask(auth.currentUser!.uid, flag);

                      await flutterLocalNotificationsPlugin
                          .cancel(data['Task']['notification id'].hashCode);
                      context.read<TaskProvider>().deleteTask(document);
                      context.read<TaskProvider>().updateMetaData(
                          auth.currentUser!.uid, flag, "Subtract");
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (flag == 0) {
                          if (data.containsValue(data['Task']['description']))
                            createEditDialog(
                                BuildContext,
                                context,
                                data['Task']['displayName'].toString(),
                                document,
                                data['Task']['description'],
                                data,
                                dateController,
                                timeController,
                                flag,
                                "Move task to Secondary");
                          else
                            createEditDialog(
                                BuildContext,
                                context,
                                data['Task']['displayName'].toString(),
                                document,
                                '',
                                data,
                                dateController,
                                timeController,
                                flag,
                                'Move task to Secondary');
                        } else {
                          if (data.containsValue(data['Task']['description']))
                            createEditDialog(
                                BuildContext,
                                context,
                                data['Task']['displayName'].toString(),
                                document,
                                data['Task']['description'],
                                data,
                                dateController,
                                timeController,
                                flag,
                                "Move task to Primary");
                          else
                            createEditDialog(
                                BuildContext,
                                context,
                                data['Task']['displayName'].toString(),
                                document,
                                '',
                                data,
                                dateController,
                                timeController,
                                flag,
                                'Move task to Primary');
                        }
                      },
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        flag == 0
                                            ? ThemeStyle
                                                .ListViewColorPrimaryFirst
                                            : ThemeStyle
                                                .ListViewColorSecondaryFirst,
                                        flag == 0
                                            ? ThemeStyle
                                                .ListViewColorPrimarySecond
                                            : ThemeStyle
                                                .ListViewColorSecondarySecond
                                      ])),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.task_rounded),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 13.00, horizontal: 18.0),
                                    title: Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data['Task']
                                                              ['displayName']
                                                          .toString(),
                                                      style: new TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 43, 42, 42)),
                                                    ),
                                                  ),
                                                  Transform.scale(
                                                    scale: 1.5,
                                                    child: Checkbox(
                                                        fillColor:
                                                            MaterialStateProperty
                                                                .all(Color
                                                                    .fromARGB(
                                                                        255,
                                                                        37,
                                                                        37,
                                                                        37)),
                                                        autofocus: true,
                                                        shape: CircleBorder(),
                                                        value: data['Task']
                                                            ['ticked'],
                                                        onChanged:
                                                            (bool? value) {
                                                          checkBox(
                                                              data['Task'][
                                                                  'displayName'],
                                                              value!,
                                                              document,
                                                              data);
                                                        }),
                                                  ),
                                                ]),
                                            if (data['Task'].containsValue(
                                                    data['Task']['setTime']) &&
                                                data['Task']['setTime'] !=
                                                    '    ' &&
                                                data['Task']['setTime'] !=
                                                    '  ' &&
                                                data['Task']['setTime'] != '')
                                              Text(
                                                data['Task']['setTime']
                                                    .toString(),
                                                style: TextStyle(
                                                    //fontSize: 18,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 43, 42, 42)),
                                              )
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.5,
                          )
                        ],
                      ),
                    ));
              }).toList(),
            );
          }),
    );
  }
}
