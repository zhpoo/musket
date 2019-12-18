import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  static TextStyle defaultStyle = const TextStyle();

  final String text;
  final Color color;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback onPress;
  final TextStyle style;
  final AlignmentGeometry alignment;

  TextButton({
    this.text,
    TextStyle style,
    this.color,
    this.onPress,
    this.alignment = Alignment.center,
    this.backgroundColor = Colors.white,
    this.padding,
    this.margin,
    double fontSize = 14.0,
  }) : this.style = style ?? defaultStyle.copyWith(fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: alignment,
        margin: margin,
        padding: padding,
        color: backgroundColor,
        child: Text(text, style: style),
      ),
    );
  }
}
