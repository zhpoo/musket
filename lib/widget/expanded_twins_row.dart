import 'package:flutter/material.dart';
import 'package:musket/extensions/widget_extension.dart';

class ExpandedTwinsRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;
  final CrossAxisAlignment crossAxisAlignment;

  const ExpandedTwinsRow({
    Key key,
    this.left,
    this.right,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.crossAxisAlignment,
  })  : assert(left != null),
        assert(right != null),
        assert(leftFlex != null && leftFlex > 0),
        assert(rightFlex != null && rightFlex > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.ideographic,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: <Widget>[
        left.intoExpanded(flex: leftFlex),
        right.intoExpanded(flex: rightFlex),
      ],
    );
  }
}
