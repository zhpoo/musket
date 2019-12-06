import 'package:flutter/material.dart';

/// 蓝底白字圆角按钮
class Button extends StatelessWidget {
  static TextStyle defaultStyle = const TextStyle(color: Colors.white);

  final String text;
  final VoidCallback onPressed;
  final TextStyle textStyle;
  final Color color;
  final double radius;
  final double height;
  final double elevation;
  final double focusElevation;
  final double highlightElevation;
  final double hoverElevation;
  final double disabledElevation;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  Button(
    this.text,
    this.onPressed, {
    this.textStyle,
    this.color: Colors.blueAccent,
    this.radius: 24.0,
    this.height: 48.0,
    this.elevation: 0.0,
    this.focusElevation: 0.0,
    this.highlightElevation: 0.0,
    this.hoverElevation: 0.0,
    this.disabledElevation: 0.0,
    this.margin: const EdgeInsets.only(top: 16.0),
    this.padding: const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: RaisedButton(
        color: color,
        focusElevation: focusElevation,
        highlightElevation: highlightElevation,
        disabledElevation: disabledElevation,
        hoverElevation: hoverElevation,
        elevation: elevation,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Container(
          alignment: Alignment.center,
          height: height,
          child: Text(text, style: textStyle ?? defaultStyle),
        ),
      ),
    );
  }
}
