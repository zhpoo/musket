import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color backgroundColor;
  final double width;
  final double height;
  final String text;
  final double fontSize;
  final textColor;
  final double indicatorSize;
  final double containerRadius;
  final Brightness brightness;

  final EdgeInsetsGeometry margin;

  const LoadingIndicator({
    Key key,
    this.text,
    this.backgroundColor: const Color(0xB3000000),
    this.width: 124,
    this.height: 114,
    this.fontSize: 14,
    this.textColor: Colors.white,
    this.indicatorSize: 18.0,
    this.containerRadius: 8.0,
    this.margin,
    this.brightness: Brightness.dark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      CupertinoTheme(
        child: CupertinoActivityIndicator(radius: indicatorSize),
        data: CupertinoTheme.of(context).copyWith(brightness: brightness),
      ),
    ];
    if (text != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Text(text, style: TextStyle(fontSize: fontSize, color: textColor, inherit: false)),
      ));
    }
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
      ),
      constraints: BoxConstraints(
        minWidth: width,
        maxWidth: width,
        minHeight: height,
        maxHeight: height,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
    );
  }
}
