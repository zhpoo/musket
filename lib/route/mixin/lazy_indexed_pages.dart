import 'package:flutter/cupertino.dart';

mixin LazyIndexedPagesMixin {
  final Map<int, bool> _pageInitStates = {};

  int currentPageIndex = 0;

  List<Widget> get pages;

  List<Widget> get lazyPages {
    if (pages?.isEmpty ?? true) return pages;
    _pageInitStates[currentPageIndex] = true;
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
}
