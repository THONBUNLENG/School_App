import 'package:flutter_localization/flutter_localization.dart';

import 'navigator_extension.dart';

extension TranslateExtension on String {
  String get tr {
    final localization = FlutterLocalization.instance;
    final ctx = Go.context;

    if (ctx == null || localization.currentLocale == null) {
      return this;
    }

    try {

      return getString(ctx);
    } catch (e) {
      return this;
    }
  }
}

extension PhoneExtension on String {
  String get validatePhone {
    final cleaned = replaceAll(RegExp(r'\s|-'), '');
    if (cleaned.startsWith('0')) return cleaned.substring(1);
    return cleaned;
  }
}

extension PhoneValidationExtension on String {
  bool get isValidPhoneNumber {
    final cleaned = replaceAll(RegExp(r'\D'), '');

    return RegExp(r'^(0\d{8}|\d{8})$').hasMatch(cleaned);
  }
}

extension EmailValidation on String {
  bool get isValidEmail =>
      RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
}
