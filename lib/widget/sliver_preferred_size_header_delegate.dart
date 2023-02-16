import 'package:flutter/material.dart';

class SliverPreferredSizeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  final Color? backgroundColor;
  final double elevation;

  const SliverPreferredSizeHeaderDelegate({required this.child, this.backgroundColor, this.elevation = 0});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    Widget result = child;
    if (backgroundColor != null) {
      result = Container(
        color: backgroundColor,
        child: child,
      );
    }
    if (elevation > 0) {
      result = Material(
        color: Colors.transparent,
        elevation: elevation,
        child: result,
      );
    }
    return result;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPreferredSizeHeaderDelegate oldDelegate) {
    return false;
  }
}
