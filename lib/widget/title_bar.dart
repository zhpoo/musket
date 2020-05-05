import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  static double defaultHeight = 46.0;
  static String backAsset;
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
  final bool automaticallyImplyLeading;
  @override
  final Size preferredSize;
  final Color backgroundColor;

  TitleBar({
    this.title,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.backgroundColor,
    this.left,
    this.right,
    this.height,
    this.bottom,
  }) : preferredSize = _preferredSize(height, bottom);

  TitleBar.text({
    String text,
    TextStyle style,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.backgroundColor,
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
    String backImage,
    TextStyle tittleStyle,
    VoidCallback onPressBack,
    PreferredSizeWidget bottom,
    Widget right,
    double backSize: 36,
    List<Widget> rightWidgets,
    this.height,
    this.backgroundColor,
  })  : this.title = Text(title, style: tittleStyle ?? defaultTitleStyle),
        this.bottom = bottom,
        this.centerTitle = true,
        this.automaticallyImplyLeading = false,
        this.right = (() {
          if (right != null) {
            rightWidgets ??= <Widget>[];
            rightWidgets.add(right);
          }
          return rightWidgets;
        }()),
        this.left = GestureDetector(
          onTap: onPressBack ?? () => Navigator.of(context).pop(),
          child: backImage == null && backAsset == null
              ? Icon(Icons.arrow_back_ios, size: backSize)
              : Image.asset(backImage ?? backAsset, width: backSize, height: backSize),
        ),
        preferredSize = _preferredSize(height, bottom);

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: left,
      title: title,
      centerTitle: centerTitle,
      actions: right,
      elevation: 0,
      bottom: bottom,
      backgroundColor: backgroundColor,
    );
    return appBar;
  }

  static Size _preferredSize(double height, PreferredSizeWidget bottom) {
    return Size.fromHeight((height == null ? defaultHeight : height) +
        (bottom == null ? 0 : bottom.preferredSize.height));
  }
}
