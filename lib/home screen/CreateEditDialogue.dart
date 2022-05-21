
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// Future<void> createEditDialog(
//       BuildContext,
//       context,
//       String data,
//       DocumentSnapshot document,
//       String description,
//       Map<dynamic, dynamic> map_data,
//      TextEditingController date_controller,
//       TextEditingController time_controller,
//       int flag,
//       String moveButton) {
//     TextEditingController update_controller = TextEditingController();
//     TextEditingController description_controller = TextEditingController();
//     update_controller.text = data;
//     description_controller.text = description;
//     date_controller.text = map_data['date'];
//     time_controller.text = map_data['time'];

//     return showDialog(
//         context: context,
//         builder: (context) {
//           return WillPopScope(
//             onWillPop: () async {
//               time_controller.clear();
//               date_controller.clear();
//               Navigator.pop(context);

//               return false;
//             },
//             child: AlertDialog(
//                 backgroundColor: Colors.cyan,
//                 title: Text("Details"),
//                 scrollable: true,
//                 content: Container(
//                   height: 600,
//                   width: 600,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Task'),
//                       Expanded(
//                         child: TextField(
//                           maxLines: 1,
//                           controller: update_controller,
//                         ),
//                       ),
//                       Text('Description'),
//                       Expanded(
//                         child: TextField(
//                           maxLines: 1,
//                           controller: description_controller,
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: TextField(
//                           maxLines: 1,
//                           readOnly: true,
//                           decoration: InputDecoration(hintText: 'Date'),
//                           controller: date_controller,
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           setDate(context);
//                         },
//                         child: Text('Select Date'),
//                         style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         )),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: TextField(
//                           maxLines: 1,
//                           decoration: InputDecoration(hintText: 'Time'),
//                           controller: time_controller,
//                         ),
//                       ),
//                       ElevatedButton(
//                         child: Text('Select Time'),
//                         style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         )),
//                         onPressed: () {
//                           setTime(context);
//                         },
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           FirebaseAuth auth = FirebaseAuth.instance;
//                           String uid = auth.currentUser!.uid;
//                           CollectionReference moveQuadrant;
//                           DocumentReference PrimarySessionReference =
//                               FirebaseCommand.getQuadrant1_Session(uid);
//                           DocumentReference SecondarySessionReference =
//                               FirebaseCommand.getQuadrant2_Session(uid);
//                           if (flag == 0)
//                             moveQuadrant = FirebaseFirestore.instance
//                                 .collection('Users')
//                                 .doc(uid)
//                                 .collection('Quadrant2');
//                           else
//                             moveQuadrant = FirebaseFirestore.instance
//                                 .collection('Users')
//                                 .doc(uid)
//                                 .collection('Mytask');

//                           DateTime currentDate = DateTime.now();
//                           Timestamp time = Timestamp.fromDate(currentDate);
//                           String SetTime;
//                           if (date_controller.text != '' &&
//                               time_controller.text != '') {
//                             SetTime = date_controller.text +
//                                 '    ' +
//                                 time_controller.text;
//                           } else if (date_controller.text != '') {
//                             SetTime = date_controller.text;
//                           } else
//                             SetTime = time_controller.text;

//                           moveQuadrant.doc().set({
//                             "Name": update_controller.text.trim(),
//                             "Timestamp": time,
//                             "ticked": false,
//                             "setTime": SetTime,
//                             "displayName": update_controller.text.trim(),
//                             "difference": map_data['difference'],
//                             "notification id": map_data['notification id'],
//                             "description": description_controller.text.trim(),
//                             "date": date_controller.text.trim(),
//                             "time": time_controller.text.trim(),
//                           });
//                           if (flag == 0) {
//                             FirebaseCommand.UpdateSession(
//                                 PrimarySessionReference, 1);
//                             FirebaseCommand.UpdateSession(
//                                 SecondarySessionReference, -1);
//                             FirebaseCommand.UpdateAverageSession(
//                                 FirebaseCommand.getQuadrant1_Average_Session(
//                                     uid),
//                                 1);
//                             FirebaseCommand.UpdateAverageSession(
//                                 FirebaseCommand.getQuadrant2_Average_Session(
//                                     uid),
//                                 -1);
//                           } else if (flag != 0) {
//                             FirebaseCommand.UpdateSession(
//                                 PrimarySessionReference, -1);
//                             FirebaseCommand.UpdateSession(
//                                 SecondarySessionReference, 1);

//                             FirebaseCommand.UpdateAverageSession(
//                                 FirebaseCommand.getQuadrant1_Average_Session(
//                                     uid),
//                                 -1);
//                             FirebaseCommand.UpdateAverageSession(
//                                 FirebaseCommand.getQuadrant2_Average_Session(
//                                     uid),
//                                 1);
//                           }
//                           FirebaseCommand.UpdateMetaData(uid, flag, 'Subtract');
//                           FirebaseCommand.UpdateMetaData(uid, flag - 1, 'Add');
//                           document.reference.delete();
//                           date_controller.clear();
//                           time_controller.clear();

//                           Navigator.pop(context);
//                         },
//                         child: Text(moveButton),
//                         style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         )),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           String SetTime;
//                           if (date_controller.text != '' &&
//                               time_controller.text != '') {
//                             SetTime = date_controller.text +
//                                 '    ' +
//                                 time_controller.text;
//                           } else if (date_controller.text != '') {
//                             SetTime = date_controller.text;
//                           } else
//                             SetTime = time_controller.text;

//                           //update(update_controller.text,data);
//                           document.reference.update({
//                             "Name": update_controller.text,
//                             "displayName": update_controller.text,
//                             "description": description_controller.text,
//                             "time": time_controller.text,
//                             "date": date_controller.text,
//                             "setTime": SetTime
//                           });
//                           date_controller.clear();
//                           time_controller.clear();
//                           Navigator.pop(context);
//                         },
//                         child: Text('Edit'),
//                       ),
//                     ],
//                   ),
//                 )),
//           );
//         });
//   }