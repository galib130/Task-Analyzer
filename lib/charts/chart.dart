//import 'dart:ffi';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proda/Analysis%20Functions/Analysis.dart';
import 'package:proda/Drawer.dart';
import 'package:proda/charts/ChartTheme.dart';
import 'package:proda/charts/PopUpMenu.dart';

class SessionObject {
  var bar = Barchart();
  final int value;
  final String xaxis;
  final String color;
  final String time;
  SessionObject(
      {required this.value,
      required this.xaxis,
      required this.color,
      required this.time});
  SessionObject.fromMap(
    Map<String, dynamic> map,
  )   : assert(map['Name'] != null),
        assert(map['xaxis'] != null),
        assert(map['color'] != null),
        assert(map['time'] != null),
        value = map['Name'],
        xaxis = map['xaxis'],
        color = map['color'],
        time = map['time'];

  @override
  String toString() => "R";
}

FirebaseAuth auth = FirebaseAuth.instance;

class Session extends StatefulWidget {
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  List<charts.Series<SessionObject, String>> _seriesBarData = [];
  String uid = auth.currentUser!.uid;
  Timestamp sessionTimestamp = Timestamp.now();
  List<SessionObject> mydata = [];
  DateTime sessionDay = DateTime.now();
  TextEditingController controller = TextEditingController();
  _generatechart(mydata) {
    _seriesBarData.add(charts.Series(
        domainFn: (SessionObject sessionAxis, _) =>
            sessionAxis.xaxis.toString(),
        measureFn: (SessionObject sessionAxis, _) => sessionAxis.value,
        colorFn: (SessionObject sessionAxis, _) =>
            charts.ColorUtil.fromDartColor(
              Color(int.parse(sessionAxis.color)),
            ),
        data: mydata,
        id: 'Session'));
  }

  TextEditingController textedit = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Session Summary'),
        actions: [getPopUpMenu(context, SessionStatus.session)],
      ),
      drawer: getDrawer(context),
      body: _buildbody(context),
    );
  }

  Widget _buildbody(context) {
    String uid = auth.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(uid)
            .collection("session")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Nothing to show');
          } else if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            List<SessionObject> session = snapshot.data!.docs
                .map((DocumentSnapshot snapshot) => SessionObject.fromMap(
                    snapshot.data() as Map<String, dynamic>))
                .toList();

            return _buildChart(context, session);
          }
        });
  }

  Widget _buildChart(
    BuildContext context,
    List<SessionObject> session,
  ) {
    mydata = session;
    _generatechart(mydata);

    //print(get_last_sesion_date);

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              if (session.isNotEmpty)
                Text(
                  'Session ends at :\n' + session[1].time,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              SizedBox(
                height: 5.0,
              ),
              Expanded(
                  child: charts.BarChart(
                _seriesBarData,
                animate: true,
                animationDuration: Duration(seconds: 3),
                domainAxis: new charts.OrdinalAxisSpec(
                    renderSpec: new charts.SmallTickRendererSpec(
                  labelStyle: new charts.TextStyleSpec(
                      fontSize: 20, // size in Pts.
                      color: charts.MaterialPalette.blue.shadeDefault),
                )),
                primaryMeasureAxis: new charts.NumericAxisSpec(
                    renderSpec: new charts.SmallTickRendererSpec(
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 24,
                    color: charts.MaterialPalette.blue.shadeDefault,
                  ),
                )),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
