import 'package:flutter/material.dart';

class AttentionStyle {
  final TextStyle titleStyle;
  final TextStyle attentionStyle;
  final Color dotColor;

  const AttentionStyle({
    this.titleStyle: const TextStyle(),
    this.attentionStyle: const TextStyle(),
    this.dotColor,
  });
}

class Attention extends StatelessWidget {
  static AttentionStyle defaultStyle;

  static AttentionStyle get _defaults => defaultStyle ?? const AttentionStyle();

  final String title;
  final List<String> attentions;
  final TextStyle titleStyle;
  final TextStyle attentionStyle;
  final bool showDot;
  final Color dotColor;
  final double dotSize;

  const Attention({
    Key key,
    this.attentions,
    this.title,
    this.titleStyle,
    this.attentionStyle,
    this.showDot: true,
    this.dotColor,
    this.dotSize: 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Text(title ?? '', style: titleStyle ?? _defaults.titleStyle),
      )
    ];
    TextStyle style = attentionStyle ?? _defaults.attentionStyle;
    if (attentions?.isNotEmpty == true) {
      children.addAll(attentions.map((text) {
        var attention = <Widget>[];
        if (showDot == true) {
          attention.add(Container(
            width: dotSize,
            height: dotSize,
            margin: EdgeInsets.only(
              // +1 to fix the text baseline.
              top: ((style.fontSize ?? dotSize) * (style.height ?? 1) - dotSize) / 2 + 1,
              right: 8,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor ?? _defaults.dotColor ?? style.color,
            ),
          ));
        }
        attention.add(Expanded(child: Text(text ?? '', style: style)));

        return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: attention),
        );
      }).toList());
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
