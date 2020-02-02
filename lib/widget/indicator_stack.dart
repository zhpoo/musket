import 'package:flutter/material.dart';

class IndicatorStack extends StatelessWidget {
  final bool showIndicator;
  final Widget child;
  final Widget indicator;
  final EdgeInsetsGeometry indicatorMargin;
  final AlignmentGeometry indicatorAlignment;

  const IndicatorStack({
    Key key,
    this.child,
    this.showIndicator: false,
    this.indicatorAlignment: Alignment.topCenter,
    this.indicatorMargin: const EdgeInsets.only(top: 36),
    this.indicator: const RefreshProgressIndicator(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (child != null) {
      children.add(child);
    }
    if (showIndicator ?? false) {
      children.add(Container(
        alignment: indicatorAlignment,
        margin: indicatorMargin,
        child: indicator,
      ));
    }
    return Stack(children: children);
  }
}
