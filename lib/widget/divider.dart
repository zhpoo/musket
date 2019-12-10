import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

class Line extends StatelessWidget {
  static Color defaultColor = Defaults.borderColor;
  static double defaultHeight = Defaults.dividerHeight;

  final Color color;
  final double height;
  final EdgeInsetsGeometry margin;

  Line({
    this.color,
    this.height,
    this.margin: const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: Container(
        height: height ?? defaultHeight,
        color: color ?? defaultColor,
        margin: margin,
      ),
      preferredSize: Size.fromHeight(height),
    );
  }
}
