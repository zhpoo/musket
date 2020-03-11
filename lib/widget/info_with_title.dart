import 'package:flutter/material.dart';

class InfoWithTitleStyle {
  final bool vertical;
  final EdgeInsetsGeometry margin;
  final double infoMargin;
  final TextStyle titleStyle;
  final TextStyle infoStyle;
  final CrossAxisAlignment verticalCrossAxisAlignment;
  final AlignmentGeometry alignment;

  const InfoWithTitleStyle({
    this.alignment,
    this.margin,
    this.vertical: false,
    this.infoMargin: 8.0,
    this.titleStyle: const TextStyle(fontSize: 13.0),
    this.infoStyle: const TextStyle(fontWeight: FontWeight.bold),
    this.verticalCrossAxisAlignment: CrossAxisAlignment.start,
  });
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
  final CrossAxisAlignment verticalCrossAxisAlignment;
  final VoidCallback onTapInfo;
  final AlignmentGeometry alignment;

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
    this.verticalCrossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    var titleWidget = Text(title ?? '', style: titleStyle ?? _defaults.titleStyle);
    Widget infoWidget = Text(info ?? '', style: infoStyle ?? _defaults.infoStyle);
    if (onTapInfo != null && info.isNotEmpty) {
      infoWidget = GestureDetector(onTap: onTapInfo, child: infoWidget);
    }
    var content;

    if (vertical ?? _defaults.vertical ?? false) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: verticalCrossAxisAlignment ?? _defaults.verticalCrossAxisAlignment,
        children: <Widget>[
          titleWidget,
          Container(
            margin: EdgeInsets.only(top: infoMargin ?? _defaults.infoMargin),
            child: infoWidget,
          )
        ],
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          titleWidget,
          Container(
            margin: EdgeInsets.only(left: infoMargin ?? _defaults.infoMargin),
            child: infoWidget,
          )
        ],
      );
    }
    return Container(
      child: content,
      margin: margin ?? _defaults.margin,
      alignment: alignment ?? _defaults.alignment,
    );
  }
}
