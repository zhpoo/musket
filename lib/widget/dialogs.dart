import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musket/widget/loading_indicator.dart';

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

  static showLoading<T>(
    BuildContext context, {
    Widget indicator: const LoadingIndicator(),
    bool cancelable: false,
  }) {
    return show(
      context: context,
      builder: (context) => indicator,
      cancelable: cancelable,
      barrierColor: null,
    );
  }
}
