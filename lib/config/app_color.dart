import 'package:flutter/material.dart';

mixin AppColor {

  // MAIN BRAND COLOR
  static const Color primaryColor = Color(0xFF81005B);

  // BACKGROUND
  static const Color backgroundColor = Color(0xFF1B1B1B);

  // MATERIAL SWATCH
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF81005B,
    <int, Color>{
      50: Color(0xFFFFE6F0),
      100: Color(0xFFFFB3D2),
      200: Color(0xFFFF80B4),
      300: Color(0xFFFF4D96),
      400: Color(0xFFFF1A78),
      500: Color(0xFF81005B),
      600: Color(0xFF720051),
      700: Color(0xFF630047),
      800: Color(0xFF54003D),
      900: Color(0xFF3D002B),
    },
  );
}

class BrandGradient {
  static const List<Color> primary = [
    Color(0xFF8B2682),
    Color(0xFF81005B),
    Color(0xFFFF005C),
  ];
}
