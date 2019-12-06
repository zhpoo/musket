import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

class Divider extends StatelessWidget {
  final Color color;
  final double height;
  final EdgeInsetsGeometry margin;

  Divider({
    this.color: Defaults.borderColor,
    this.height: Defaults.dividerHeight,
    this.margin: const EdgeInsets.symmetric(horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: Container(height: height, color: color, margin: margin),
      preferredSize: Size.fromHeight(height),
    );
  }
}
