import 'package:flutter/material.dart';
import 'package:musket/common/utils.dart';

class TitleBarStyle {
  final Decoration decoration;
  final Color backgroundColor;
  final double height;
  final double elevation;
  final String backAsset;
  final TextStyle titleStyle;
  final PreferredSizeWidget bottom;

  const TitleBarStyle({
    this.decoration,
    this.backgroundColor,
    this.backAsset,
    this.bottom,
    this.height = 46.0,
    this.elevation = 0,
    this.titleStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
  }) : assert(height != null && height > 0);
}

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  static TitleBarStyle defaultStyle;

  static TitleBarStyle get _defaults => defaultStyle ?? const TitleBarStyle();

  final double height;
  final double elevation;
  final Widget left;
  final List<Widget> right;
  final Widget title;
  final PreferredSizeWidget bottom;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  @override
  final Size preferredSize;
  final Color backgroundColor;
  final Decoration decoration;

  TitleBar({
    this.title,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.backgroundColor,
    this.left,
    this.right,
    this.height,
    this.elevation,
    PreferredSizeWidget bottom,
    this.decoration,
  })  : this.bottom = bottom ?? _defaults.bottom,
        preferredSize = _preferredSize(height, bottom ?? _defaults.bottom);

  TitleBar.text({
    @required String text,
    TextStyle style,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.backgroundColor,
    this.left,
    this.right,
    this.height,
    this.elevation,
    PreferredSizeWidget bottom,
    this.decoration,
  })  : this.bottom = bottom ?? _defaults.bottom,
        title = Text(text, style: style ?? _defaults.titleStyle),
        preferredSize = _preferredSize(height, bottom ?? _defaults.bottom);

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
    this.elevation,
    this.backgroundColor,
    this.decoration,
  })  : this.title = Text(title, style: tittleStyle ?? _defaults.titleStyle),
        this.bottom = bottom ?? _defaults.bottom,
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
          onTap: onPressBack ?? () => defaultOnTapBack(context),
          child: backImage == null && _defaults.backAsset == null
              ? Icon(Icons.arrow_back_ios, size: backSize)
              : Image.asset(backImage ?? _defaults.backAsset, width: backSize, height: backSize),
        ),
        preferredSize = _preferredSize(height, bottom ?? _defaults.bottom);

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: left,
      title: title,
      centerTitle: centerTitle,
      actions: right,
      elevation: elevation ?? _defaults.elevation,
      bottom: bottom,
      backgroundColor: backgroundColor ?? _defaults.backgroundColor,
    );
    return Container(decoration: decoration ?? _defaults.decoration, child: appBar);
  }

  static Size _preferredSize(double height, PreferredSizeWidget bottom) {
    return Size.fromHeight((height ?? _defaults.height) + (bottom?.preferredSize?.height ?? 0));
  }

  static void defaultOnTapBack(BuildContext context) {
    clearFocus(context);
    Navigator.of(context).pop();
  }
}
