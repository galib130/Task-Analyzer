import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proda/Analysis%20Functions/Analysis.dart';
import 'dart:async';

import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Themes.dart';
import 'package:proda/Analysis%20Functions/ProvideAnalysis.dart';

Future<void> Createfeedback(BuildContext context, SessionStatus status) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  var MetaDataUser;

  var firebaseCommand = FirebaseCommands();
  var themeStyle = ThemeStyles();
  List<String> analysis = [];

  if (status == SessionStatus.tab) {
    var getMetaData = await firebaseCommand.GetMetaData(uid).get();

    if (getMetaData.data() != null) {
      MetaDataUser = getMetaData.data() as Map;
      int primary = MetaDataUser['Primary'];
      int secondary = MetaDataUser['Secondary'];

      var tabanalysis = TabAnalysis();
      analysis = provideAnalysis(primary, secondary, tabanalysis.getFeedback());
    }
  } else if (status == SessionStatus.session) {
    var sessionanalysis = SessionAnalysis();
    var getMetaData =
        await sessionanalysis.getMetaData(uid).doc("Quadrant1").get();
    if (getMetaData.data() != null) {
      MetaDataUser = getMetaData.data() as Map;
      int primary = MetaDataUser["Name"];
      var getSecondaryMetaData =
          await sessionanalysis.getMetaData(uid).doc("Quadrant2").get();
      var metadataSecondaryUser = getSecondaryMetaData.data() as Map;

      int secondary = metadataSecondaryUser["Name"];

      analysis =
          provideAnalysis(primary, secondary, sessionanalysis.getFeedback());
    }
  } else if (status == SessionStatus.efficiency) {
    var efficiency = EfficiencyAnalysis();
    var getMetaData = await efficiency.getMetaData(uid).doc("Quadrant1").get();
    if (getMetaData.data() != null) {
      MetaDataUser = getMetaData.data() as Map;
      int primary = (MetaDataUser["Name"] / MetaDataUser["session"]).ceil();
      var getSecondaryMetaData =
          await efficiency.getMetaData(uid).doc("Quadrant2").get();
      var metadataSecondaryUser = getSecondaryMetaData.data() as Map;
      int secondary =
          (metadataSecondaryUser["Name"] / metadataSecondaryUser["session"])
              .ceil();
      analysis = provideAnalysis(primary, secondary, efficiency.getFeedback());
    }
  }

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
                        Text(analysis.elementAt(0) + '\n\n',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 1, 65, 17),
                            )),
                        Text('Status of Secondary',
                            style: themeStyle.getFeedbackLabelTextStyle()),
                        Text(analysis.elementAt(1) + '\n\n',
                            style: themeStyle.getFeedbackSecondaryTextStyle()),
                        Text(
                          'Workload Balance',
                          style: themeStyle.getFeedbackLabelTextStyle(),
                        ),
                        Text(
                          analysis.elementAt(2),
                          style: themeStyle.getFeedbackWorkLoadTextStyle(),
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
