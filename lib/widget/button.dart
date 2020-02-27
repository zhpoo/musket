import 'package:flutter/material.dart';

class ButtonStyle {
  final TextStyle style;
  final Color color;
  final double radius;
  final double height;
  final double elevation;
  final double focusElevation;
  final double highlightElevation;
  final double hoverElevation;
  final double disabledElevation;
  final AlignmentGeometry alignment;
  final bool expand;

  const ButtonStyle({
    this.style: const TextStyle(color: Colors.white),
    this.color: Colors.blueAccent,
    this.radius: 24,
    this.height: 48,
    this.elevation: 0.0,
    this.focusElevation: 0.0,
    this.highlightElevation: 0.0,
    this.hoverElevation: 0.0,
    this.disabledElevation: 0.0,
    this.expand: true,
    this.alignment: Alignment.center,
  });
}

/// 圆角按钮
class Button extends StatelessWidget {
  static ButtonStyle defaultButtonStyle;
  static ButtonStyle _defaults = defaultButtonStyle ?? const ButtonStyle();

  final String text;
  final VoidCallback onTap;
  final TextStyle textStyle;
  final Color color;
  final double radius;
  final double height;
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
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry borderRadius;
  final bool expand;

  const Button({
    Key key,
    @required this.text,
    @required this.onTap,
    this.textStyle,
    this.color,
    this.radius,
    this.height,
    this.elevation,
    this.focusElevation,
    this.highlightElevation,
    this.hoverElevation,
    this.disabledElevation,
    this.margin,
    this.padding,
    this.contentPadding,
    this.constraints,
    this.decoration,
    this.borderRadius,
    this.expand,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = Text(text, style: textStyle ?? _defaults.style);
    if (expand ?? _defaults.expand) {
      buttonChild = Container(
        alignment: Alignment.center,
        height: height ?? _defaults.height,
        constraints: constraints,
        child: buttonChild,
      );
    }
    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment ?? _defaults.alignment,
      height: height ?? _defaults.height,
      constraints: constraints,
      decoration: decoration,
      child: RaisedButton(
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
        child: buttonChild,
      ),
    );
  }
}
