import 'package:flutter/material.dart';

class Arrow {
  final String asset;
  final double width;
  final double height;

  Arrow({@required this.asset, @required this.width, @required this.height});
}

class RightArrowItem extends StatelessWidget {
  static Arrow defaultArrow;

  final Widget content;
  final String icon;
  final VoidCallback onTap;
  final Color background;
  final double iconHeight;
  final double iconWidth;
  final Arrow arrow;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  /// 带右箭头的 Widget
  RightArrowItem({
    this.content,
    this.icon,
    this.onTap,
    this.margin,
    this.padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.arrow,
    this.background,
    this.iconHeight: 24,
    this.iconWidth: 24,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(Container(
        margin: const EdgeInsets.only(right: 16),
        child: Image.asset(icon, width: iconWidth, height: iconHeight),
      ));
    }
    children.add(Expanded(child: content));
    final arrow = this.arrow ?? defaultArrow;
    children.add(arrow != null
        ? Image.asset(arrow.asset, width: arrow.width, height: arrow.height)
        : Icon(Icons.arrow_forward_ios, size: 14));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        color: background,
        child: Row(children: children),
      ),
    );
  }
}
