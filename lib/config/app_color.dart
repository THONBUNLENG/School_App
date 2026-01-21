import 'package:flutter/material.dart';

mixin AppColor {

  static const int _primary = 0xFFE5B94C;
  static const Map<int, Color> _swatch = {
    50: primaryColor,
    100: primaryColor,
    200: primaryColor,
    300: primaryColor,
    400: primaryColor,
    500: primaryColor,
    600: primaryColor,
    700: primaryColor,
    800: primaryColor,
    900: primaryColor,
  };
  static const MaterialColor primarySwatch = MaterialColor(_primary, _swatch);

  static const Color primaryColor = Color(_primary);
  static const Color backgroundColor = Color(0xFF1B1B1B);
}

class GoldGradient {
  static const List<Color> colors = [
    Color(0xFFFFD54F),
    Color(0xFFFFF3B0),
    Color(0xFFFFB300),
    Color(0xFFFF8F00),

  ];
}
