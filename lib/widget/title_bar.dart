import 'package:flutter/material.dart';

class TitleBarStyle {
  final Color? backgroundColor;
  final double? height;
  final double? elevation;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;

  const TitleBarStyle({
    this.backgroundColor,
    this.bottom,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.height = 46.0,
    this.elevation = 0,
  }) : assert(height != null && height > 0);
}

class TitleBar extends AppBar {
  static TitleBarStyle? defaultStyle;

  static TitleBarStyle get _defaults => defaultStyle ?? const TitleBarStyle();

  TitleBar({
    Widget? title,
    Widget? left,
    List<Widget>? right,
    PreferredSizeWidget? bottom,
    bool? automaticallyImplyLeading,
    bool? centerTitle,
    double? elevation,
    double? height,
    Color? backgroundColor,
  }) : super(
          title: title,
          leading: left,
          actions: right,
          automaticallyImplyLeading: automaticallyImplyLeading != null || _defaults.automaticallyImplyLeading,
          bottom: bottom ?? _defaults.bottom,
          centerTitle: centerTitle ?? _defaults.centerTitle,
          elevation: elevation ?? _defaults.elevation,
          toolbarHeight: (height ?? _defaults.height ?? 0) + (bottom?.preferredSize.height ?? 0),
          backgroundColor: backgroundColor,
        );

  TitleBar.text({
    @required String? text,
    Widget? left,
    List<Widget>? right,
    PreferredSizeWidget? bottom,
    bool? automaticallyImplyLeading,
    bool? centerTitle,
    double? elevation,
    double? height,
    Color? backgroundColor,
  }) : this(
          title: Text(text ?? ''),
          left: left,
          right: right,
          automaticallyImplyLeading: automaticallyImplyLeading,
          bottom: bottom,
          centerTitle: centerTitle,
          elevation: elevation,
          height: height,
          backgroundColor: backgroundColor,
        );

  TitleBar.withBack({
    String? text,
    Widget backButton = const BackButton(),
    List<Widget>? right,
    PreferredSizeWidget? bottom,
    bool automaticallyImplyLeading = false,
    bool centerTitle = true,
    double? elevation,
    double? height,
    Color? backgroundColor,
  }) : this.text(
          text: text,
          right: right,
          left: backButton,
          automaticallyImplyLeading: automaticallyImplyLeading,
          bottom: bottom,
          centerTitle: centerTitle,
          elevation: elevation,
          height: height,
          backgroundColor: backgroundColor,
        );

  PreferredSizeWidget withDecoration(Decoration decoration) {
    return PreferredSize(
      preferredSize: preferredSize + Offset(decoration.padding?.horizontal ?? 0, decoration.padding?.vertical ?? 0),
      child: Container(child: this, decoration: decoration),
    );
  }
}
