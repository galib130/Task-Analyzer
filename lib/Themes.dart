import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeStyles {
  Color PrimaryDrawerButtonColor = Color.fromARGB(255, 10, 2, 49);
  Color OnPrimaryDrawerButtonColor = Color.fromARGB(255, 247, 244, 244);
  Color ShadowDrawerButtonColor = Color.fromARGB(255, 20, 2, 61);
  double Drawerelevation = 10;
  Color ListViewColorPrimaryFirst = Color.fromARGB(235, 3, 14, 117);
  Color ListViewColorSecondaryFirst = Color.fromARGB(207, 99, 127, 255);
  Color ListViewColorPrimarySecond = Color.fromARGB(235, 3, 14, 117);
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

  ThemeStyles();
}
