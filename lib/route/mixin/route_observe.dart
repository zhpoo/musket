import 'package:flutter/material.dart';

/// 路由监听器
/// 在MaterialApp中加入 navigatorObservers 中，
/// 然后在需要监听的页面的State中继承(混入) [RouteLifecycle]
/// 按需重写 [onResume]和[onPause] 实现监听
RouteObserver? _routeObserver;

RouteObserver get routeObserver {
  _routeObserver ??= RouteObserver();
  return _routeObserver!;
}

/// 路由页面监听
/// [didPopNext] 下一个路由被退出，当前路由可见
/// [didPush]  当前路由被推入路由栈
/// [didPop] 当前路由退出
/// [didPushNext] 下一个路由被推入路由栈，当前路由不可见
mixin RouteLifecycle<T extends StatefulWidget> on State<T>, WidgetsBindingObserver, RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    } else if (state == AppLifecycleState.paused) {
      onPause();
    }
  }

  @override
  void didPopNext() {
    onResume();
  }

  @override
  void didPush() {
    onResume();
  }

  @override
  void didPushNext() {
    onPause();
  }

  @override
  void didPop() {
    onPause();
  }

  void onResume() {}

  void onPause() {}
}
