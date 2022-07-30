import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proda/Models/FirebaseCommands.dart';
import 'package:proda/Providers/TaskProvider.dart';
import 'package:proda/Themes.dart';
import 'package:provider/src/provider.dart';

class CompletedListView extends StatelessWidget {
  List items = [];
  var firebaseCommand = FirebaseCommands();
  TaskProvider taskProvider = TaskProvider();
  static const routename = '/completed';
  var themeStyle = ThemeStyles();
  FirebaseAuth auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeStyle.ShadowDrawerButtonColor,
        title: Container(
          child: Text("Completed List"),
        ),
      ),
      body: Column(
        children: [
          Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: taskProvider
                      .getCompletedListStream(auth.currentUser!.uid),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text("Loading");
                    } else {
                      items.add(snapshot.data!.docs);
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<dynamic, dynamic> documentSnapshot =
                                snapshot.data!.docs[index].data()
                                    as Map<dynamic, dynamic>;

                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        themeStyle.ListViewColorPrimaryFirst,
                                        themeStyle.ListViewColorPrimaryFirst,
                                      ])),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 30.0),
                                title: Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Task: ' +
                                              documentSnapshot['Name']
                                                      ['displayName']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: themeStyle
                                                  .OnPrimaryDrawerButtonColor),
                                        ),
                                        Text(
                                          'Description: ' +
                                              documentSnapshot['Name']
                                                      ['description']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: themeStyle
                                                  .OnPrimaryDrawerButtonColor),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }))
        ],
      ),
    );
  }
}
