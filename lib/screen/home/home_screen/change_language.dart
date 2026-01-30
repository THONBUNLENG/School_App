import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/extension/string_extension.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const TextWidget(this.text, {super.key, this.fontSize, this.fontWeight, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: 'Battambang',
      ),
    );
  }
}

final FlutterLocalization translator = FlutterLocalization.instance;

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {

  @override
  void initState() {
    super.initState();
    translator.onTranslatedLanguage = (locale) {
      if (mounted) setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        // 🔥 ប្រើ Gradient Identity របស់ NJU
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: Text(
          'select_language'.tr,
          style: const TextStyle(
            color: AppColor.lightGold, // ប្រើពណ៌មាស
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColor.lightGold),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              "Choose your preferred language",
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 20),
            _buildLanguageTile('en', '🇺🇸', 'english', isDark),
            const SizedBox(height: 16),
            _buildLanguageTile('zh', '🇨🇳', 'chinese', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String code, String flag, String labelKey, bool isDark) {
    bool isSelected = translator.currentLocale?.languageCode == code;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColor.accentGold : AppColor.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        tileColor: isSelected
            ? (isDark ? AppColor.surfaceColor : Colors.white)
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.lightGold.withOpacity(0.1) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: TextWidget(flag, fontSize: 30),
        ),
        title: TextWidget(
          labelKey.tr,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
          color: isSelected
              ? (isDark ? AppColor.lightGold : AppColor.primaryColor)
              : (isDark ? Colors.white70 : Colors.black87),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle_rounded, color: AppColor.accentGold, size: 28)
            : Icon(Icons.circle_outlined, color: isDark ? Colors.white24 : Colors.grey.shade300),
        onTap: () {
          if (isSelected) {
            Navigator.pop(context);
            return;
          }
          translator.translate(code);
          if (translator.onTranslatedLanguage != null) {
            translator.onTranslatedLanguage!(Locale(code));
          }
        },
      ),
    );
  }
}