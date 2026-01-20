import 'package:flutter/material.dart';

import 'app_color.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      backgroundColor: AppColor.primaryColor,
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey[850],
      minimumSize: const Size(double.infinity, 48),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,

      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
