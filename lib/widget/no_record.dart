import 'package:flutter/material.dart';

class NoRecordStyle {
  final String text;
  final TextStyle style;

  NoRecordStyle({
    this.text = 'No Record',
    this.style = const TextStyle(inherit: false),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoRecordStyle && runtimeType == other.runtimeType && text == other.text && style == other.style;

  @override
  int get hashCode => hashValues(text, style);
}

class DefaultNoRecordStyle extends InheritedWidget {
  final NoRecordStyle data;

  DefaultNoRecordStyle({
    Key key,
    String text,
    TextStyle style,
    @required Widget child,
  })  : data = NoRecordStyle(text: text, style: style),
        super(key: key, child: child);

  static DefaultNoRecordStyle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DefaultNoRecordStyle>();
  }

  @override
  bool updateShouldNotify(DefaultNoRecordStyle oldWidget) {
    return data != oldWidget.data;
  }
}

class NoRecord extends StatelessWidget {
  static String defaultText;
  static TextStyle defaultStyle;

  final String text;
  final TextStyle style;

  NoRecord({this.text, this.style});

  @override
  Widget build(BuildContext context) {
    var data = DefaultNoRecordStyle.of(context)?.data ?? NoRecordStyle();
    return Center(
      child: Text(
        text ?? defaultText ?? data.text,
        style: style ?? defaultStyle ?? data.style,
      ),
    );
  }
}
