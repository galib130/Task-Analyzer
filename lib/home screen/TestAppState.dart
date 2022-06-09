import 'dart:async';
// import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:proda/Analysis%20Functions/Analysis.dart';
import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Models/Task.dart';
import 'package:proda/Providers/ChangeState.dart';
import 'package:proda/Providers/TaskProvider.dart';
import 'package:proda/home%20screen/FeedbackDialog.dart';
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
import 'package:proda/Themes.dart';
import 'package:intl/intl.dart';

List<String> textadd1 = <String>['S/W Lab', 'Maths'];
final firebaseinstance = FirebaseFirestore.instance;
var today = new DateTime.now();
var addwithtoday = new DateTime.now();
var change_state = 0;
FirebaseAuth auth = FirebaseAuth.instance;

class TestAppState extends State<TestApp> {
  String uid = auth.currentUser!.uid;
  var ThemeStyle = ThemeStyles();
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
  var FirebaseCommand = FirebaseCommands();
  var TaskCommand = TaskCommands();
//ok
  //call to add complete task and then delete the task
  void checkbox(String documnent, bool? value,
      DocumentSnapshot documentSnapshot, Map<dynamic, dynamic> data) async {
    TaskCommand.checkbox(
        documnent, value, documentSnapshot, uid, change_state, data);
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
    change_state = context.watch<ChangeState>().flag;
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
          "xaxis": 'Primary',
          "time": DateFormat('EEEE, d MMM, yyyy  h:mm a').format(time.toDate()),
        });

        q2_document.set({
          "Name": 0,
          "color": '0xFFa531e8',
          "xaxis": 'Secondary',
          "time": DateFormat('EEEE, d MMM, yyyy  h:mm a').format(time.toDate()),
        });

        avg_q1_document.set({
          "Name": FieldValue.increment(0),
          "color": '0xFFa531e8',
          "xaxis": 'Primary',
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
// calls the function which adds to firebase
      context.read<TaskProvider>().postTasks(
          _taskcontroller.text.trim() +
              _datecontroller.text.trim() +
              _timecontroller.text.trim(),
          uid,
          _taskcontroller,
          _descriptioncontroller,
          _datecontroller,
          _timecontroller,
          _secondcontroller,
          time_difference,
          date_difference,
          change_state);
    }

    //Function to select date
    Future<Null> _selectDate(BuildContext context) async {
      context
          .read<TaskProvider>()
          .selectDate(context, _datecontroller, _secondcontroller, uid);
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
        backgroundColor: ThemeStyle.PrimaryDrawerButtonColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            change_state == 0
                ? Text(
                    "Primary",
                    style: TextStyle(fontSize: 20),
                  )
                : Text("Secondary"),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                style: ThemeStyle.getAppButtonStyle(),
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
        actions: [
          PopupMenuButton(
            color: ThemeStyle.PrimaryDrawerButtonColor,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    value: 1,
                    child: ThemeStyle.getDropDownText("Detailed Task")),
                PopupMenuItem(
                    value: 2,
                    child: ThemeStyle.getDropDownText("Set Notification")),
                PopupMenuItem(
                    value: 3, child: ThemeStyle.getDropDownText("Feedback")),
                PopupMenuItem(
                    value: 4, child: ThemeStyle.getDropDownText("Set Session"))
              ];
            },
            onSelected: (value) async {
              if (value == 1) {
                final page = createAlertDialog(
                    context,
                    _taskcontroller,
                    _datecontroller,
                    _timecontroller,
                    _descriptioncontroller,
                    _secondcontroller,
                    _selectDate,
                    _selectTime,
                    uid);
                page;
              } else if (value == 2) {
                var get_date_time_data = await set_date_time.get();
                var date_time_data = get_date_time_data.data() as Map;
                //ADD button
                if (_taskcontroller.text.isNotEmpty) {
                  setState(() {
                    add();
                    print(difference.toString() + 'difference');
                    print(date_time_data['date difference'] * 24 * 3600 +
                        date_time_data['time difference']);
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
                              seconds: (date_time_data['date difference'] *
                                      24 *
                                      3600 +
                                  date_time_data['time difference']))));

                      totalDate = compareDate;
                      date_difference = 0;
                      time_difference = 0;

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
              } else if (value == 3) {
                Createfeedback(context, SessionStatus.tab);
              } else if (value == 4) {
                setSession();
              }
            },
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 11, 63, 122),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              //image:  DecorationImage(image: new AssetImage('assets/listtile.jpg'),fit: BoxFit.cover)
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color.fromARGB(255, 11, 63, 122),
                    Color.fromARGB(255, 12, 7, 95),
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
                      context.read<ChangeState>().change_state(0);
                      //change(0);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/profile', (Route<dynamic> route) => false);
                    },
                    child: Text(
                      'Primary',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    style: ThemeStyle.getDrawerStyle(),
                  )),
              Positioned(
                  top: 180,
                  left: 50,
                  right: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      //ADD button
                      context.read<ChangeState>().change_state(1);
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
                    style: ThemeStyle.getDrawerStyle(),
                  )),
              Positioned(
                top: 280,
                left: 50,
                right: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/chart', (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Session Summary',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ThemeStyle.getDrawerStyle(),
                ),
              ),
              Positioned(
                top: 380,
                left: 50,
                right: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/average_chart', (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Efficiency',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ThemeStyle.getDrawerStyle(),
                ),
              ),
              Positioned(
                  top: 480,
                  left: 50,
                  right: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/completed');
                    },
                    child: Text(
                      "Completed",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ThemeStyle.getDrawerStyle(),
                  ))
            ],
          ),
        ),
      ),
      body: Container(
        decoration: ThemeStyle.getBackgroundTheme(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
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
              // Listview for quadrant 1
              AddList_State(
                taskQuery: change_state == 0 ? users : quadrant2,
                flag: change_state,
                checkBox: checkbox,
                setDate: _selectDate,
                setTime: _selectTime,
                reorder: reorder,
                dateController: _datecontroller,
                timeController: _timecontroller,
                color: Colors.blue,
              )
            ]),
      ),
    );
  }
}
