import 'dart:ui';

import 'package:flutter/material.dart';

class TextStyleProps with TextStyleCopy {
  Paint background;
  Color backgroundColor;
  Color color;
  TextDecoration decoration;
  TextDecorationStyle decorationStyle;
  Color decorationColor;
  double decorationThickness;
  String fontFamily;
  List<String> fontFamilyFallback;
  List<FontFeature> fontFeatures;
  double fontSize;
  FontStyle fontStyle;
  FontWeight fontWeight;
  Paint foreground;
  double height;
  bool inherit;
  double letterSpacing;
  Locale locale;
  List<Shadow> shadows;
  TextBaseline textBaseline;
  double wordSpacing;

  TextStyleProps({
    this.background,
    this.backgroundColor,
    this.color,
    this.decoration,
    this.decorationStyle,
    this.decorationColor,
    this.decorationThickness,
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontFeatures,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.foreground,
    this.height,
    this.inherit,
    this.letterSpacing,
    this.locale,
    this.shadows,
    this.textBaseline,
    this.wordSpacing,
  });

  @override
  TextStyleProps get props => this;
}

mixin TextStyleCopy {
  TextStyleProps get props;

  TextStyle copyTo(TextStyle base) {
    return base?.copyWith(
      background: props?.background,
      backgroundColor: props?.backgroundColor,
      color: props?.color,
      decoration: props?.decoration,
      decorationColor: props?.decorationColor,
      decorationStyle: props?.decorationStyle,
      decorationThickness: props?.decorationThickness,
      fontFamily: props?.fontFamily,
      fontFamilyFallback: props?.fontFamilyFallback,
      fontFeatures: props?.fontFeatures,
      fontSize: props?.fontSize,
      fontStyle: props?.fontStyle,
      fontWeight: props?.fontWeight,
      foreground: props?.foreground,
      height: props?.height,
      inherit: props?.inherit,
      letterSpacing: props?.letterSpacing,
      locale: props?.locale,
      shadows: props?.shadows,
      textBaseline: props?.textBaseline,
      wordSpacing: props?.wordSpacing,
    );
  }
}
