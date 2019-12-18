import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

class Line extends StatelessWidget implements PreferredSizeWidget {
  static Color defaultColor = Defaults.borderColor;
  static double defaultHeight = Defaults.dividerHeight;

  final Color color;
  final double height;
  final EdgeInsetsGeometry margin;

  Line({
    Key key,
    this.color,
    this.height,
    this.margin: const EdgeInsets.symmetric(horizontal: 16.0),
  })  : preferredSize = Size.fromHeight(height ?? defaultHeight),
        super(key: key);

  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? defaultHeight,
      color: color ?? defaultColor,
      margin: margin,
    );
  }
}
