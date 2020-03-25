import 'dart:math';

import 'package:flutter/material.dart';

class ButtonStyle {
  final TextStyle style;
  final Color color;
  final double radius;
  final double elevation;
  final double focusElevation;
  final double highlightElevation;
  final double hoverElevation;
  final double disabledElevation;
  final AlignmentGeometry alignment;
  final bool expand;
  final BoxConstraints constraints;
  final MaterialTapTargetSize materialTapTargetSize;
  final Decoration decoration;
  final Decoration foregroundDecoration;

  ButtonStyle({
    this.style: const TextStyle(color: Colors.white),
    this.color: Colors.blueAccent,
    this.radius: 24,
    double height: 48,
    this.elevation: 0.0,
    this.focusElevation: 0.0,
    this.highlightElevation: 0.0,
    this.hoverElevation: 0.0,
    this.disabledElevation: 0.0,
    this.expand: true,
    this.alignment,
    this.materialTapTargetSize,
    this.decoration,
    this.foregroundDecoration,
    BoxConstraints constraints,
  }) : constraints = height != null
            ? (constraints?.copyWith(minHeight: max(height, constraints.minHeight)) ??
                BoxConstraints(minHeight: height))
            : constraints;
}

/// 圆角按钮
class Button extends StatelessWidget {
  static ButtonStyle defaultButtonStyle;

  static ButtonStyle get _defaults => defaultButtonStyle ?? ButtonStyle();

  final String text;
  final VoidCallback onTap;
  final TextStyle textStyle;
  final Color color;
  final double radius;
  final double elevation;
  final double focusElevation;
  final double highlightElevation;
  final double hoverElevation;
  final double disabledElevation;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry contentPadding;
  final BoxConstraints constraints;
  final Decoration decoration;
  final Decoration foregroundDecoration;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry borderRadius;
  final bool expand;
  final MaterialTapTargetSize materialTapTargetSize;

  /// Material Design默认 button 高度为 48，如果设置[height]低于 48，且不
  /// 设置 button 的 materialTapTargetSize 属性,则 [height] 会被限制最低高度 48.
  /// 如需强制设置高度低于48，需同时设置[materialTapTargetSize]为[MaterialTapTargetSize.shrinkWrap]。
  Button({
    Key key,
    @required this.text,
    @required this.onTap,
    this.textStyle,
    this.color,
    this.radius,
    this.elevation,
    this.focusElevation,
    this.highlightElevation,
    this.hoverElevation,
    this.disabledElevation,
    this.margin,
    this.padding,
    this.contentPadding,
    this.decoration,
    this.foregroundDecoration,
    this.borderRadius,
    this.expand,
    this.alignment,
    this.materialTapTargetSize,
    double height,
    BoxConstraints constraints,
  })  : constraints = height != null
            ? (constraints?.copyWith(minHeight: max(height, constraints.minHeight)) ??
                BoxConstraints(minHeight: height))
            : (constraints ?? _defaults.constraints),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var button = RaisedButton(
      materialTapTargetSize: materialTapTargetSize ??
          ((this.constraints?.minHeight ?? 0) < 48
              ? MaterialTapTargetSize.shrinkWrap
              : MaterialTapTargetSize.padded),
      color: color ?? _defaults.color,
      focusElevation: focusElevation ?? _defaults.focusElevation,
      highlightElevation: highlightElevation ?? _defaults.highlightElevation,
      disabledElevation: disabledElevation ?? _defaults.disabledElevation,
      hoverElevation: hoverElevation ?? _defaults.hoverElevation,
      elevation: elevation ?? _defaults.elevation,
      onPressed: onTap,
      padding: contentPadding,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(radius ?? _defaults.radius),
      ),
      child: Text(text, style: textStyle ?? _defaults.style, textAlign: TextAlign.center),
    );
    final expand = this.expand ?? _defaults.expand ?? true;
    return Container(
      margin: margin,
      padding: padding,
      alignment: expand ? null : alignment ?? _defaults.alignment,
      constraints: constraints,
      decoration: decoration ?? _defaults.decoration,
      foregroundDecoration: foregroundDecoration ?? _defaults.foregroundDecoration,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
