import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  static double defaultHeight = 46.0;
  static TextStyle defaultTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: Defaults.primaryText,
  );

  final double height;
  final Widget left;
  final List<Widget> right;
  final Widget title;
  final PreferredSizeWidget bottom;
  final bool centerTitle;
  @override
  final Size preferredSize;

  TitleBar({
    this.title,
    this.centerTitle = true,
    this.left,
    this.right,
    this.height,
    this.bottom,
  }) : preferredSize = _preferredSize(height, bottom);

  TitleBar.text({
    String text,
    TextStyle style,
    this.centerTitle = true,
    this.left,
    this.right,
    this.height,
    this.bottom,
  })  : title = Text(text, style: style ?? defaultTitleStyle),
        preferredSize = _preferredSize(height, bottom);

  /// 带返回按钮的 [TitleBar]
  /// [right]和[rightWidgets]如果同时提供，[right]会添加到[rightWidgets]最后
  TitleBar.withBack({
    @required BuildContext context,
    @required String title,
    TextStyle tittleStyle,
    VoidCallback onPressBack,
    PreferredSizeWidget bottom,
    Widget right,
    List<Widget> rightWidgets,
    this.height,
    Size preferredSize,
  })  : this.title = Text(title, style: tittleStyle),
        this.bottom = bottom,
        this.centerTitle = true,
        this.right = (() {
          if (right != null) {
            rightWidgets ??= <Widget>[];
            rightWidgets.add(right);
          }
          return rightWidgets;
        }()),
        this.left = GestureDetector(
          onTap: onPressBack ?? () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios, size: 36),
        ),
        preferredSize = _preferredSize(height, bottom);

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      leading: left,
      title: title,
      centerTitle: centerTitle,
      actions: right,
      elevation: 0,
      bottom: bottom,
    );
    return PreferredSize(child: appBar, preferredSize: preferredSize);
  }

  static Size _preferredSize(double height, PreferredSizeWidget bottom) {
    return Size.fromHeight((height == null ? defaultHeight : height) +
        (bottom == null ? 0 : bottom.preferredSize.height));
  }
}
