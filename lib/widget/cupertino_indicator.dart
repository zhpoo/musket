import 'package:flutter/cupertino.dart';

/// 菊花
class CupertinoIndicator extends StatelessWidget {
  final Brightness brightness;
  final double radius;

  const CupertinoIndicator({Key key, this.brightness, this.radius = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      child: CupertinoActivityIndicator(radius: radius),
      data: CupertinoTheme.of(context).copyWith(
        brightness: brightness ?? MediaQuery.of(context).platformBrightness ?? Brightness.dark,
      ),
    );
  }
}
