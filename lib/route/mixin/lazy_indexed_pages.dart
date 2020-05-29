import 'package:flutter/material.dart';
import 'package:musket/route/mixin/index_mixin.dart';

mixin LazyIndexedPagesMixin<T extends StatefulWidget> on IndexMixin<T> {
  final Map<int, bool> _pageInitStates = {};

  List<Widget> get pages;

  List<Widget> get lazyPages {
    if ((pages?.isEmpty ?? true) || currentIndex < 0 || currentIndex >= pages.length) return pages;
    _pageInitStates[currentIndex] = true;
    final result = <Widget>[];
    for (var i = 0; i < pages.length; i++) {
      if (_pageInitStates[i] == true) {
        result.add(pages[i]);
      } else {
        result.add(Container());
      }
    }
    return result;
  }

  IndexedStack get lazyPagesIndexedStack => lazyIndexedStack();

  IndexedStack lazyIndexedStack({
    Key key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection textDirection,
    StackFit sizing = StackFit.loose,
  }) {
    return IndexedStack(
      key: key,
      index: currentIndex,
      children: lazyPages,
      alignment: alignment,
      textDirection: textDirection,
      sizing: sizing,
    );
  }
}
