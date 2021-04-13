import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastStyle {
  final Color backgroundColor;
  final Color textColor;
  final ToastGravity gravity;
  final int timeInSecForIosWeb;
  final double fontSize;

  ToastStyle({
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    ToastGravity gravity,
    this.timeInSecForIosWeb = 2,
    this.fontSize = 16.0,
  }) : gravity = gravity ?? (!kIsWeb && Platform.isIOS ? ToastGravity.CENTER : null);
}

class Toasts {
  static ToastStyle defaultStyle = ToastStyle();

  Toasts._();

  static Future<bool> show({
    @required String msg,
    bool longToast = false,
    bool center,
    int timeInSecForIos,
    double fontSize,
    Color backgroundColor,
    Color textColor,
  }) {
    if (msg?.isEmpty ?? true) return Future<bool>.value(false);
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: longToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      timeInSecForIosWeb: timeInSecForIos ?? defaultStyle?.timeInSecForIosWeb,
      gravity: center == true ? ToastGravity.CENTER : defaultStyle?.gravity,
      backgroundColor: backgroundColor ?? defaultStyle?.backgroundColor,
      textColor: textColor ?? defaultStyle?.textColor,
    );
  }

  static cancel() {
    return Fluttertoast.cancel();
  }
}
