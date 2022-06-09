import 'package:flutter/material.dart';
import 'package:proda/Models/Task.dart';
import 'dart:async';

import 'package:proda/Providers/TaskProvider.dart';
import 'package:provider/src/provider.dart';

var taskCommand = TaskCommands();
Future<void> createAlertDialog(
    BuildContext context,
    TextEditingController _namecontroller,
    TextEditingController _datecontroller,
    TextEditingController _timecontroller,
    TextEditingController _descriptioncontroller,
    TextEditingController _secondcontroller,
    Function _selectDate,
    Function _selectTime,
    String uid) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Details"),
            backgroundColor: Colors.lightBlue.shade300,
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      //decoration: InputDecoration(hintText: 'Task'),
                      controller: _namecontroller,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(hintText: 'Description'),
                      controller: _descriptioncontroller,
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(hintText: 'Date'),
                      controller: _datecontroller,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // _selectDate(context);
                      context.read<TaskProvider>().selectDate(
                          context, _datecontroller, _secondcontroller, uid);
                    },
                    child: Text('Select Date'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),

                  Expanded(
                    flex: 1,
                    child: TextField(
                      maxLines: 1,
                      readOnly: true,
                      decoration: InputDecoration(hintText: 'Time'),
                      controller: _timecontroller,
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Select Time'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                    onPressed: () {
                      _selectTime(context);
                    },
                  ),

                  //Button to select time

                  ElevatedButton(
                    onPressed: () {
                      //update(update_controller.text,data);
                      //context.read<TextControllers>().printcontroller();
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  ),
                ],
              ),
            ));
      });
}
