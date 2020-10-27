import 'package:flutter/material.dart';
import 'package:musket/extensions/widget_extension.dart';
import 'package:musket/route/mixin/safe_state.dart';
import 'package:musket/widget/text_input.dart';

const int kPasswordMinLength = 6;
const int kPasswordMaxLength = 20;

mixin PasswordInputMixin<T extends StatefulWidget> on State<T> {
  bool showPassword = false;

  Widget passwordEye(Color color, Color activeColor) {
    return Icon(
      Icons.remove_red_eye,
      color: showPassword ? activeColor : color,
    ).intoOnTap(() => setState(() => showPassword = !showPassword));
  }
}

class PasswordInputWidget extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLength;
  final TextStyle style;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final EdgeInsetsGeometry margin;
  final Color eyeColor;
  final Color activeEyeColor;

  const PasswordInputWidget({
    Key key,
    this.label,
    this.hint,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.controller,
    this.eyeColor = Colors.red,
    this.activeEyeColor = Colors.white12,
    this.maxLength = kPasswordMaxLength,
    this.margin = const Edges(horizontal: 12, top: 24),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends SafeState<PasswordInputWidget> with PasswordInputMixin {
  @override
  Widget build(BuildContext context) {
    return TextInputWidget(
      label: widget.label,
      controller: widget.controller,
      labelStyle: widget.labelStyle,
      hint: widget.hint ?? widget.label,
      style: widget.style,
      hintStyle: widget.hintStyle,
      margin: widget.margin,
      maxLength: widget.maxLength ?? kPasswordMaxLength,
      obscureText: !showPassword,
      suffix: passwordEye(widget.activeEyeColor, widget.eyeColor),
    );
  }
}
