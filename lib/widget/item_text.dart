import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

const _kItemTextMinHeight = 58.0;

class ItemText extends StatelessWidget {
  static TextStyle defaultStyle = TextStyle(fontSize: 16, color: Defaults.primaryText);
  static String rightArrowImage;
  static double defaultIconSize = 32;

  final String icon;
  final String text;
  final VoidCallback onTap;
  final Widget right;
  final double minHeight;
  final bool withRightArrow;
  final TextStyle style;
  final double iconSize;

  const ItemText({
    Key key,
    this.icon,
    this.text,
    this.style,
    this.right,
    this.onTap,
    this.iconSize,
    this.minHeight: _kItemTextMinHeight,
  })  : this.withRightArrow = false,
        super(key: key);

  ItemText.rightArrow({
    Key key,
    this.icon,
    this.text,
    this.style,
    this.onTap,
    this.right,
    this.iconSize,
    this.minHeight: _kItemTextMinHeight,
  })  : this.withRightArrow = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (icon != null) {
      children.add(Container(
        margin: EdgeInsets.only(left: 16),
        child: Image.asset(
          icon,
          width: iconSize ?? defaultIconSize ?? 24,
          height: iconSize ?? defaultIconSize ?? 24,
        ),
      ));
    }
    children.add(Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 16),
        child: Text(text, style: style ?? defaultStyle),
      ),
    ));
    Widget right = this.right;
    if (withRightArrow && rightArrowImage != null) {
      right ??= Image.asset(rightArrowImage, width: 8.0, height: 14);
    }
    if (right != null) {
      children.add(right);
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(16).copyWith(left: 0),
        child: Row(children: children),
      ),
    );
  }
}