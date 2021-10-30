import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'TestApp.dart';
import '../main.dart';
import 'ListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../authentication/firebase.dart';
import '../authentication/open.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../authentication/backendservice.dart';
import '../notification/notification.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Alertdialogue.dart';

 List<String> textadd1 =<String>['S/W Lab','Maths'];
final firebaseinstance=FirebaseFirestore.instance;
var today = new DateTime.now();
var addwithtoday= new DateTime.now();
var change_state=0;
FirebaseAuth auth= FirebaseAuth.instance;

class TestAppState extends State<TestApp>{
  String uid =auth.currentUser!.uid;
  var date_picked=1;
  var time_picked=1;
  var date_difference= 0;
  var time_difference=0;

  var addquest=0;
  var addquest1=0;
  var flagofflist=0;
  var quest = 0;
  TextEditingController _taskcontroller = TextEditingController();
  TextEditingController _timecontroller= TextEditingController();
  TextEditingController _datecontroller= TextEditingController();
  TextEditingController _secondcontroller= TextEditingController();
  TextEditingController _descriptioncontroller= TextEditingController();

  String Task='';
  DateTime currentDate =DateTime.now();
  DateTime pickedDate =DateTime.now();
  DateTime compareDate =DateTime.now();
  DateTime totalDate= DateTime.now().subtract(Duration(seconds: 2));
  TimeOfDay time= TimeOfDay.now();
  TimeOfDay pickedTime= TimeOfDay.now();
  int  difference = 0;
  static const routename ='/profile';




  //call to add complete task and then delete the task
  void checkbox(String documnent,bool? value, DocumentSnapshot documentSnapshot) async{
   CollectionReference quadrant1  = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Mytask');
      CollectionReference quadrant2 = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Quadrant2');
      CollectionReference completed_quadrant1= FirebaseFirestore.instance.collection('Users').doc(uid).collection('Quadrant1_Complete');
      CollectionReference completed_quadrant2= FirebaseFirestore.instance.collection('Users').doc(uid).collection('Quadrant2_Complete');
      DateTime currentDate =DateTime.now();
      Timestamp time= Timestamp.fromDate(currentDate);
      DocumentReference session=FirebaseFirestore.instance.collection("Users").doc(uid).collection("session_time").doc("time");
      DocumentReference collectquadrant2_session = FirebaseFirestore.instance.collection('Users').doc(uid).collection("session").doc('Quadrant2');
      DocumentReference collectquadrant1_session =  FirebaseFirestore.instance.collection('Users').doc(uid).collection("session").doc('Quadrant1');
      DocumentReference avg_q1_document=  FirebaseFirestore.instance.collection('Users').doc(uid).collection("average_session").doc('Quadrant1');
      DocumentReference avg_q2_document= FirebaseFirestore.instance.collection('Users').doc(uid).collection("average_session").doc('Quadrant2');

      var documentdata=await session.get();
      var documentuser=documentdata.data() as Map;




      if(change_state==0)

       { documentSnapshot.reference.update({"ticked":value});



       if(documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now()))>0 && change_state==0){
         collectquadrant1_session.update({"Name": FieldValue.increment(3)});

         completed_quadrant1.doc(documnent).set(
             {"Name":documnent, "Timestamp":time, "ticked":false} 
         );
       avg_q1_document.update({"Name": FieldValue.increment(3)});

       }

       }

      else{
       documentSnapshot.reference.update({"ticked":value});

       if(documentuser['time'].compareTo(Timestamp.fromDate(DateTime.now()))>0 && change_state==1){
         collectquadrant2_session.update({"Name":FieldValue.increment(3)});
         completed_quadrant2.doc(documnent).set(
             {"Name":documnent, "Timestamp":time, "ticked":false}
         );
         avg_q2_document.update({"Name": FieldValue.increment(3)});
       }
      }


      Future.delayed(const Duration(milliseconds: 300), () {
        documentSnapshot.reference.delete();

      });
  }




  Widget build(BuildContext context) {
    final Stream <QuerySnapshot> users=FirebaseFirestore.instance.collection('Users').doc(uid).collection('Mytask').orderBy('Timestamp').snapshots(includeMetadataChanges: true);
    final Stream <QuerySnapshot> quadrant2=FirebaseFirestore.instance.collection('Users').doc(uid).collection('Quadrant2').orderBy('Timestamp').snapshots(includeMetadataChanges: true);
    var quadrant1_complete = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Quadrant1_Complete');
    var quadrant2_complete = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Quadrant2_Complete');
    DocumentReference set_date_time=  FirebaseFirestore.instance.collection('Users').doc(uid).collection('date and time ').
    doc('date and time set');
    final suggestList=[];
    //call suggestlist
    setState(() {
  suggestList.clear();
  if(change_state==0) {
    quadrant1_complete.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        suggestList.add(doc.id.toString());
        // print(doc.id);
      });
    });
  }
  else{
    quadrant2_complete.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        suggestList.add(doc.id.toString());
        // print(doc.id);
      });
    });
  }
});


    //call autocomplete list
    Future <List<dynamic>> suggestionList(String query) async{
      final lastlist=[];

      suggestList.forEach((element) {
        if(element.contains(query))
          lastlist.add(element);
      });
      

      return lastlist;
    }
    //Function to add data to backend
    Future<void> Add_Data_to_Backend(String? task, int flag) async{
      if(task!='') {

        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = auth.currentUser!.uid.toString();
        DateTime currentDate = DateTime.now();
        Timestamp time = Timestamp.fromDate(currentDate);
        CollectionReference users = FirebaseFirestore.instance.collection('Users')
            .doc(uid).collection('Mytask');

        CollectionReference quadrant2 = FirebaseFirestore.instance.collection(
            'Users').doc(uid).collection('Quadrant2');
        DocumentReference session = FirebaseFirestore.instance.collection(
            "Users").doc(uid).collection("session_time").doc("time");
        DocumentReference collectquadrant2 = FirebaseFirestore.instance
            .collection('Users').doc(uid).collection("session").doc(
            'Quadrant2');
        DocumentReference collectquadrant1 = FirebaseFirestore.instance
            .collection('Users').doc(uid).collection("session").doc(
            'Quadrant1');
        DocumentReference avg_q1_document= FirebaseFirestore.instance.collection('Users').doc(uid).collection("average_session").doc('Quadrant1');
        DocumentReference avg_q2_document= FirebaseFirestore.instance.collection('Users').doc(uid).collection("average_session").doc('Quadrant2');


        // set_date_time.set({"notification id": FieldValue.increment(1)},SetOptions(merge: true));
        // var get_date_time_data = await set_date_time.get();
        // var date_time_data = get_date_time_data.data() as Map;
        if (flag == 0) {
          print(task);
          print(_taskcontroller.text);
          users.doc().set({"Name": task, "Timestamp": time, "difference":time_difference+date_difference, "ticked": false,"setTime": _datecontroller.text+'    '+_timecontroller.text , "displayName": _taskcontroller.text,
            "notification id": _datecontroller.text.trim()+_timecontroller.text.trim()+_secondcontroller.text.trim(),
            "description":_descriptioncontroller.text.trim(),
            "date": _datecontroller.text.trim(),
            "time":_timecontroller.text.trim(),


          },
              SetOptions(merge: true));
        }
        else {
          quadrant2.doc().set({
            "Name": task,
            "Timestamp": time,
            "ticked": false,
            "setTime": _datecontroller.text+'    '+_timecontroller.text,
            "displayName": _taskcontroller.text,
            "difference": time_difference+date_difference,
            "notification id":_datecontroller.text.trim()+_timecontroller.text.trim()+_secondcontroller.text.trim(),
            "description":_descriptioncontroller.text.trim(),
            "date": _datecontroller.text.trim(),
            "time":_timecontroller.text.trim(),

          }, SetOptions(merge: true));
        }

        var documentdata = await session.get();

        var documentuser = documentdata.data() as Map;
        //var q1_doc=q1_snapshot.data() as Map;
        //var q2_doc=q2_snapshot.data() as Map;

        //time=documentuser['time'];
        if (flag == 0) {
          //addsessiontime(time, session,task)  ; // adds the session time to compare with current time
          if (documentuser['time'].compareTo(
              Timestamp.fromDate(DateTime.now())) > 0 && change_state == 0) {
            collectquadrant1.update(
                {"Name": FieldValue.increment(-1), "color": '0xFF34c9eb',
                 });
          avg_q1_document.update({
            "Name": FieldValue.increment(-1), "color": '0xFF34c9eb',

          });

          }
          else
            print(time.toDate());
        }
        else {
          if (documentuser['time'].compareTo(
              Timestamp.fromDate(DateTime.now())) > 0 && change_state == 1) {
            collectquadrant2.update(
                {"Name": FieldValue.increment(-1), "color": '0xFFa531e8',
                  });
            avg_q2_document.update({
              "Name": FieldValue.increment(-1),
            });

          }
        }
      }
      else{
      Fluttertoast.showToast(msg: "Please enter a non empty task",backgroundColor: Colors.blue);
      }
      return;

    }
    //Function to set a new session
    void set_session ()  async {
  setState(() {
    DocumentReference session_time= FirebaseFirestore.instance.collection("Users").doc(uid).collection("session_time").doc("time");
    DocumentReference q1_document=  FirebaseFirestore.instance.collection('Users').doc(uid).collection("session").doc('Quadrant1');
    DocumentReference q2_document=  FirebaseFirestore.instance.collection('Users').doc(uid).collection("session").doc('Quadrant2');
    DocumentReference avg_q1_document= FirebaseFirestore.instance.collection('Users').doc(uid).collection("average_session").doc('Quadrant1');
    DocumentReference avg_q2_document= FirebaseFirestore.instance.collection('Users').doc(uid).collection("average_session").doc('Quadrant2');
    addwithtoday=today.add(new Duration(minutes: 1));
    DateTime currentdate=DateTime.now();
    addwithtoday=currentdate.add(new Duration(minutes: 1));
    Timestamp time=Timestamp.fromDate(addwithtoday);

    session_time.set({
      "time":time
    });

    q1_document.set({
      "Name":0,
      "color":'0xFF34c9eb',
      "xaxis":'Active',
      "time":time.toDate().toString(),
    });

    q2_document.set({
      "Name":0,
      "color":'0xFFa531e8',
      "xaxis":'Secondary',
      "time":time.toDate().toString(),
    });

    avg_q1_document.set({
      "Name":FieldValue.increment(0),
      "color":'0xFFa531e8',
      "xaxis":'Active',
      "session": FieldValue.increment(1),

    },SetOptions(merge: true));
    avg_q2_document.set({
      "Name":FieldValue.increment(0),
      "color":'0xFF34c9eb',
      "xaxis":'Secondary',
      "session": FieldValue.increment(1),

    },SetOptions(merge: true));
    Fluttertoast.showToast(msg: "New Session Added",backgroundColor: Colors.blue);

  });
}

    //Function to initially add a task
    void add(){
        if(change_state==0) {           //flag 0 for quadrant 1

          Add_Data_to_Backend(_taskcontroller.text.trim() + _datecontroller.text.trim() + _timecontroller.text.trim(),
              change_state); // calls the function which adds to firebase
        }
        else       //flag1 for quadrant 2
        {
        Add_Data_to_Backend(_taskcontroller.text.trim() + _datecontroller.text.trim() + _timecontroller.text.trim(),change_state);
        }

    }

    //Function to change quadrants
    void change(int state){
      setState(() {
        change_state=state;
      });
    }
    //Function to select date
    Future<Null> _selectDate(BuildContext context) async {
      final pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime.now().subtract(Duration(days: 4)),
          lastDate: DateTime(2022));
      if (pickedDate != null && pickedDate != currentDate)
        setState(() {
          currentDate = pickedDate;
          // _namecontroller.text=  _namecontroller.text+ '\n'+'@' +
          //     currentDate.day.toString()+'-'+ currentDate.month.toString()+'-'+
          //     currentDate.year.toString();
          _datecontroller.clear();
          _datecontroller.text= currentDate.day.toString()+'-'+ currentDate.month.toString()+'-'+
              currentDate.year.toString();

          _secondcontroller.text=DateTime.now().second.toString()+DateTime.now().hour.toString()
          +DateTime.now().minute.toString()+DateTime.now().millisecond.toString()+TimeOfDay.now().period.toString();
          DateTime datenow=DateTime.now();
          date_picked=0;

             date_difference=0;
             if(currentDate.day!=DateTime.now().day) {

               date_difference =  currentDate
                   .difference(datenow)
                   .inSeconds;
               set_date_time.set({"date difference":currentDate
                   .difference(datenow)
                   .inSeconds,

               },SetOptions(merge: true));

               totalDate = totalDate.add(Duration(seconds: date_difference as int));

             }
             else{

               set_date_time.set({"date difference":0

               },SetOptions(merge: true));

             }
          print(date_difference.toString()+'date difference');
          currentDate=DateTime.now().subtract(Duration(days: 3));

        }


        );
    }
    // Function to select time
    Future<Null> _selectTime(BuildContext context) async {
      var temp=TimeOfDay.now();

      final  TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime:  temp);
      if (pickedTime != null && pickedTime != time)
        setState(() {
          time = pickedTime;
          int datenow=TimeOfDay.now().hour*3600+TimeOfDay.now().minute*60;

          _timecontroller.clear();
          if(time.period.toString()== 'DayPeriod.am')
            _timecontroller.text=    time.hour.toString()+':'+time.minute.toString() +'am';
          if(time.period.toString()== 'DayPeriod.pm')
            _timecontroller.text=  time.hour.toString()+':'+time.minute.toString() +'pm';
          time_difference=0;
          print(totalDate);
            time_picked=0;
           // time_difference= difference;

            time_difference=(time.minute*60+time.hour*3600)-datenow;
          _secondcontroller.text=DateTime.now().second.toString()+DateTime.now().hour.toString()
              +DateTime.now().minute.toString()+DateTime.now().millisecond.toString()+TimeOfDay.now().period.toString();
            set_date_time.set({
              "time difference" : (time.minute*60+time.hour*3600)-datenow,
            },SetOptions(merge: true));

             totalDate=totalDate.add(Duration(seconds: time_difference as int));
             //print(difference.toString() + "time");
              print(time_difference.toString()+ 'time difference');

              time=time.replacing(hour: time.hour,minute: time.minute-2 );

        });
    }

    return

         Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.blue,
              title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [change_state==0?Text("Active"):Text("Secondary"),

              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(

                  onPressed: (){

                   setState(() {
                     context.read<FlutterFireAuthService>().signOut();
                     //Navigator.of(context).pop();
                     Navigator.of(context)
                         .pushNamedAndRemoveUntil('/openview', (Route<dynamic> route) => false);

                   });

                  },child: Text('Sign Out'),
                ),
              ),



              ],)
          ),
          backgroundColor: Colors.black,
          drawer: Drawer(

            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                 Positioned(
                     top: 80,
                     left: 50,
                     right: 50,
                     child:
                    ElevatedButton(
                   onPressed: (){  //ADD button
                     change(0);
                     Navigator.of(context)
                         .pushNamedAndRemoveUntil('/profile', (Route<dynamic> route) => false);
                     }, child: Text('Active'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.black
                      ),
                 )),
                  Positioned(
                      top: 160,
                      left: 50,
                      right: 50,
                      child:
                      ElevatedButton(onPressed: (){  //ADD button
                        change(1);
                        //print(textadd[addquest-1]);
                        print(change_state);
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/profile', (Route<dynamic> route) => false);
                       // Navigator.of(context).pop();
                      },
                        child: Text('Secondary'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.black
                        ),
                      )
                  ),
                  Positioned(
                      top: 240,
                      left: 50,
                      right: 50,
                      child:  ElevatedButton(

                        onPressed: (){

                          setState(() {
                            uid=auth.currentUser!.uid;
                            set_session();
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/profile', (Route<dynamic> route) => false);
                          });

                        },child: Text('Set Session'),
                      style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                       onPrimary: Colors.black
                      ),
                      ),


                  ),

                  Positioned(
                    top: 320,
                    left: 50,
                    right: 50,
                    child:
                  ElevatedButton(onPressed:() {
                    Navigator.of(context)
                        .pushNamed('/chart');
                  },child: Text('Session Summary'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.black
                    ),
                  ),
                  ),
                  Positioned(
                    top: 400,
                    left: 50,
                    right: 50,
                    child:
                    ElevatedButton(onPressed:() {
                      Navigator.of(context)
                          .pushNamed('/average_chart');
                    },child: Text('Efficiency'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.black
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          body:
                Container(
                  decoration:

                  BoxDecoration(
                      image:  DecorationImage(image: new AssetImage('assets/gradient.png'),fit: BoxFit.cover)
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(

                                style: ElevatedButton.styleFrom(
                                  primary: Colors.cyan,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),),
                                onPressed: ()async{
                                  var get_date_time_data = await set_date_time.get();
                                  var date_time_data = get_date_time_data.data() as Map;
//ADD button
                                  if(_taskcontroller.text.isNotEmpty)
                               {
                                  setState(() {
                                  add();
                                  print(difference.toString() + 'difference');



                                    if(date_difference!=0|| time_difference!=0) {

                                      difference=date_difference+time_difference;

                                      NotificationApi.showScheduledNotification(
                                          id: ( _datecontroller.text.trim() + _timecontroller.text.trim()+_secondcontroller.text
                                              .trim()).hashCode,
                                          title: _taskcontroller.text,
                                          body: 'Hey you added this task',
                                          scheduledDate: DateTime.now().add(
                                              Duration(seconds: (date_time_data['date difference']+date_time_data['time difference']))));

                                      totalDate=compareDate;
                                      date_difference=0;
                                      time_difference=0;

                                      print(date_picked);
                                      difference=0;


                                    }
                                    else{
                                      print('not notifying');
                                    }  }); }
                                    set_date_time.set({
                                      "date difference" : 0,
                                      "time difference": 0,

                                    });
                                    _datecontroller.clear();
                                    _timecontroller.clear();
                                    _taskcontroller.clear();
                                    _secondcontroller.clear();
                                    _descriptioncontroller.clear();



                                },
                                child: Text('Set Notification',style: TextStyle(
                                  color: Colors.black
                                ),),
                              ),
                            SizedBox(width: 20,),
                            //For setting up notification
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.cyan,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),

                                  ),),

                                onPressed: (){
                              createAlertDialog(context,_taskcontroller, _datecontroller,
                                  _timecontroller,_descriptioncontroller,  _selectDate,_selectTime);
                            }, child: Text('Detailed Task',style: TextStyle(
                              color: Colors.black
                            ),),),//For Detail view
                          ],
                        ),

                        //Type Input Field
                        TypeAheadField(
                          //cursorHeight: 2,
                          textFieldConfiguration: TextFieldConfiguration(
                            autofocus: false,
                            cursorColor: Colors.black ,
                            controller: _taskcontroller,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "Items",
                              filled: true,
                              fillColor: Colors.cyan,
                              suffixIcon: IconButton(
                                color: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                                onPressed: () {
                                  add();
                                  _taskcontroller.clear();
                                  _timecontroller.clear();
                                  _datecontroller.clear();
                                  _secondcontroller.clear();
                                  _descriptioncontroller.clear();

                                },
                                icon: Icon(Icons.add_box_rounded,),
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
                          suggestionsCallback: (pattern)async{
                            return await suggestionList(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return Container(
                              child: ListTile(
                                tileColor: Colors.cyan,
                                title: Text(suggestion.toString()),

                              ),

                            ) ;
                          },
                          onSuggestionSelected: (suggestion){
                            _taskcontroller.text= suggestion.toString() ;
                          },
                          hideOnLoading: true,

                        ) ,

                        SizedBox(height: 10,child: Container(),),


                        //See list button depending on state
                        if(change_state==0)
                        // Listview for quadrant 1
                          AddList_State(firebasequery: users,flag: change_state,checkbox: checkbox,
                            set_date: _selectDate, set_time: _selectTime, date_controller: _datecontroller,
                            time_controller: _timecontroller,
                            color: Colors.blue


                          )
                        else
                        //Listview for quadrant 2
                          AddList_State(firebasequery: quadrant2,flag: change_state,
                            checkbox: checkbox,set_date: _selectDate, set_time: _selectTime,
                            date_controller: _datecontroller,
                            time_controller: _timecontroller,
                            color: Colors.yellow
                          )

                      ]),
                ),
         );
  }
}