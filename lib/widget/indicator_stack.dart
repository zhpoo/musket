import 'package:flutter/material.dart';

class IndicatorStack extends StatelessWidget {
  final bool showIndicator;
  final Widget child;

  final indicatorMargin;

  const IndicatorStack({
    Key key,
    this.child,
    this.showIndicator: false,
    this.indicatorMargin: const EdgeInsets.only(top: 36),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        showIndicator ?? false
            ? Container(
                alignment: Alignment.topCenter,
                margin: indicatorMargin,
                child: RefreshProgressIndicator(),
              )
            : Container()
      ],
    );
  }
}
