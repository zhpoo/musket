import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musket/common/utils.dart';

mixin RefreshIndicatorMixin<T extends StatefulWidget> on State<T> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (initCallRefresh ?? true) postFrameCallback(callRefresh);
  }

  void callRefresh() {
    refreshKey.currentState?.show();
  }

  Future<void> onRefresh();

  bool get initCallRefresh => true;

  RefreshIndicator refreshIndicator({
    @required Widget child,
    double displacement = 40.0,
    Color color,
    Color backgroundColor,
    ScrollNotificationPredicate notificationPredicate = defaultScrollNotificationPredicate,
    String semanticsLabel,
    String semanticsValue,
  }) {
    assert(child != null);
    assert(onRefresh != null);
    assert(notificationPredicate != null);
    return RefreshIndicator(
      key: refreshKey,
      child: child,
      displacement: displacement,
      color: color,
      backgroundColor: backgroundColor,
      notificationPredicate: notificationPredicate,
      onRefresh: onRefresh,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
    );
  }
}
