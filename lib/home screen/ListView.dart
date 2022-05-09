import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proda/Themes.dart';
import 'package:proda/FirebaseCommands.dart';

import '../main.dart';
import 'dart:async';

class AddList_State extends StatelessWidget {
  bool _value = false;

  Function(String, bool, DocumentSnapshot) checkBox;
  Function setDate;
  Function setTime;
  Function(AsyncSnapshot<QuerySnapshot>, int, int) reorder;

  TextEditingController dateController;
  TextEditingController timeController;
  MaterialColor color;

  Stream<QuerySnapshot> taskQuery;
  var FirebaseCommand = FirebaseCommands();
  createAlertDialog(
      BuildContext,
      context,
      String data,
      DocumentSnapshot document,
      String description,
      Map<dynamic, dynamic> map_data,
      TextEditingController date_controller,
      TextEditingController time_controller,
      int flag,
      String moveButton) {
    TextEditingController update_controller = TextEditingController();
    TextEditingController description_controller = TextEditingController();
    update_controller.text = data;
    description_controller.text = description;
    date_controller.text = map_data['date'];
    time_controller.text = map_data['time'];

    return showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              time_controller.clear();
              date_controller.clear();
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
                          controller: update_controller,
                        ),
                      ),
                      Text('Description'),
                      Expanded(
                        child: TextField(
                          maxLines: 1,
                          controller: description_controller,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          maxLines: 1,
                          readOnly: true,
                          decoration: InputDecoration(hintText: 'Date'),
                          controller: date_controller,
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
                          controller: time_controller,
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
                          CollectionReference moveQuadrant;
                          DocumentReference PrimarySessionReference =
                              FirebaseCommand.getQuadrant1_Session(uid);
                          DocumentReference SecondarySessionReference =
                              FirebaseCommand.getQuadrant2_Session(uid);
                          if (flag == 0)
                            moveQuadrant = FirebaseFirestore.instance
                                .collection('Users')
                                .doc(uid)
                                .collection('Quadrant2');
                          else
                            moveQuadrant = FirebaseFirestore.instance
                                .collection('Users')
                                .doc(uid)
                                .collection('Mytask');

                          DateTime currentDate = DateTime.now();
                          Timestamp time = Timestamp.fromDate(currentDate);
                          String SetTime;
                          if (date_controller.text != '' &&
                              time_controller.text != '') {
                            SetTime = date_controller.text +
                                '    ' +
                                time_controller.text;
                          } else if (date_controller.text != '') {
                            SetTime = date_controller.text;
                          } else
                            SetTime = time_controller.text;

                          moveQuadrant.doc().set({
                            "Name": update_controller.text.trim(),
                            "Timestamp": time,
                            "ticked": false,
                            "setTime": SetTime,
                            "displayName": update_controller.text.trim(),
                            "difference": map_data['difference'],
                            "notification id": map_data['notification id'],
                            "description": description_controller.text.trim(),
                            "date": date_controller.text.trim(),
                            "time": time_controller.text.trim(),
                          });
                          if (flag == 0) {
                            FirebaseCommand.UpdateSession(
                                PrimarySessionReference, 1);
                            FirebaseCommand.UpdateSession(
                                SecondarySessionReference, -1);
                          } else if (flag != 0) {
                            FirebaseCommand.UpdateSession(
                                PrimarySessionReference, -1);
                            FirebaseCommand.UpdateSession(
                                SecondarySessionReference, 1);
                          }
                          document.reference.delete();
                          date_controller.clear();
                          time_controller.clear();
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
                          if (date_controller.text != '' &&
                              time_controller.text != '') {
                            SetTime = date_controller.text +
                                '    ' +
                                time_controller.text;
                          } else if (date_controller.text != '') {
                            SetTime = date_controller.text;
                          } else
                            SetTime = time_controller.text;

                          //update(update_controller.text,data);
                          document.reference.update({
                            "Name": update_controller.text,
                            "displayName": update_controller.text,
                            "description": description_controller.text,
                            "time": time_controller.text,
                            "date": date_controller.text,
                            "setTime": SetTime
                          });
                          date_controller.clear();
                          time_controller.clear();
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
    DocumentReference collectQuadrant2 = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection("session")
        .doc('Quadrant2');
    DocumentReference collectQuadrant1 = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection("session")
        .doc('Quadrant1');
    DocumentReference avg_q1_document = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection("average_session")
        .doc('Quadrant1');
    DocumentReference avg_q2_document = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection("average_session")
        .doc('Quadrant2');

    DocumentReference session = FirebaseFirestore.instance
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .collection("session_time")
        .doc("time");

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
                    document.data()! as Map<dynamic, dynamic>;

                return Dismissible(
                    key: Key('$data'),
                    onDismissed: (DismissDirection) async {
                      //ondismissed(data['Name']);

                      var documentdata = await session.get();

                      var documentuser = documentdata.data() as Map;
                      if (flag == 0 &&
                          documentuser['time'].compareTo(
                                  Timestamp.fromDate(DateTime.now())) >
                              0) {
                        collectQuadrant1.update({
                          "Name": FieldValue.increment(1),
                        });
                        avg_q1_document.update({
                          "Name": FieldValue.increment(1),
                        });
                      } else if (flag == 1 &&
                          documentuser['time'].compareTo(
                                  Timestamp.fromDate(DateTime.now())) >
                              0) {
                        collectQuadrant2.update({
                          "Name": FieldValue.increment(1),
                          "color": '0xFFa531e8',
                        });
                        avg_q2_document.update({
                          "Name": FieldValue.increment(1),
                        });
                      }

                      await flutterLocalNotificationsPlugin
                          .cancel(data['notification id'].hashCode);
                      document.reference.delete();
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (flag == 0) {
                          if (data.containsValue(data['description']))
                            createAlertDialog(
                                BuildContext,
                                context,
                                data['displayName'].toString(),
                                document,
                                data['description'],
                                data,
                                dateController,
                                timeController,
                                flag,
                                "Move task to Secondary");
                          else
                            createAlertDialog(
                                BuildContext,
                                context,
                                data['displayName'].toString(),
                                document,
                                '',
                                data,
                                dateController,
                                timeController,
                                flag,
                                'Move task to Secondary');
                        } else {
                          if (data.containsValue(data['description']))
                            createAlertDialog(
                                BuildContext,
                                context,
                                data['displayName'].toString(),
                                document,
                                data['description'],
                                data,
                                dateController,
                                timeController,
                                flag,
                                "Move task to Primary");
                          else
                            createAlertDialog(
                                BuildContext,
                                context,
                                data['displayName'].toString(),
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
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      flag == 0
                                          ? ThemeStyle.ListViewColorPrimaryFirst
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
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 30.0),
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
                                                    data['displayName']
                                                        .toString(),
                                                    style: new TextStyle(
                                                        fontSize: 18,
                                                        color: Color.fromARGB(
                                                            255,
                                                            252,
                                                            252,
                                                            252)),
                                                  ),
                                                ),
                                                Transform.scale(
                                                  scale: 1.5,
                                                  child: Checkbox(
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.white),
                                                      autofocus: true,
                                                      shape: CircleBorder(),
                                                      value: data['ticked'],
                                                      onChanged: (bool? value) {
                                                        checkBox(
                                                            data['displayName'],
                                                            value!,
                                                            document);
                                                      }),
                                                ),
                                              ]),
                                          if (data.containsValue(
                                                  data['setTime']) &&
                                              data['setTime'] != '    ' &&
                                              data['setTime'] != '  ')
                                            Text(
                                              data['setTime'].toString(),
                                              style: TextStyle(
                                                  //fontSize: 18,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color.fromARGB(
                                                      255, 255, 253, 253)),
                                            )
                                        ]),
                                  ),
                                ),
                              ],
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
