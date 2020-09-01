import 'package:flutter/material.dart';
import 'package:musket/widget/button.dart';

class DialogStyle {
  final Color background;
  final Color buttonColor;
  final TextStyle buttonStyle;
  final double buttonHeight;
  final double screenEdge;
  final BorderSide borderSide;
  final TextStyle titleStyle;

  const DialogStyle({
    this.background: Colors.white,
    this.buttonColor: Colors.transparent,
    this.buttonStyle: const TextStyle(color: Colors.black),
    this.buttonHeight: 64,
    this.screenEdge: 24,
    this.borderSide: const BorderSide(),
    this.titleStyle: const TextStyle(),
  });
}

class DialogContainer extends StatelessWidget {
  static DialogStyle defaultStyle;

  static DialogStyle get _defaults => defaultStyle ?? const DialogStyle();

  final double radius;
  final double buttonHeight;
  final Color background;
  final Gradient gradient;
  final String title;
  final TextStyle titleStyle;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry contentPadding;
  final Widget content;
  final List<DialogButton> buttons;
  final BorderSide borderSide;
  final bool showTitleBorder;
  final bool showButtonBorder;
  final double screenEdge;

  const DialogContainer({
    Key key,
    this.title,
    this.content,
    this.buttonHeight,
    this.radius: 8,
    this.titlePadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    this.contentPadding,
    this.background,
    this.gradient,
    this.buttons,
    this.borderSide,
    this.titleStyle,
    this.screenEdge,
    this.showTitleBorder: false,
    this.showButtonBorder: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - (screenEdge ?? _defaults.screenEdge) * 2;
    var children = <Widget>[];
    var borderSide = this.borderSide ?? _defaults.borderSide;
    if (title?.isNotEmpty == true) {
      children.add(Container(
        width: width,
        alignment: Alignment.center,
        decoration: showTitleBorder ? BoxDecoration(border: Border(bottom: borderSide)) : null,
        padding: titlePadding,
        child: Text(title, style: titleStyle ?? _defaults.titleStyle, textAlign: TextAlign.center),
      ));
    }
    if (content != null || contentPadding != null) {
      children.add(Container(child: content, padding: contentPadding));
    }
    if (buttons?.isNotEmpty == true) {
      List<Widget> buttonsRow = [];
      for (int i = 0; i < buttons.length; i++) {
        final button = buttons[i];
        buttonsRow.add(Expanded(
          flex: button.flex,
          child: Button(
            color: button.color ?? _defaults.buttonColor,
            textStyle: button.style ?? _defaults.buttonStyle,
            text: button.text,
            onTap: button.onTap,
            borderRadius: BorderRadius.only(
              bottomLeft: i == 0 ? Radius.circular(radius) : Radius.zero,
              bottomRight: i == buttons.length - 1 ? Radius.circular(radius) : Radius.zero,
            ),
            height: buttonHeight ?? _defaults.buttonHeight,
            decoration: showButtonBorder
                ? BoxDecoration(
                    border: Border(left: i == 0 ? BorderSide.none : borderSide, top: borderSide),
                  )
                : null,
          ),
        ));
      }
      children.add(Row(children: buttonsRow));
    }
    return DefaultTextStyle(
      style: const TextStyle(inherit: false),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          gradient: gradient,
          color: background ?? _defaults.background,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

class DialogButton {
  final String text;
  final TextStyle style;
  final VoidCallback onTap;
  final Color color;
  final int flex;

  const DialogButton({
    this.text,
    this.style,
    this.onTap,
    this.color,
    this.flex: 1,
  });
}
