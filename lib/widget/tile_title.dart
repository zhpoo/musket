import 'package:flutter/material.dart';

class TileTitle extends StatelessWidget {
  static TextStyle defaultStyle = const TextStyle(fontSize: 20);
  final String text;
  final EdgeInsetsGeometry margin;
  final TextStyle style;

  const TileTitle({
    Key key,
    @required this.text,
    this.margin: const EdgeInsets.only(left: 16, top: 32, bottom: 16, right: 16),
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(text, style: style ?? defaultStyle),
    );
  }
}
