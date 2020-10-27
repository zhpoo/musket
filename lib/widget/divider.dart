import 'package:flutter/material.dart';
import 'package:musket/common/defaults.dart';

class LineStyle {
  final Color color;
  final Color background;
  final double height;

  const LineStyle({
    this.background,
    this.color = Defaults.borderColor,
    this.height = Defaults.dividerHeight,
  });
}

class Line extends StatelessWidget implements PreferredSizeWidget {
  static LineStyle defaultStyle;

  static LineStyle get _defaults => defaultStyle ?? const LineStyle();

  final Color color;
  final Color background;
  final double height;
  final EdgeInsets margin;

  Line({
    Key key,
    this.color,
    this.background,
    this.height,
    this.margin: const EdgeInsets.symmetric(horizontal: 16.0),
  })  : preferredSize = Size.fromHeight(height ?? _defaults.height),
        super(key: key);

  Line.expand({
    Key key,
    Color color,
    Color background,
    double height,
  }) : this(key: key, color: color, background: background, margin: null);

  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: margin?.left ?? 0, right: margin?.right ?? 0),
      margin: EdgeInsets.only(top: margin?.top ?? 0, bottom: margin?.bottom ?? 0),
      color: background ?? _defaults.background,
      child: Container(
        height: height ?? _defaults.height,
        color: color ?? _defaults.color,
      ),
    );
  }
}
