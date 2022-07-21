import 'package:flutter/material.dart';
import 'package:proda/Themes.dart';
import 'package:proda/Providers/ChangeState.dart';
import 'package:provider/provider.dart';

var themeStyle = ThemeStyles();
Drawer? getDrawer(BuildContext context) {
  return Drawer(
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
                style: themeStyle.getDrawerStyle(),
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

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/profile', (Route<dynamic> route) => false);
                  // Navigator.of(context).pop();
                },
                child: Text(
                  'Secondary',
                  style: TextStyle(fontSize: 20),
                ),
                style: themeStyle.getDrawerStyle(),
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
              style: themeStyle.getDrawerStyle(),
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
              style: themeStyle.getDrawerStyle(),
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
                style: themeStyle.getDrawerStyle(),
              )),
          Positioned(
              top: 580,
              left: 50,
              right: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/heartbeat');
                },
                child: Text(
                  "HeartBeat",
                  style: TextStyle(fontSize: 20),
                ),
                style: themeStyle.getDrawerStyle(),
              ))
        ],
      ),
    ),
  );
}
