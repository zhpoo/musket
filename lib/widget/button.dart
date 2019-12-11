import 'package:flutter/material.dart';

/// 蓝底白字圆角按钮
class Button extends StatelessWidget {
  static TextStyle defaultStyle = const TextStyle(color: Colors.white);

  final String text;
  final VoidCallback onTap;
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
  final BoxConstraints constraints;
  final AlignmentGeometry alignment;

  const Button({
    Key key,
    @required this.text,
    @required this.onTap,
    this.textStyle,
    this.color: Colors.blueAccent,
    this.radius: 24.0,
    this.height: 48.0,
    this.elevation: 0.0,
    this.focusElevation: 0.0,
    this.highlightElevation: 0.0,
    this.hoverElevation: 0.0,
    this.disabledElevation: 0.0,
    this.margin,
    this.padding,
    this.constraints,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment,
      child: RaisedButton(
        color: color,
        focusElevation: focusElevation,
        highlightElevation: highlightElevation,
        disabledElevation: disabledElevation,
        hoverElevation: hoverElevation,
        elevation: elevation,
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Container(
          alignment: Alignment.center,
          height: height,
          constraints: constraints,
          child: Text(text, style: textStyle ?? defaultStyle),
        ),
      ),
    );
  }
}
