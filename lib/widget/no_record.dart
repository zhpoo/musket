import 'package:flutter/material.dart';

class NoRecord extends StatelessWidget {
  static String defaultText = 'No Record';
  static TextStyle defaultStyle = TextStyle();

  final String text;
  final TextStyle style;

  NoRecord(String text, TextStyle style)
      : this.text = text ?? defaultText,
        this.style = style ?? defaultStyle;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: style));
  }
}
