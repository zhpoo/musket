import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 上方带 label 的 [TextField]
/// [prefixText] 与 [prefix] 同时提供时仅 [prefixText] 生效
/// [suffixText] 与 [suffix] 同时提供时仅 [suffixText] 生效
class TextInputWidget extends StatelessWidget {
  static TextStyle defaultStyle = const TextStyle(fontSize: 14);
  static TextStyle defaultLabelStyle = const TextStyle(fontSize: 14);
  static TextStyle defaultHintStyle = const TextStyle(fontSize: 14);
  static InputBorder defaultBorder = const UnderlineInputBorder();

  final double height;
  final String label;
  final String hint;
  final TextStyle style;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final InputBorder border;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry contentPadding;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autoFocus;
  final Widget prefix;
  final Widget prefixIcon;
  final String prefixText;
  final TextStyle prefixStyle;
  final Widget suffixIcon;
  final Widget suffix;
  final String suffixText;
  final TextStyle suffixStyle;
  final bool enabled;
  final bool enableInteractiveSelection;
  final Color color;
  final int maxLines;
  final int maxLength;
  final TextInputAction textInputAction;

  final List<TextInputFormatter> inputFormatters;

  const TextInputWidget({
    Key key,
    this.height,
    this.label = '',
    this.hint,
    this.controller,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.border,
    this.margin,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 4),
    this.keyboardType,
    this.obscureText = false,
    this.autoFocus = false,
    this.prefix,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.enabled = true,
    this.enableInteractiveSelection = true,
    this.color,
    this.maxLines: 1,
    this.maxLength,
    this.textInputAction,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var border = this.border ?? defaultBorder;
    var style = this.style ?? defaultStyle;
    var labelStyle = this.labelStyle ?? defaultLabelStyle;
    var hintStyle = this.hintStyle ?? defaultHintStyle;
    bool hasPrefixOrSuffix =
        prefix != null || prefixText != null || suffixText != null || suffix != null;

    var inputBorder = hasPrefixOrSuffix ? border.copyWith(borderSide: BorderSide.none) : border;

    InputDecoration decoration = InputDecoration(
      contentPadding: contentPadding,
      hintText: hint,
      hintStyle: hintStyle,
      border: inputBorder,
      focusedBorder: inputBorder,
      enabledBorder: inputBorder,
      enabled: enabled,
      fillColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,

      // 以下8个注销掉的属性，当TextField无焦点或内容为空时不会显示，
      // 官方已作为新feature等待开发，待更新后可重新实现此处逻辑
      // https://github.com/flutter/flutter/issues/19488
//      prefix: prefix,
//      prefixIcon: prefixIcon,
//      prefixText: prefixText,
//      prefixStyle: prefixStyle,
//      suffixIcon: suffixIcon,
//      suffix: suffix,
//      suffixText: suffixText,
//      suffixStyle: suffixStyle,
    );
    var columnChildren = <Widget>[];

    if (label != null && label.isNotEmpty) {
      columnChildren.add(Container(
        margin: EdgeInsets.only(bottom: 8),
        child: Text(label, style: labelStyle),
      ));
    }

    List<Widget> inputRowChildren = [];
    if (prefixText != null) {
      inputRowChildren.add(Text(prefixText, style: prefixStyle));
    } else if (prefix != null) {
      inputRowChildren.add(prefix);
    }
    if (prefixIcon != null) {
      inputRowChildren.add(prefixIcon);
    }

    inputRowChildren.add(Expanded(
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: Container(
          height: height,
          child: TextField(
            autofocus: autoFocus,
            style: style,
            maxLines: maxLines,
            maxLength: maxLength,
            maxLengthEnforced: true,
            buildCounter:
                maxLength == null ? null : (context, {currentLength, maxLength, isFocused}) => null,
            enabled: enabled,
            obscureText: obscureText,
            textAlign: TextAlign.left,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: decoration,
            controller: controller,
            textInputAction: textInputAction,
            cursorWidth: 1.5,
            enableInteractiveSelection: enableInteractiveSelection,
            cursorRadius: Radius.circular(1.5),
          ),
        ),
      ),
    ));

    if (suffixText != null) {
      inputRowChildren.add(Text(suffixText, style: suffixStyle));
    } else if (suffix != null) {
      inputRowChildren.add(suffix);
    }
    if (suffixIcon != null) {
      inputRowChildren.add(suffixIcon);
    }

    columnChildren.add(Row(children: inputRowChildren));
    var column = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
    Decoration mainDecoration;
    if (hasPrefixOrSuffix) {
      if (border is UnderlineInputBorder) {
        mainDecoration = BoxDecoration(border: Border(bottom: border.borderSide));
      } else if (border is OutlineInputBorder) {
        mainDecoration = BoxDecoration(border: Border.fromBorderSide(border.borderSide));
      }
    }
    return Container(
      decoration: mainDecoration,
      margin: margin,
      child: column,
      color: color,
      alignment: Alignment.center,
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final RegExp decimalRegExp;

  DecimalTextInputFormatter({int decimalDigits})
      : decimalRegExp = RegExp(
          "^\\d*[.]{0,1}\\d${decimalDigits == null || decimalDigits == 0 ? '*' : '{0,$decimalDigits}'}\$",
        );

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    if (value == null || value.isEmpty) {
      return newValue;
    }
    if (value.length == 2 && value.startsWith('0') && value != '0.') {
      return TextEditingValue(
        text: value.substring(1),
        selection: TextSelection.collapsed(offset: newValue.selection.end - 1),
      );
    }
    return decimalRegExp.hasMatch(value) ? newValue : oldValue;
  }
}
