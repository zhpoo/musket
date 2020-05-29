import 'package:flutter/material.dart';
import 'package:musket/extensions/widget_extension.dart';

class IconText extends StatelessWidget {
  final bool active;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  final String text;
  final String icon;
  final String activeIcon;

  /// [text] 和 [icon]/[activeIcon] 之间的间距
  final double spacing;
  final double iconSize;
  final TextStyle textStyle;
  final Color activeColor;
  final Color color;

  const IconText({
    Key key,
    @required this.icon,
    this.active = false,
    String activeIcon,
    this.padding,
    this.onTap,
    this.text,
    this.textStyle = const TextStyle(height: 1.4, fontSize: 10),
    this.color,
    this.activeColor,
    this.spacing = 1,
    this.iconSize = 24,
  })  : activeIcon = activeIcon ?? icon,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Image.asset(
        active == true ? activeIcon : icon,
        width: iconSize,
        height: iconSize,
      ),
    ];
    if (text?.isNotEmpty == true) {
      children.add(Container(
        margin: EdgeInsets.only(top: spacing ?? 0),
        child: Text(text, style: textStyle?.copyWith(color: active == true ? activeColor : color)),
      ));
    }

    return Container(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    ).intoOnTap(onTap);
  }
}
