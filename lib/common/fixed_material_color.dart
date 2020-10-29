import 'package:flutter/material.dart';

class FixedMaterialColor extends MaterialColor {
  FixedMaterialColor(Color primary)
      : assert(primary != null),
        super(primary.value, <int, Color>{
          50: primary,
          100: primary,
          200: primary,
          300: primary,
          400: primary,
          500: primary,
          600: primary,
          700: primary,
          800: primary,
          900: primary,
        });
}
