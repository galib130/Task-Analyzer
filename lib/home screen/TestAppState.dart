import 'dart:async';
import 'package:flutter/material.dart';
import 'TestApp.dart';
import 'ListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../authentication/firebase.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../notification/notification.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Alertdialogue.dart';

List<String> textadd1 = <String>['S/W Lab', 'Maths'];
final firebaseinstance = FirebaseFirestore.instance;
var today = new DateTime.now();
var addwithtoday = new DateTime.now();
var change_state = 0;
FirebaseAuth auth = FirebaseAuth.instance;

class TestAppState extends State<TestApp> {
  String uid = auth.currentUser!.uid;
  var date_picked = 1;
  var time_picked = 1;
  var date_difference = 0;
  var time_difference = 0;

  var addquest = 0;
  var addquest1 = 0;
  var flagofflist = 0;
  var quest = 0;
  TextEditingController _taskcontroller = TextEditingController();
  TextEditingController _timecontroller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _secondcontroller = TextEditingController();
  TextEditingController _descriptioncontroller = TextEditingController();

  String Task = '';
  DateTime currentDate = DateTime.now();
  DateTime pickedDate = DateTime.now();
  DateTime compareDate = DateTime.now();
  DateTime totalDate = DateTime.now().subtract(Duration(seconds: 2));
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay pickedTime = TimeOfDay.now();
  int difference = 0;
  static const routename = '/profile';
//ok
  //call to add complete task and then delete the task
  void checkbox(
      String documnent, bool? value, DocumentSnapshot documentSnapshot) async {
    CollectionReference completed_quadrant1 = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Quadrant1_Complete');
    CollectionReference completed_quadrant2 = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Quadrant2_Complete');
    DateTime currentDate = DateTime.now();
    Timestamp time = Timestamp.fromDate(currentDate);
    DocumentReference session = FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("session_time")
        .doc("time");
    DocumentReference collectquadrant2_session = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("session")
        .doc('Quadrant2');
    DocumentReference collectquadrant1_session = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("session")
        .doc('Quadrant1');
    DocumentReference avg_q1_document = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("average_session")
        .doc('Quadrant1');
    DocumentReference avg_q2_document = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection("average_session")
        .doc('Quadrant2');

    var documentdata = await session.get();
    var documentuser = documentdata.data() as Map;

    if (change_state == 0) {
      documentSnapshot.reference.update({"ticked": value});

      if (documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now())) >
              0 &&
          change_state == 0) {
        collectquadrant1_session.update({"Name": FieldValue.increment(3)});

        completed_quadrant1
            .doc(documnent)
            .set({"Name": documnent, "Timestamp": time, "ticked": false});
        avg_q1_document.update({"Name": FieldValue.increment(3)});
      }
    } else {
      documentSnapshot.reference.update({"ticked": value});

      if (documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now())) >
              0 &&
          change_state == 1) {
        collectquadrant2_session.update({"Name": FieldValue.increment(3)});
        completed_quadrant2
            .doc(documnent)
            .set({"Name": documnent, "Timestamp": time, "ticked": false});
        avg_q2_document.update({"Name": FieldValue.increment(3)});
      }
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      documentSnapshot.reference.delete();
    });
  }

  StreamController user_controller = StreamController();
  StreamController quadrant2_controller = StreamController();

  @override
  void initState() {
    super.initState();
  }

  void reorder(
      AsyncSnapshot<QuerySnapshot> snapshot, int newIndex, int oldIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex -= 1;
      var newSnapshotTimestamp = snapshot.data!.docs[newIndex];

      Timestamp timestamp = newSnapshotTimestamp['Timestamp'];

      DateTime newDate = DateTime.parse(timestamp.toDate().toString());

      if (oldIndex < newIndex)
        snapshot.data!.docs[oldIndex].reference.update({
          'Timestamp':
              Timestamp.fromDate(newDate.add(Duration(microseconds: 1)))
        });
      else
        snapshot.data!.docs[oldIndex].reference.update({
          'Timestamp':
              Timestamp.fromDate(newDate.subtract(Duration(microseconds: 1)))
        });
    });
  }

  final Stream<QuerySnapshot> users = FirebaseFirestore.instance
      .collection('Users')
      .doc(auth.currentUser!.uid)
      .collection('Mytask')
      .orderBy('Timestamp')
      .snapshots(includeMetadataChanges: true);

  final Stream<QuerySnapshot> quadrant2 = FirebaseFirestore.instance
      .collection('Users')
      .doc(auth.currentUser!.uid)
      .collection('Quadrant2')
      .orderBy('Timestamp')
      .snapshots(includeMetadataChanges: true);

  var quadrant1_complete = FirebaseFirestore.instance
      .collection('Users')
      .doc(auth.currentUser!.uid)
      .collection('Quadrant1_Complete');

  var quadrant2_complete = FirebaseFirestore.instance
      .collection('Users')
      .doc(auth.currentUser!.uid)
      .collection('Quadrant2_Complete');
  DocumentReference set_date_time = FirebaseFirestore.instance
      .collection('Users')
      .doc(auth.currentUser!.uid)
      .collection('date and time ')
      .doc('date and time set');

  Widget build(BuildContext context) {
    final suggestList = [];
    //call suggestlist
    setState(() {
      suggestList.clear();
      if (change_state == 0) {
        quadrant1_complete.get().then((snapshot) {
          snapshot.docs.forEach((doc) {
            suggestList.add(doc.id.toString());
            // print(doc.id);
          });
        });
      } else {
        quadrant2_complete.get().then((snapshot) {
          snapshot.docs.forEach((doc) {
            suggestList.add(doc.id.toString());
            // print(doc.id);
          });
        });
      }
    });

    //call autocomplete list
    Future<List<dynamic>> suggestionList(String query) async {
      final lastlist = [];

      suggestList.forEach((element) {
        if (element.contains(query)) lastlist.add(element);
      });

      return lastlist;
    }

    //Function to add data to backend

    Future<void> postTasks(String? task, int flag) async {
      if (task != '') {
        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = auth.currentUser!.uid.toString();
        DateTime currentDate = DateTime.now();
        Timestamp time = Timestamp.fromDate(currentDate);
        CollectionReference users = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Mytask');

        CollectionReference quadrant2 = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Quadrant2');
        DocumentReference session = FirebaseFirestore.instance
            .collection("Users")
            .doc(uid)
            .collection("session_time")
            .doc("time");
        DocumentReference collectQuadrant2 = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection("session")
            .doc('Quadrant2');
        DocumentReference collectQuadrant1 = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection("session")
            .doc('Quadrant1');
        DocumentReference avg_q1_document = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection("average_session")
            .doc('Quadrant1');
        DocumentReference avg_q2_document = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection("average_session")
            .doc('Quadrant2');

        if (flag == 0) {
          print(task);
          print(_taskcontroller.text);
          users.doc().set({
            "Name": task,
            "Timestamp": time,
            "difference": time_difference + date_difference,
            "ticked": false,
            "setTime": _datecontroller.text + '    ' + _timecontroller.text,
            "displayName": _taskcontroller.text,
            "notification id": _datecontroller.text.trim() +
                _timecontroller.text.trim() +
                _secondcontroller.text.trim(),
            "description": _descriptioncontroller.text.trim(),
            "date": _datecontroller.text.trim(),
            "time": _timecontroller.text.trim(),
          }, SetOptions(merge: true));
        } else {
          quadrant2.doc().set({
            "Name": task,
            "Timestamp": time,
            "ticked": false,
            "setTime": _datecontroller.text + '    ' + _timecontroller.text,
            "displayName": _taskcontroller.text,
            "difference": time_difference + date_difference,
            "notification id": _datecontroller.text.trim() +
                _timecontroller.text.trim() +
                _secondcontroller.text.trim(),
            "description": _descriptioncontroller.text.trim(),
            "date": _datecontroller.text.trim(),
            "time": _timecontroller.text.trim(),
          }, SetOptions(merge: true));
        }

        var documentdata = await session.get();

        var documentuser = documentdata.data() as Map;

        if (flag == 0) {
          if (documentuser['time']
                      .compareTo(Timestamp.fromDate(DateTime.now())) >
                  0 &&
              change_state == 0) {
            collectQuadrant1.update({
              "Name": FieldValue.increment(-1),
              "color": '0xFF34c9eb',
            });
            avg_q1_document.update({
              "Name": FieldValue.increment(-1),
              "color": '0xFF34c9eb',
            });
          } else
            print(time.toDate());
        } else {
          if (documentuser['time']
                      .compareTo(Timestamp.fromDate(DateTime.now())) >
                  0 &&
              change_state == 1) {
            collectQuadrant2.update({
              "Name": FieldValue.increment(-1),
              "color": '0xFFa531e8',
            });
            avg_q2_document.update({
              "Name": FieldValue.increment(-1),
            });
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please enter a non empty task", backgroundColor: Colors.blue);
      }
      return;
    }

    //Function to set a new session
    void setSession() async {
      setState(() {
        DocumentReference session_time = FirebaseFirestore.instance
            .collection("Users")
            .doc(uid)
            .collection("session_time")
            .doc("time");
        DocumentReference q1_document = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection("session")
            .doc('Quadrant1');
        DocumentReference q2_document = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection("session")
            .doc('Quadrant2');
        DocumentReference avg_q1_document = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection("average_session")
            .doc('Quadrant1');
        DocumentReference avg_q2_document = FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection("average_session")
            .doc('Quadrant2');
        addwithtoday = today.add(new Duration(days: 7));
        DateTime currentdate = DateTime.now();
        addwithtoday = currentdate.add(new Duration(days: 7));
        Timestamp time = Timestamp.fromDate(addwithtoday);

        print(time.toString());
        session_time.set({"time": time});

        q1_document.set({
          "Name": 0,
          "color": '0xFF34c9eb',
          "xaxis": 'Active',
          "time": time.toDate().toString(),
        });

        q2_document.set({
          "Name": 0,
          "color": '0xFFa531e8',
          "xaxis": 'Secondary',
          "time": time.toDate().toString(),
        });

        avg_q1_document.set({
          "Name": FieldValue.increment(0),
          "color": '0xFFa531e8',
          "xaxis": 'Active',
          "session": FieldValue.increment(1),
        }, SetOptions(merge: true));
        avg_q2_document.set({
          "Name": FieldValue.increment(0),
          "color": '0xFF34c9eb',
          "xaxis": 'Secondary',
          "session": FieldValue.increment(1),
        }, SetOptions(merge: true));
        Fluttertoast.showToast(
            msg: "New Session Added", backgroundColor: Colors.blue);
      });
    }

    //Function to initially add a task
    void add() {
      if (change_state == 0) {
        //flag 0 for quadrant 1

        postTasks(
            _taskcontroller.text.trim() +
                _datecontroller.text.trim() +
                _timecontroller.text.trim(),
            change_state); // calls the function which adds to firebase
      } else //flag1 for quadrant 2
      {
        postTasks(
            _taskcontroller.text.trim() +
                _datecontroller.text.trim() +
                _timecontroller.text.trim(),
            change_state);
      }
    }

    //Function to change quadrants
    void change(int state) {
      setState(() {
        change_state = state;
      });
    }

    //Function to select date
    Future<Null> _selectDate(BuildContext context) async {
      final pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime.now().subtract(Duration(days: 4)),
          lastDate: DateTime(2023));
      if (pickedDate != null && pickedDate != currentDate)
        setState(() {
          currentDate = pickedDate;
          _datecontroller.clear();
          _datecontroller.text = currentDate.day.toString() +
              '-' +
              currentDate.month.toString() +
              '-' +
              currentDate.year.toString();

          _secondcontroller.text = DateTime.now().second.toString() +
              DateTime.now().hour.toString() +
              DateTime.now().minute.toString() +
              DateTime.now().millisecond.toString() +
              TimeOfDay.now().period.toString();
          DateTime datenow = DateTime.now();
          date_picked = 0;

          date_difference = 0;
          if (currentDate.day != DateTime.now().day) {
            date_difference = currentDate.difference(datenow).inSeconds;
            set_date_time.set({
              "date difference": currentDate.difference(datenow).inSeconds,
            }, SetOptions(merge: true));

            totalDate =
                totalDate.add(Duration(seconds: date_difference as int));
          } else {
            set_date_time.set({"date difference": 0}, SetOptions(merge: true));
          }
          print(date_difference.toString() + 'date difference');
          currentDate = DateTime.now().subtract(Duration(days: 3));
        });
    }

    // Function to select time
    Future<Null> _selectTime(BuildContext context) async {
      var temp = TimeOfDay.now();

      final TimeOfDay? pickedTime =
          await showTimePicker(context: context, initialTime: temp);
      if (pickedTime != null && pickedTime != time)
        setState(() {
          time = pickedTime;
          int datenow =
              TimeOfDay.now().hour * 3600 + TimeOfDay.now().minute * 60;

          _timecontroller.clear();
          if (time.period.toString() == 'DayPeriod.am')
            _timecontroller.text =
                time.hour.toString() + ':' + time.minute.toString() + 'am';
          if (time.period.toString() == 'DayPeriod.pm')
            _timecontroller.text =
                time.hour.toString() + ':' + time.minute.toString() + 'pm';
          time_difference = 0;
          print(totalDate);
          time_picked = 0;
          // time_difference= difference;

          time_difference = (time.minute * 60 + time.hour * 3600) - datenow;
          _secondcontroller.text = DateTime.now().second.toString() +
              DateTime.now().hour.toString() +
              DateTime.now().minute.toString() +
              DateTime.now().millisecond.toString() +
              TimeOfDay.now().period.toString();
          set_date_time.set({
            "time difference": (time.minute * 60 + time.hour * 3600) - datenow,
          }, SetOptions(merge: true));

          totalDate = totalDate.add(Duration(seconds: time_difference as int));
          //print(difference.toString() + "time");
          print(time_difference.toString() + 'time difference');

          time = time.replacing(hour: time.hour, minute: time.minute - 2);
        });
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            change_state == 0 ? Text("Primary") : Text("Secondary"),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    context.read<FlutterFireAuthService>().signOut();
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/openview', (Route<dynamic> route) => false);
                  });
                },
                child: Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 3, 8, 78),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              //image:  DecorationImage(image: new AssetImage('assets/listtile.jpg'),fit: BoxFit.cover)
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: [
                    Colors.cyan,
                    Colors.indigoAccent,
                  ])),
          child: Stack(
            children: [
              Positioned(
                  top: 80,
                  left: 50,
                  right: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      //ADD button
                      change(0);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/profile', (Route<dynamic> route) => false);
                    },
                    child: Text(
                      'Primary',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.black,
                        shadowColor: Colors.red,
                        elevation: 10,
                        padding: EdgeInsets.all(25)),
                  )),
              Positioned(
                  top: 180,
                  left: 50,
                  right: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      //ADD button
                      change(1);
                      //print(textadd[addquest-1]);
                      print(change_state);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/profile', (Route<dynamic> route) => false);
                      // Navigator.of(context).pop();
                    },
                    child: Text(
                      'Secondary',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.black,
                      padding: EdgeInsets.all(25),
                      shadowColor: Colors.red,
                      elevation: 10,
                    ),
                  )),
              Positioned(
                top: 280,
                left: 50,
                right: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      uid = auth.currentUser!.uid;
                      setSession();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/profile', (Route<dynamic> route) => false);
                    });
                  },
                  child: Text(
                    'Set Session',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                    padding: EdgeInsets.all(25),
                    shadowColor: Colors.red,
                    elevation: 10,
                  ),
                ),
              ),
              Positioned(
                top: 380,
                left: 50,
                right: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/chart');
                  },
                  child: Text(
                    'Session Summary',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                    padding: EdgeInsets.all(25),
                    shadowColor: Colors.red,
                    elevation: 10,
                  ),
                ),
              ),
              Positioned(
                top: 480,
                left: 50,
                right: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/average_chart');
                  },
                  child: Text(
                    'Efficiency',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                    padding: EdgeInsets.all(25),
                    shadowColor: Colors.red,
                    elevation: 10,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            //image:  DecorationImage(image: new AssetImage('assets/gradient.png'),fit: BoxFit.cover)

            color: Color.fromARGB(255, 8, 2, 44)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent,
                      padding: EdgeInsets.all(15),
                      shadowColor: Colors.red,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      var get_date_time_data = await set_date_time.get();
                      var date_time_data = get_date_time_data.data() as Map;
                      //ADD button
                      if (_taskcontroller.text.isNotEmpty) {
                        setState(() {
                          add();
                          print(difference.toString() + 'difference');

                          if (date_difference != 0 || time_difference != 0) {
                            difference = date_difference + time_difference;

                            NotificationApi.showScheduledNotification(
                                id: (_datecontroller.text.trim() +
                                        _timecontroller.text.trim() +
                                        _secondcontroller.text.trim())
                                    .hashCode,
                                title: _taskcontroller.text,
                                body: 'Hey you added this task',
                                scheduledDate: DateTime.now().add(Duration(
                                    seconds: (date_time_data[
                                            'date difference'] +
                                        date_time_data['time difference']))));

                            totalDate = compareDate;
                            date_difference = 0;
                            time_difference = 0;

                            print(date_picked);
                            difference = 0;
                          } else {
                            print('not notifying');
                          }
                        });
                      }
                      set_date_time.set({
                        "date difference": 0,
                        "time difference": 0,
                      });
                      _datecontroller.clear();
                      _timecontroller.clear();
                      _taskcontroller.clear();
                      _secondcontroller.clear();
                      _descriptioncontroller.clear();
                    },
                    child: Text(
                      'Set Notification',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  //For setting up notification
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent,
                      padding: EdgeInsets.all(15),
                      shadowColor: Colors.red,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      final page = createAlertDialog(
                          context,
                          _taskcontroller,
                          _datecontroller,
                          _timecontroller,
                          _descriptioncontroller,
                          _selectDate,
                          _selectTime);
                      page;
                      // Navigator.of(context).pushNamed(
                      //     '/detailView');
                    },
                    child: Text(
                      'Detailed Task',
                      style: TextStyle(color: Colors.black),
                    ),
                  ), //For Detail view
                ],
              ),

              //Type Input Field
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    //image:  DecorationImage(image: new AssetImage('assets/listtile.jpg'),fit: BoxFit.cover)
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.topLeft,
                        colors: [
                          Color.fromARGB(153, 2, 141, 255),
                          Color.fromARGB(204, 17, 165, 250)
                        ])),
                child: TypeAheadField(
                  //cursorHeight: 2,
                  textFieldConfiguration: TextFieldConfiguration(
                    cursorColor: Colors.black,
                    controller: _taskcontroller,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Items",
                      filled: true,
                      //fillColor: Colors.lightBlueAccent,
                      suffixIcon: IconButton(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 2),
                        onPressed: () {
                          add();
                          _taskcontroller.clear();
                          _timecontroller.clear();
                          _datecontroller.clear();
                          _secondcontroller.clear();
                          _descriptioncontroller.clear();
                        },
                        icon: Icon(
                          Icons.add_box_rounded,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await suggestionList(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (DismissDirection) {
                        if (change_state == 0) {
                          var quadrant1AutocompleteData =
                              quadrant1_complete.doc(suggestion.toString());
                          quadrant1AutocompleteData.delete();
                        } else {
                          var quadrant2AutocompleteData =
                              quadrant2_complete.doc(suggestion.toString());
                          quadrant2AutocompleteData.delete();
                        }

                        suggestList.remove(suggestion);
                      },
                      child: Container(
                        child: ListTile(
                          tileColor: Colors.cyan,
                          title: Text(suggestion.toString()),
                        ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _taskcontroller.text = suggestion.toString();
                  },
                  hideOnLoading: true,
                ),
              ),

              SizedBox(
                height: 10,
                child: Container(),
              ),

              //See list button depending on state
              if (change_state == 0)
                // Listview for quadrant 1
                AddList_State(
                  taskQuery: users,
                  flag: change_state,
                  checkBox: checkbox,
                  setDate: _selectDate,
                  setTime: _selectTime,
                  reorder: reorder,
                  dateController: _datecontroller,
                  timeController: _timecontroller,
                  color: Colors.blue,
                )
              else
                //Listview for quadrant 2
                AddList_State(
                  taskQuery: quadrant2,
                  flag: change_state,
                  checkBox: checkbox,
                  setDate: _selectDate,
                  setTime: _selectTime,
                  reorder: reorder,
                  dateController: _datecontroller,
                  timeController: _timecontroller,
                  color: Colors.yellow,
                )
            ]),
      ),
    );
  }
}
