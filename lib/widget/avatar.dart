import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final Widget child;

  final Color borderColor;
  final double borderWidth;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CircleWidget({
    Key key,
    this.child,
    this.width,
    this.height,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: PhysicalModel(
        color: Colors.transparent,
        shape: BoxShape.circle,
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
