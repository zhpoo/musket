import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs {
  Dialogs._();

  /// Note: textStyle 设置 inherit: false 解决文字下面两条黄线的问题
  static Future<T> show<T>({
    @required BuildContext context,
    @required WidgetBuilder builder,
    cancelable: true,
    Color barrierColor: Colors.black54,
    AlignmentGeometry alignment: Alignment.center,
    Duration transitionDuration = const Duration(milliseconds: 250),
  }) {
    assert(builder != null);
    return showGeneralDialog(
      context: context,
      barrierDismissible: cancelable,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // barrierColor cannot be transparent.
      barrierColor: barrierColor == Colors.transparent ? null : barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        Widget contentWidget = UnconstrainedBox(alignment: alignment, child: builder(context));
        if (cancelable) {
          return contentWidget;
        }
        return WillPopScope(onWillPop: () async => false, child: contentWidget);
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        final CurvedAnimation fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        if (animation.status == AnimationStatus.reverse) {
          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        }
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            child: child,
            scale: animation.drive(Tween<double>(begin: 1.3, end: 1.0)
                .chain(CurveTween(curve: Curves.linearToEaseOut))),
          ),
        );
      },
    );
  }

  static Future<T> showLoading<T>(
    BuildContext context, {
    String text,
    double indicatorRadius: 18.0,
    double minWidth: 124,
    double minHeight: 114,
    double fontSize: 14,
    Color textColor: Colors.white,
    Color color: const Color(0xB3000000),
  }) {
    Widget indicator(BuildContext context) {
      var children = <Widget>[CupertinoActivityIndicator(radius: indicatorRadius)];
      if (text != null) {
        children.add(Container(
          margin: EdgeInsets.only(top: 16.0),
          child: Text(text, style: TextStyle(fontSize: fontSize, color: textColor, inherit: false)),
        ));
      }
      return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
      );
    }

    return show(context: context, builder: indicator, cancelable: false, barrierColor: null);
  }
}
