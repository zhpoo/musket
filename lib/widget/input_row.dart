import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musket/extensions/widget_extension.dart';
import 'package:musket/widget/expanded_twins_row.dart';
import 'package:musket/widget/text_input.dart';

class InputRow extends StatelessWidget {
  final int leftFlex;
  final int rightFlex;
  final double spacingWidth;

  final String title;
  final String hint;
  final TextStyle titleStyle;
  final TextStyle inputStyle;
  final TextStyle inputHintStyle;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;
  final bool enabled;

  const InputRow({
    Key key,
    @required this.title,
    String hint,
    this.titleStyle,
    this.inputStyle,
    this.inputHintStyle,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.enabled = true,
    this.leftFlex = 1,
    this.rightFlex = 3,
    this.spacingWidth = 8,
  })  : hint = hint ?? title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandedTwinsRow(
      rightFlex: 3,
      left: Text(title ?? '', style: titleStyle, textAlign: TextAlign.left),
      right: TextInputWidget(
        hint: hint ?? '',
        margin: edgeInsets(left: spacingWidth ?? 0),
        controller: controller,
        style: inputStyle,
        hintStyle: inputHintStyle,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        border: InputBorder.none,
        enabled: enabled,
      ),
    );
  }
}
