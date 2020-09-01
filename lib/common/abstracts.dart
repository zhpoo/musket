import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musket/route/mixin/bottom_navigation_bar_mixin.dart';
import 'package:musket/route/mixin/double_click_exit_app.dart';
import 'package:musket/route/mixin/index_mixin.dart';
import 'package:musket/route/mixin/lazy_indexed_pages.dart';
import 'package:musket/route/mixin/safe_state.dart';

abstract class UpdatableValueNotifier<T> extends ValueNotifier<T> {
  UpdatableValueNotifier() : super(null);
  bool _isUpdating = false;
  final List<Completer<bool>> _completers = [];

  /// 检查[value]是否存在，如果为 null，则调用 [update] 方法更新[value],如果仍然为 null，则判定值不存在
  @Deprecated('use required() method instead')
  Future<bool> get require async {
    return required(forceUpdate: false);
  }

  /// 检查[value]是否存在，如果为 null，则调用 [update] 方法更新[value],如果仍然为 null，则判定值不存在
  Future<bool> required({bool forceUpdate = false}) async {
    if (value != null && forceUpdate != true) return true;
    if (_isUpdating) {
      var c = Completer<bool>();
      _completers.add(c);
      return c.future;
    }
    _isUpdating = true;
    await update();
    bool exist = value != null;
    if (!exist && _completers.isNotEmpty) {
      await update();
      exist = value != null;
    }
    _isUpdating = false;
    if (_completers.isNotEmpty) {
      _completers.forEach((e) => e.complete(exist));
      _completers.clear();
    }
    return exist;
  }

  /// 实现该方法并更新[value]
  @protected
  Future<void> update();
}

/// 带有[BottomNavigationBar] 和懒加载 [IndexedStack] body，Android 双击返回退出应用
abstract class BaseMainPageSate<T extends StatefulWidget> extends SafeState<T>
    with IndexMixin, LazyIndexedPagesMixin, BottomNavigationBarMixin, DoubleClickExitAppMixin {
  @override
  Widget build(BuildContext context) {
    return willPopScope(
      child: Scaffold(
        body: lazyPagesIndexedStack,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
