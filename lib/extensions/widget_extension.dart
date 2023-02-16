import 'package:flutter/material.dart';

/// 继承于[EdgeInsets]，提供更方便的构造函数
class Edges extends EdgeInsets {
  /// 参数生效优先级:
  /// [top],[right],[bottom],[left]
  /// [horizontal],[vertical]
  /// [all]
  const Edges({
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? horizontal,
    double? vertical,
    double? all,
  }) : super.only(
          top: top ?? vertical ?? all ?? 0.0,
          right: right ?? horizontal ?? all ?? 0.0,
          bottom: bottom ?? vertical ?? all ?? 0.0,
          left: left ?? horizontal ?? all ?? 0.0,
        ); // no instance
}

extension WidgetExtension on Widget {
  Material intoMaterial({
    Key? key,
    MaterialType type = MaterialType.canvas,
    double elevation = 0.0,
    Color? color,
    Color shadowColor = const Color(0xFF000000),
    TextStyle? textStyle,
    BorderRadiusGeometry? borderRadius,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    Clip clipBehavior = Clip.none,
    Duration animationDuration = kThemeChangeDuration,
  }) {
    return Material(
      key: key,
      type: type,
      elevation: elevation,
      color: color,
      shadowColor: shadowColor,
      textStyle: textStyle,
      borderRadius: borderRadius,
      shape: shape,
      borderOnForeground: borderOnForeground,
      clipBehavior: clipBehavior,
      animationDuration: animationDuration,
      child: this,
    );
  }

  Container intoContainer({
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Alignment? alignment,
    Matrix4? transform,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      child: this,
      margin: margin,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      alignment: alignment,
      transform: transform,
      clipBehavior: clipBehavior,
    );
  }

  Expanded intoExpanded({int flex = 1}) {
    return Expanded(child: this, flex: flex);
  }

  GestureDetector intoOnTap(
    GestureTapCallback onTap, {
    HitTestBehavior behavior = HitTestBehavior.translucent,
  }) {
    return GestureDetector(child: this, onTap: onTap, behavior: behavior);
  }

  Visibility intoVisibility({
    Key? key,
    Widget replacement = const SizedBox.shrink(),
    bool visible = true,
    bool maintainState = false,
    bool maintainAnimation = false,
    bool maintainSize = false,
    bool maintainSemantics = false,
    bool maintainInteractivity = false,
  }) {
    return Visibility(
      key: key,
      child: this,
      replacement: replacement,
      visible: visible,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
      maintainSize: maintainSize,
      maintainSemantics: maintainSemantics,
      maintainInteractivity: maintainInteractivity,
    );
  }

  SafeArea intoSafeArea({
    Key? key,
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
    EdgeInsets minimum = EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
  }) {
    return SafeArea(
      key: key,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: this,
    );
  }
}
