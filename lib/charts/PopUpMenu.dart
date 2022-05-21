import 'package:flutter/material.dart';
import 'package:proda/Analysis%20Functions/Analysis.dart';
import 'package:proda/Themes.dart';
import 'package:proda/home%20screen/FeedbackDialog.dart';

var themestyle = ThemeStyles();
PopupMenuButton GetPopUpMenu(BuildContext context, SessionStatus status) {
  return PopupMenuButton(
    color: themestyle.PrimaryDrawerButtonColor,
    itemBuilder: (context) {
      return [
        PopupMenuItem(value: 1, child: themestyle.getDropDownText("Feedback"))
      ];
    },
    onSelected: (value) async {
      Createfeedback(context, status);
    },
  );
}
