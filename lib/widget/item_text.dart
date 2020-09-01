import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';
import 'package:musket/extensions/widget_extension.dart';

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
  final double iconWidth;
  final double icoHeight;
  final Color color;
  final EdgeInsetsGeometry padding;

  const ItemText({
    Key key,
    this.icon,
    this.text,
    this.style,
    this.right,
    this.onTap,
    this.iconWidth,
    this.icoHeight,
    this.color,
    this.padding = const EdgeInsets.all(16),
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
    this.iconWidth,
    this.icoHeight,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.minHeight: _kItemTextMinHeight,
  })  : this.withRightArrow = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (icon != null) {
      children.add(Container(
        child: Image.asset(
          icon,
          width: iconWidth ?? defaultIconSize ?? 24,
          height: icoHeight ?? defaultIconSize ?? 24,
        ),
      ));
    }
    children.add(Expanded(
      child: Container(
        margin: EdgeInsets.only(left: icon != null ? 16 : 0),
        child: Text(text, style: style ?? defaultStyle),
      ),
    ));
    List<Widget> rights = [];
    if (this.right != null) {
      rights.add(this.right);
    }
    if (withRightArrow && rightArrowImage != null) {
      rights.add(Image.asset(rightArrowImage, width: 8.0, height: 14));
    }
    if (rights.isNotEmpty) {
      children.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: rights,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: color,
        constraints: BoxConstraints(minHeight: minHeight),
        padding: padding,
        child: Row(children: children, crossAxisAlignment: CrossAxisAlignment.center),
      ),
    );
  }
}
