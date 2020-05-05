import 'package:flutter/cupertino.dart';
import 'package:musket/common/toasts.dart';

mixin DoubleClickExitAppMixin {
  DateTime _lastPressBackTime;

  String get pressAgainTips;

  int get doubleClickIntervalMillis => 2000;

  Future<bool> onWillPop() async {
    if (_lastPressBackTime == null ||
        DateTime.now().difference(_lastPressBackTime) >
            Duration(milliseconds: doubleClickIntervalMillis)) {
      _lastPressBackTime = DateTime.now();
      Toasts.show(msg: pressAgainTips);
      return false;
    }
    return true;
  }

  Widget willPopScope({Key key, @required Widget child}) {
    return WillPopScope(key: key, onWillPop: onWillPop, child: child);
  }
}
