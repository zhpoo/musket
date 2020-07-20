import 'package:flutter/material.dart';
import 'package:musket/extensions/widget_extension.dart';

class InfoWithTitleStyle {
  final bool vertical;
  final EdgeInsetsGeometry margin;
  final double infoMargin;
  final TextStyle titleStyle;
  final TextStyle infoStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final AlignmentGeometry alignment;

  const InfoWithTitleStyle({
    this.alignment,
    this.margin,
    this.vertical: false,
    this.infoMargin: 8.0,
    this.titleStyle: const TextStyle(fontSize: 13.0),
    this.infoStyle: const TextStyle(fontWeight: FontWeight.bold),
    @Deprecated('use crossAxisAlignment instead')
        CrossAxisAlignment verticalCrossAxisAlignment: CrossAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment: CrossAxisAlignment.start,
  }) : crossAxisAlignment = crossAxisAlignment ??
            verticalCrossAxisAlignment ??
            (vertical == true ? CrossAxisAlignment.start : CrossAxisAlignment.center);
}

class InfoWithTitle extends StatelessWidget {
  static InfoWithTitleStyle defaultStyle;

  static InfoWithTitleStyle get _defaults => defaultStyle ?? const InfoWithTitleStyle();

  final String title;
  final String info;
  final bool vertical;
  final EdgeInsetsGeometry margin;
  final double infoMargin;
  final TextStyle titleStyle;
  final TextStyle infoStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final VoidCallback onTapInfo;
  final AlignmentGeometry alignment;
  final TextAlign titleTextAlign;
  final TextAlign infoTextAlign;
  final bool expandTitle;
  final bool expandInfo;

  const InfoWithTitle({
    this.title,
    this.info,
    this.vertical,
    this.margin,
    this.infoMargin,
    this.titleStyle,
    this.infoStyle,
    this.onTapInfo,
    this.alignment,
    @Deprecated('use crossAxisAlignment instead') CrossAxisAlignment verticalCrossAxisAlignment,
    CrossAxisAlignment crossAxisAlignment,
    this.titleTextAlign = TextAlign.center,
    this.infoTextAlign = TextAlign.center,
    this.expandTitle = false,
    this.expandInfo = false,
  }) : crossAxisAlignment = crossAxisAlignment ?? verticalCrossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Text(
      title ?? '',
      style: titleStyle ?? _defaults.titleStyle,
      textAlign: titleTextAlign ?? TextAlign.center,
    );
    Widget infoWidget = Text(
      info ?? '',
      style: infoStyle ?? _defaults.infoStyle,
      textAlign: infoTextAlign ?? TextAlign.center,
    );
    if (onTapInfo != null && info.isNotEmpty) {
      infoWidget = GestureDetector(onTap: onTapInfo, child: infoWidget);
    }

    if (expandTitle == true) {
      titleWidget = titleWidget.intoExpanded();
    }
    Widget content;

    if (vertical ?? _defaults.vertical ?? false) {
      infoWidget = Container(
        margin: EdgeInsets.only(top: infoMargin ?? _defaults.infoMargin),
        child: infoWidget,
      );
      if (expandInfo == true) {
        infoWidget = infoWidget.intoExpanded();
      }
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? _defaults.crossAxisAlignment,
        children: <Widget>[titleWidget, infoWidget],
      );
    } else {
      infoWidget = Container(
        margin: EdgeInsets.only(left: infoMargin ?? _defaults.infoMargin),
        child: infoWidget,
      );
      if (expandInfo == true) {
        infoWidget = infoWidget.intoExpanded();
      }
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? _defaults.crossAxisAlignment,
        children: <Widget>[titleWidget, infoWidget],
      );
    }
    return Container(
      child: content,
      margin: margin ?? _defaults.margin,
      alignment: alignment ?? _defaults.alignment,
    );
  }
}
