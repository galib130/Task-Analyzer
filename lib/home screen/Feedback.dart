import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:proda/FirebaseCommands.dart';
import 'package:proda/home%20screen/Analysis.dart';

Future<void> Createfeedback(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  var MetaDataUser;
  var FirebaseCommand = FirebaseCommands();
  String Analysis = '';
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
                    Text(Analysis,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
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
