import 'package:flutter/material.dart';

class TabBarViewData<T> {
  /// Index for TabBarView
  final int index;
  final List<T> items = [];
  int page;
  bool hasMore;
  int limit;

  TabBarViewData({@required this.index, this.hasMore = true, this.page = 0, this.limit = 20});
}
