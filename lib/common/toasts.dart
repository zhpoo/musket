import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
  Toasts._();

  /// Toast 提示，ios 默认在中间显示
  static show({
    @required String msg,
    bool longToast = false,
    bool center,
    int timeInSecForIos = 1,
    double fontSize = 16.0,
    Color backgroundColor,
    Color textColor,
  }) {
    if (msg?.isEmpty ?? true) return Future<bool>.value(false);
    ToastGravity gravity;
    center ??= Platform.isIOS;
    if (center) {
      gravity = ToastGravity.CENTER;
    }
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: longToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      timeInSecForIos: timeInSecForIos,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  static cancel() {
    return Fluttertoast.cancel();
  }
}
