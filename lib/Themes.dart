import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeStyles {
  Color PrimaryDrawerButtonColor = Color.fromARGB(157, 10, 2, 49);
  Color OnPrimaryDrawerButtonColor = Color.fromARGB(255, 247, 244, 244);
  Color ShadowDrawerButtonColor = Color.fromARGB(255, 20, 2, 61);
  double Drawerelevation = 10;
  Color ListViewColorPrimaryFirst = Color.fromARGB(178, 4, 70, 100);
  Color ListViewColorSecondaryFirst = Color.fromARGB(207, 99, 127, 255);
  Color ListViewColorPrimarySecond = Color.fromARGB(178, 4, 70, 100);
  Color ListViewColorSecondarySecond = Color.fromARGB(207, 99, 127, 255);
  ButtonStyle? DrawerStyle;

  ButtonStyle? getDrawerStyle() {
    ButtonStyle DrawerStyle = ElevatedButton.styleFrom(
        primary: PrimaryDrawerButtonColor,
        onPrimary: OnPrimaryDrawerButtonColor,
        shadowColor: ShadowDrawerButtonColor,
        elevation: Drawerelevation,
        padding: EdgeInsets.all(25));

    return DrawerStyle;
  }

  ButtonStyle? AppButtonStyle;

  ButtonStyle? getAppButtonStyle() {
    AppButtonStyle =
        ElevatedButton.styleFrom(primary: PrimaryDrawerButtonColor);
    return AppButtonStyle;
  }

  BoxDecoration? getBackgroundTheme() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        //image:  DecorationImage(image: new AssetImage('assets/listtile.jpg'),fit: BoxFit.cover)
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
            colors: [
              Color.fromARGB(255, 11, 63, 122),
              Color.fromARGB(255, 12, 7, 95),
            ]));
  }

  TextStyle? getFeedbackLabelTextStyle() {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  }

  TextStyle? getFeedbackSecondaryTextStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: Color.fromARGB(255, 42, 3, 109),
    );
  }

  TextStyle? getFeedbackWorkLoadTextStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: Color.fromARGB(255, 42, 9, 230),
    );
  }

  Text? getDropDownText(String textcontent) {
    return Text(
      textcontent,
      style: TextStyle(color: Colors.white),
    );
  }

  BoxDecoration? getBackgroundBoxDecoration() {
    var ThemeStyle = ThemeStyles();
    return BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
            colors: [
              ThemeStyle.ListViewColorPrimaryFirst,
              ThemeStyle.ListViewColorSecondaryFirst
            ]));
  }
}
