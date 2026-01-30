import 'package:flutter/material.dart';

mixin AppColor {
  static const Color primaryColor = Color(0xFF4A2A73);
  static const Color backgroundColor = Color(0xFF0F0F12); // Slightly deeper for more "pop"
  static const Color surfaceColor = Color(0xFF1C1B21);   // Elevated surface

  static const Color accentGold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF1D592);
  static Color brandOrange = const Color(0xFFD85D22);
  // Glassmorphism colors
  static Color glassWhite = Colors.white.withOpacity(0.08);
  static Color glassBorder = Colors.white.withOpacity(0.15);

  static const MaterialColor primarySwatch = MaterialColor(
    0xFF4A2A73,
    <int, Color>{
      50:  Color(0xFFF1EBF7),
      100: Color(0xFFDCCCE8),
      200: Color(0xFFC5AAD7),
      300: Color(0xFFA982C2),
      400: Color(0xFF9163B2),
      500: Color(0xFF4A2A73),
      600: Color(0xFF43256B),
      700: Color(0xFF3A1F60),
      800: Color(0xFF321956),
      900: Color(0xFF230F43),
    },
  );
}

// config/app_color.dart

class BrandGradient {
  static const LinearGradient luxury = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A2A73), // Deep Purple
      Color(0xFF6B3A93), // Mid Purple
      Color(0xFF8B2682), // Plum
    ],
  );

  static const LinearGradient goldMetallic = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB8860B),
      Color(0xFFD4AF37),
      Color(0xFFF1D592),
    ],
  );
}