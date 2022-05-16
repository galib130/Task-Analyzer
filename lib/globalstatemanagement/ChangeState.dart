import 'package:flutter/foundation.dart';

class ChangeState with ChangeNotifier {
  int _flag = 0;
  int get flag => _flag;

  void change_state(int flag) {
    this._flag = flag;
  }
}
