import 'package:flutter/material.dart';
import 'package:musket/common/utils.dart';

mixin RefreshIndicatorMixin<T extends StatefulWidget> on State<T> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (autoRefreshOnInit == true) postFrameCallback(callRefresh);
  }

  void callRefresh() {
    refreshKey.currentState?.show();
  }

  Future<void> onRefresh();

  bool get autoRefreshOnInit => true;

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

extension RefreshIndicatorExtension on Widget {
  /// [nestedFillRemaining]设为true将[Widget]嵌套进[CustomScrollView]中[SliverFillRemaining]里，
  /// 这样就可以保证 [Widget] 具有下拉刷新功能。
  /// 解决[RefreshIndicator]的child不是可滚动组件时无法下拉刷新的问题
  RefreshIndicator intoRefreshIndicator(
    RefreshIndicatorMixin indicator, {
    double displacement = 40.0,
    Color color,
    Color backgroundColor,
    String semanticsLabel,
    String semanticsValue,
    ScrollNotificationPredicate notificationPredicate = defaultScrollNotificationPredicate,
    bool nestedFillRemaining = false,
  }) {
    return indicator.refreshIndicator(
      child: nestedFillRemaining == true
          ? CustomScrollView(slivers: <Widget>[SliverFillRemaining(child: this)])
          : this,
      displacement: displacement,
      color: color,
      backgroundColor: backgroundColor,
      notificationPredicate: notificationPredicate,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
    );
  }
}

bool alwaysScrollNotificationPredicate(ScrollNotification notification) {
  return true;
}
