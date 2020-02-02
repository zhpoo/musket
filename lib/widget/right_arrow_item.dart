import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

class RightArrowItem extends StatelessWidget {
  static TextStyle defaultTextStyle = TextStyle();

  final Widget content;
  final String icon;
  final VoidCallback onPress;
  final bool marginDivider;
  final Color background;
  final double iconHeight;
  final double iconWidth;

  /// 带右箭头的 Widget
  RightArrowItem({
    this.content,
    this.icon,
    this.onPress,
    this.marginDivider = false,
    this.background: Colors.white,
    this.iconHeight: Defaults.iconSize,
    this.iconWidth: Defaults.iconSize,
  });

  /// 可点击的带 icon 的文本 item
  RightArrowItem.text(
    String text, {
    TextStyle textStyle,
    this.onPress,
    this.icon,
    this.background = Colors.white,
    this.marginDivider = true,
    this.iconHeight: Defaults.iconSize,
    this.iconWidth: Defaults.iconSize,
  }) : content = Text(text, style: textStyle ?? defaultTextStyle);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(Container(
        margin: EdgeInsets.only(
          left: marginDivider ? 0 : Defaults.commonMargin,
          right: marginDivider ? Defaults.commonMargin : 0,
        ),
        child: Image.asset(icon, width: iconWidth, height: iconHeight),
      ));
    }
    children.add(Expanded(
      child: Container(
        margin: EdgeInsets.only(left: marginDivider ? 0 : Defaults.commonMargin),
        child: content,
      ),
    ));
    children.add(Container(
      margin: EdgeInsets.only(right: marginDivider ? 0 : Defaults.commonMargin),
      child: Icon(Icons.arrow_forward_ios, size: 24.0),
    ));

    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: marginDivider ? Defaults.commonMargin : 0),
        padding: EdgeInsets.symmetric(vertical: 24.0),
        decoration: BoxDecoration(
          color: background,
          border: Border(
            bottom: BorderSide(
              color: Defaults.borderColor,
              width: Defaults.dividerHeight,
            ),
          ),
        ),
        child: Row(children: children),
      ),
    );
  }
}
