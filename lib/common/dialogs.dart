import 'package:flutter/material.dart';
import 'package:musket/extensions/widget_extension.dart';
import 'package:musket/widget/loading_indicator.dart';

class Dialogs {
  Dialogs._();

  static bool defaultCancelable = true;

  static Future<T?> alert<T>({
    Key? key,
    required BuildContext context,
    bool? cancelable,
    Color barrierColor = Colors.black54,
    AlignmentGeometry alignment = Alignment.center,
    Duration transitionDuration = const Duration(milliseconds: 250),
    bool expandWidth = true,
    Widget? title,
    EdgeInsets? titlePadding,
    TextStyle? titleTextStyle,
    Widget? content,
    EdgeInsets contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    TextStyle? contentTextStyle,
    List<Widget>? actions,
    EdgeInsets actionsPadding = EdgeInsets.zero,
    VerticalDirection? actionsOverflowDirection,
    double? actionsOverflowButtonSpacing,
    EdgeInsets? buttonPadding,
    Color? backgroundColor,
    double? elevation,
    String? semanticLabel,
    EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    Clip clipBehavior = Clip.none,
    ShapeBorder? shape,
    bool scrollable = false,
  }) {
    titlePadding ??= Edges(all: 24, bottom: content == null ? 20.0 : 0);
    if (expandWidth == true) {
      assert(title != null || content != null);
      if (title != null) {
        title = SizedBox(
          width: MediaQuery.of(context).size.width - insetPadding.horizontal - titlePadding.horizontal,
          child: title,
        );
      }
      if (content != null) {
        content = SizedBox(
          width: MediaQuery.of(context).size.width - insetPadding.horizontal - contentPadding.horizontal,
          child: content,
        );
      }
    }
    cancelable ??= defaultCancelable;
    return show(
      context: context,
      cancelable: cancelable,
      barrierColor: barrierColor,
      alignment: alignment,
      transitionDuration: transitionDuration,
      builder: (context) {
        return AlertDialog(
          key: key,
          title: title,
          titlePadding: titlePadding,
          titleTextStyle: titleTextStyle,
          contentPadding: contentPadding,
          contentTextStyle: contentTextStyle,
          content: content,
          actions: actions,
          actionsPadding: actionsPadding,
          actionsOverflowDirection: actionsOverflowDirection,
          actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
          buttonPadding: buttonPadding,
          backgroundColor: backgroundColor,
          elevation: elevation,
          semanticLabel: semanticLabel,
          insetPadding: insetPadding,
          clipBehavior: clipBehavior,
          shape: shape,
          scrollable: scrollable,
        );
      },
    );
  }

  static Future<void> showLoading(
    BuildContext context, {
    Widget indicator = const LoadingIndicator(),
    bool cancelable = false,
  }) {
    return show(
      context: context,
      builder: (context) => indicator,
      cancelable: cancelable,
      barrierColor: null,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool? cancelable,
    Color? barrierColor = Colors.black54,
    AlignmentGeometry alignment = Alignment.center,
    Duration transitionDuration = const Duration(milliseconds: 250),
  }) {
    cancelable ??= defaultCancelable;
    return showGeneralDialog(
      context: context,
      barrierDismissible: cancelable,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // barrierColor cannot be transparent.
      // barrierColor: barrierColor == Colors.transparent ? null : barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        Widget contentWidget = UnconstrainedBox(alignment: alignment, child: builder(context));
        if (cancelable == true) {
          return contentWidget;
        }
        return WillPopScope(onWillPop: () async => false, child: contentWidget);
      },
      transitionBuilder: (context, animation, secondaryAnimation, Widget child) {
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
            scale: animation.drive(
              Tween<double>(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.linearToEaseOut)),
            ),
          ),
        );
      },
    );
  }
}
