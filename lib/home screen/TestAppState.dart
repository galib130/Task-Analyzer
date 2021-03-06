import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proda/Analysis%20Functions/Analysis.dart';
import 'package:proda/Drawer.dart';
import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Providers/ChangeState.dart';
import 'package:proda/Providers/SessionProvider.dart';
import 'package:proda/Providers/TaskProvider.dart';
import 'package:proda/home%20screen/Alertdialogue.dart';
import 'package:proda/home%20screen/FeedbackDialog.dart';
// import 'Alertdialogue.dart';
// import 'FeedbackDialog.dart';
import 'TestApp.dart';
import 'ListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../authentication/firebase.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:proda/Themes.dart';

List<String> textadd1 = <String>['S/W Lab', 'Maths'];
final firebaseinstance = FirebaseFirestore.instance;
var today = new DateTime.now();
var addwithtoday = new DateTime.now();
var changeState = 0;
FirebaseAuth auth = FirebaseAuth.instance;

class TestAppState extends State<TestApp> {
  String uid = auth.currentUser!.uid;
  TaskProvider taskProvider = TaskProvider();
  SessionProvider sessionProvider = SessionProvider();
  var themeStyle = ThemeStyles();
  var datePicked = 1;
  var timePicked = 1;
  var dateDifference = 0;
  var timeDifference = 0;

  var addquest = 0;
  var addquest1 = 0;
  var flagofflist = 0;
  var quest = 0;
  TextEditingController _taskcontroller = TextEditingController();
  TextEditingController _timecontroller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _secondcontroller = TextEditingController();
  TextEditingController _descriptioncontroller = TextEditingController();

  String task = '';
  DateTime currentDate = DateTime.now();
  DateTime pickedDate = DateTime.now();
  DateTime compareDate = DateTime.now();
  DateTime totalDate = DateTime.now().subtract(Duration(seconds: 2));
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay pickedTime = TimeOfDay.now();
  int difference = 0;
  static const routename = '/profile';
  var firebaseCommand = FirebaseCommands();
//ok
  //call to add complete task and then delete the task
  void checkbox(String documnent, bool? value,
      DocumentSnapshot documentSnapshot, Map<dynamic, dynamic> data) async {
    taskProvider.TaskComplete(value, documentSnapshot, uid, data);
    sessionProvider.updateSessionComplete(
        documnent, value, documentSnapshot, uid, changeState, data);
  }

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

  Widget build(BuildContext context) {
    changeState = context.watch<ChangeState>().flag;
    final suggestList = [];

    //call suggestlist
    setState(() {
      suggestList.clear();
      taskProvider.suggestionList(changeState, uid).get().then((snapshot) {
        snapshot.docs.forEach((doc) {
          suggestList.add(doc.id.toString());
          // print(doc.id);
        });
      });
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
      sessionProvider.setSession(uid);
    }

    //Function to initially add a task
    void add() {
// calls the function which adds to firebase
      taskProvider.postTasks(
          _taskcontroller.text.trim() +
              _datecontroller.text.trim() +
              _timecontroller.text.trim(),
          uid,
          _taskcontroller,
          _descriptioncontroller,
          _datecontroller,
          _timecontroller,
          _secondcontroller,
          changeState);
      sessionProvider.updateSessionAdd(uid, changeState, _taskcontroller.text);
    }

    //Function to select date
    Future<Null> _selectDate(BuildContext context) async {
      taskProvider.selectDate(context, _datecontroller, _secondcontroller, uid);
    }

    // Function to select time
    Future<Null> _selectTime(BuildContext context) async {
      taskProvider.selectTime(context, _timecontroller, _secondcontroller, uid);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeStyle.OnPrimaryDrawerButtonColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            changeState == 0
                ? Text(
                    "Primary",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )
                : Text("Secondary",
                    style: TextStyle(fontSize: 20, color: Colors.black)),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                style: themeStyle.getAppButtonStyle(),
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
            color: themeStyle.OnPrimaryDrawerButtonColor,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    value: 1,
                    child: themeStyle.getDropDownText("Detailed Task")),
                PopupMenuItem(
                    value: 2,
                    child: themeStyle.getDropDownText("Set Notification")),
                PopupMenuItem(
                    value: 3, child: themeStyle.getDropDownText("Feedback")),
                PopupMenuItem(
                    value: 4, child: themeStyle.getDropDownText("Set Session"))
              ];
            },
            onSelected: (value) {
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
                taskProvider.setNotification(
                  _datecontroller.text,
                  _timecontroller.text,
                  _secondcontroller.text,
                  _taskcontroller.text,
                  uid,
                );
                if (_taskcontroller.text.isNotEmpty) {
                  add();
                }
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
      backgroundColor: Color.fromARGB(255, 246, 244, 244),
      drawer: Drawer(child: getDrawer(context)),
      body: Container(
        decoration: themeStyle.getBackgroundTheme(),
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
                          Color.fromARGB(153, 217, 221, 224),
                          Color.fromARGB(153, 217, 221, 224)
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
                          print("ready");
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
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 253, 250, 250)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 248, 251, 251)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 250, 247, 247)),
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
                      onDismissed: (dismissDirection) {
                        var autocompleteData = context
                            .read<TaskProvider>()
                            .suggestionList(changeState, uid)
                            .doc(suggestion.toString());
                        autocompleteData.delete();
                        suggestList.remove(suggestion);
                      },
                      child: Container(
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 245, 247, 247),
                          title: Text(
                            suggestion.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
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
                taskQuery: taskProvider.getListviewStream(changeState, uid),
                flag: changeState,
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
