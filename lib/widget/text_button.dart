import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

class TextButton extends StatelessWidget {
  static TextStyle defaultStyle = TextStyle();

  final String text;
  final Color color;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback onPress;
  final TextStyle style;
  final AlignmentGeometry alignment;

  TextButton({
    this.text,
    TextStyle style,
    this.color,
    this.onPress,
    this.alignment,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(Defaults.commonMargin),
    double fontSize = 14.0,
  }) : this.style = style ?? defaultStyle.copyWith(fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: alignment,
        padding: padding,
        color: backgroundColor,
        child: Text(text, style: style),
      ),
    );
  }
}
