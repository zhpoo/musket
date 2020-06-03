import 'package:flutter/material.dart';
import 'package:musket/route/mixin/bottom_navigation_bar_mixin.dart';
import 'package:musket/route/mixin/double_click_exit_app.dart';
import 'package:musket/route/mixin/index_mixin.dart';
import 'package:musket/route/mixin/lazy_indexed_pages.dart';
import 'package:musket/route/mixin/safe_state.dart';

abstract class UpdatableValueNotifier<T> extends ValueNotifier<T> {
  UpdatableValueNotifier() : super(null);

  /// 检查[value]是否存在，如果为 null，则调用 [update] 方法更新[value],如果仍然为 null，则判定值不存在
  Future<bool> get require async {
    if (value == null) {
      await update();
      if (value == null) {
        return false;
      }
    }
    return true;
  }

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
