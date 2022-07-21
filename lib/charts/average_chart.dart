//import 'dart:ffi';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proda/Drawer.dart';
import 'package:proda/Providers/SessionProvider.dart';
import '../Analysis Functions/Analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'PopUpMenu.dart';
import 'package:provider/provider.dart';

class AverageSessionObject {
  final int value;
  final String xaxis;
  final String color;
  final String session;

  AverageSessionObject(
      {required this.value,
      required this.xaxis,
      required this.color,
      required this.session});
  AverageSessionObject.fromMap(
    Map<String, dynamic> map,
  )   : assert(map['Name'] != null),
        assert(map['xaxis'] != null),
        assert(map['color'] != null),
        assert(map['session'] != null),
        value = map['Name'],
        xaxis = map['xaxis'],
        color = map['color'],
        session = map['session'].toString();

  @override
  String toString() => "R";
}

FirebaseAuth auth = FirebaseAuth.instance;

class AverageSession extends StatefulWidget {
  _AverageSessionState createState() => _AverageSessionState();
}
//fsafd

class _AverageSessionState extends State<AverageSession> {
  List<charts.Series<AverageSessionObject, String>> _seriesBarData = [];
  String uid = auth.currentUser!.uid;
  Timestamp sessionTimestamp = Timestamp.now();
  List<AverageSessionObject> mydata = [];
  DateTime sessionDay = DateTime.now();

  _averageGenerateChart(mydata) {
    _seriesBarData.add(charts.Series(
        domainFn: (AverageSessionObject sessionAxis, _) =>
            sessionAxis.xaxis.toString(),
        measureFn: (AverageSessionObject sessionAxis, _) =>
            sessionAxis.value / int.parse(sessionAxis.session),
        colorFn: (AverageSessionObject sessionAxis, _) =>
            charts.ColorUtil.fromDartColor(
              Color(int.parse(sessionAxis.color)),
            ),
        data: mydata,
        id: 'Session'));
  }

  TextEditingController textedit = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> averageSessionStream =
        context.read<SessionProvider>().getAverageSessionStream(uid);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Efficiency of Quadrants'),
        actions: [getPopUpMenu(context, SessionStatus.efficiency)],
      ),
      drawer: getDrawer(context),
      body: _averageBuildbody(context, averageSessionStream),
    );
  }

  Widget _averageBuildbody(context, averageSessionStream) {
    return StreamBuilder<QuerySnapshot>(
        stream: averageSessionStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Nothing to show');
          } else if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            List<AverageSessionObject> session = snapshot.data!.docs
                .map((DocumentSnapshot snapshot) =>
                    AverageSessionObject.fromMap(
                        snapshot.data() as Map<String, dynamic>))
                .toList();

            return _averageBuildChart(context, session);
          }
        });
  }

  Widget _averageBuildChart(
    BuildContext context,
    List<AverageSessionObject> session,
  ) {
    mydata = session;
    _averageGenerateChart(mydata);

    //print(get_last_sesion_date);

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              if (session.isNotEmpty)
                Text(
                  'No. of session : ' + session[1].session.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
                      fontSize: 18, // size in Pts.
                      color: charts.MaterialPalette.blue.shadeDefault),
                )),
                primaryMeasureAxis: new charts.NumericAxisSpec(
                    renderSpec: new charts.SmallTickRendererSpec(
                  labelStyle: new charts.TextStyleSpec(
                    fontSize: 18,
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
