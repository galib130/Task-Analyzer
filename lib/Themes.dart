import 'package:flutter/material.dart';

class ThemeStyles {
  Color PrimaryDrawerButtonColor = Color.fromARGB(255, 247, 244, 244);
  Color OnPrimaryDrawerButtonColor = Color.fromARGB(255, 247, 244, 244);
  Color ShadowDrawerButtonColor = Color.fromARGB(255, 247, 244, 244);
  double Drawerelevation = 10;
  Color ListViewColorPrimaryFirst = Color.fromARGB(255, 247, 244, 244);
  Color ListViewColorSecondaryFirst = Color.fromARGB(255, 247, 244, 244);
  Color ListViewColorPrimarySecond = Color.fromARGB(255, 247, 244, 244);
  Color ListViewColorSecondarySecond = Color.fromARGB(255, 247, 244, 244);
  Color popupColor = Color.fromARGB(0, 0, 0, 0);

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
    AppButtonStyle = ElevatedButton.styleFrom(primary: Colors.black);
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
              Color.fromARGB(255, 248, 249, 250),
              Color.fromARGB(255, 247, 246, 250),
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
      style: TextStyle(color: Color.fromARGB(255, 10, 10, 10)),
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
