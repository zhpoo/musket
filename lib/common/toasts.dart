import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
  Toasts._();

  static Future<bool> show({
    @required String msg,
    Toast toastLength,
    int timeInSecForIos = 1,
    double fontSize = 16.0,
    ToastGravity gravity,
    Color backgroundColor,
    Color textColor,
  }) {
    if (msg?.isEmpty ?? true) return Future<bool>.value(false);
    if (gravity == null) {
      gravity = Platform.isIOS ? ToastGravity.CENTER : null;
    }
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      timeInSecForIos: timeInSecForIos,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  static Future<bool> cancel() {
    return Fluttertoast.cancel();
  }
}
