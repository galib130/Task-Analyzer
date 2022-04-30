import 'package:flutter/material.dart';

Future<void> createAlertDialog(
  BuildContext context,
  TextEditingController _namecontroller,
  TextEditingController _datecontroller,
  TextEditingController _timecontroller,
  TextEditingController _descriptioncontroller,
  Function _selectDate,
  Function _selectTime,
) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Details"),
            backgroundColor: Colors.cyan,
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
                      _selectDate(context);
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

                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  ),
                ],
              ),
            ));
      });
}
