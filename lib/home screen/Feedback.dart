import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:proda/FirebaseCommands.dart';
import 'package:proda/Themes.dart';
import 'package:proda/home%20screen/Analysis.dart';

Future<void> Createfeedback(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  var MetaDataUser;
  var FirebaseCommand = FirebaseCommands();
  var ThemeStyle = ThemeStyles();
  List<String> Analysis = [];
  DocumentReference MetaData = FirebaseCommand.GetMetaData(uid);

  var GetMetaData = await FirebaseCommand.GetMetaData(uid).get();

  if (GetMetaData.data() != null) {
    MetaDataUser = GetMetaData.data() as Map;
    int Primary = MetaDataUser['Primary'];
    int Secondary = MetaDataUser['Secondary'];

    Analysis = AnalyzeTaskPad(Primary, Secondary);
  }

  int PrimaryDataLength = 3;

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Feedback"),
            backgroundColor: Colors.cyan,
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (MetaDataUser != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Status of Primary',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Icon(Icons.add_alert_sharp),
                          ],
                        ),
                        Text(Analysis.elementAt(0) + '\n\n',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 1, 65, 17),
                            )),
                        Text('Status of Secondary',
                            style: ThemeStyle.getFeedbackLabelTextStyle()),
                        Text(Analysis.elementAt(1) + '\n\n',
                            style: ThemeStyle.getFeedbackSecondaryTextStyle()),
                        Text(
                          'Workload Balance',
                          style: ThemeStyle.getFeedbackLabelTextStyle(),
                        ),
                        Text(
                          Analysis.elementAt(2),
                          style: ThemeStyle.getFeedbackWorkLoadTextStyle(),
                        )
                      ],
                    )
                  else
                    Text(
                      "Start Adding Task",
                      style: TextStyle(fontSize: 20),
                    )
                ],
              ),
            ));
      });
}
