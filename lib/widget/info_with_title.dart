import 'package:flutter/material.dart';

class InfoWithTitle extends StatelessWidget {
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
    this.title = '',
    this.info = '',
    this.vertical = false,
    this.margin,
    this.infoMargin = 8.0,
    this.titleStyle: const TextStyle(fontSize: 13.0),
    this.infoStyle: const TextStyle(fontWeight: FontWeight.bold),
    this.onTapInfo,
    this.alignment,
    this.verticalCrossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    var titleWidget = Text(
      title,
      style: titleStyle,
    );
    Widget infoWidget = Text(info, style: infoStyle);
    if (onTapInfo != null && info.isNotEmpty) {
      infoWidget = GestureDetector(onTap: onTapInfo, child: infoWidget);
    }
    var content;

    if (vertical) {
      content = Column(
        crossAxisAlignment: verticalCrossAxisAlignment,
        children: <Widget>[
          titleWidget,
          Container(margin: EdgeInsets.only(top: infoMargin), child: infoWidget)
        ],
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          titleWidget,
          Container(margin: EdgeInsets.only(left: infoMargin), child: infoWidget)
        ],
      );
    }
    return Container(margin: margin, child: content, alignment: alignment);
  }
}
