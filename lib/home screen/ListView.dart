import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    if (map_data.containsValue(map_data['date']))
      date_controller.text = map_data['date'];
    if (map_data.containsValue(map_data['time']))
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
                          //d
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
                          moveQuadrant.doc().set({
                            "Name": update_controller.text.trim(),
                            "Timestamp": time,
                            "ticked": false,
                            "setTime": time_controller.text +
                                '    ' +
                                date_controller.text,
                            "displayName": update_controller.text.trim(),
                            "difference": map_data['difference'],
                            "notification id": map_data['notification id'],
                            "description": description_controller.text.trim(),
                            "date": date_controller.text.trim(),
                            "time": time_controller.text.trim(),
                          });
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
                          //update(update_controller.text,data);
                          document.reference.update({
                            "Name": update_controller.text,
                            "displayName": update_controller.text,
                            "description": description_controller.text,
                            "time": time_controller.text,
                            "date": date_controller.text,
                            "setTime": date_controller.text +
                                '  ' +
                                time_controller.text
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
  List list1 = [''];
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
                    document.data()! as Map<dynamic, dynamic>;

                return Dismissible(
                    key: Key('$data'),
                    onDismissed: (DismissDirection) async {
                      //ondismissed(data['Name']);
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
                                          ? Color.fromARGB(218, 149, 243, 243)
                                          : Color.fromARGB(207, 132, 155, 255),
                                      flag == 0
                                          ? Color.fromARGB(235, 11, 189, 233)
                                          : Color.fromARGB(235, 111, 189, 241)
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
                                                            255, 26, 25, 25)),
                                                  ),
                                                ),
                                                Transform.scale(
                                                  scale: 1.5,
                                                  child: Checkbox(
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
                                                      255, 48, 46, 46)),
                                            )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
