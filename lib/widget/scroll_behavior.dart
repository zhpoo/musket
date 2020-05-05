import 'package:flutter/material.dart';

/// 结合[ScrollConfiguration]使用，可控制下拉和上拉的阴影效果
class GlowingOverScrollBehavior extends ScrollBehavior {
  final bool showLeading;
  final bool showTrailing;

  const GlowingOverScrollBehavior({
    this.showLeading = true,
    this.showTrailing = true,
  })  : assert(showLeading != null),
        assert(showTrailing != null);

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          child: child,
          showLeading: showLeading,
          showTrailing: showTrailing,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
        );
      default:
        return child;
    }
  }
}
