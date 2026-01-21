import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
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
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF81005B),
        title: Text(
          'select_language'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // back button color
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
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

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? const  Color(0xFF81005B) : Colors.transparent,
          width: 2,
        ),
      ),
      tileColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      leading: TextWidget(flag, fontSize: 28),
      title: TextWidget(
        labelKey.tr,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF81005B))
          : null,
      onTap: () {
        if (isSelected) {
          Navigator.pop(context);
          return;
        }
        translator.translate(code);

        if (translator.onTranslatedLanguage != null) {
          translator.onTranslatedLanguage!(Locale(code));
        }
       // Navigator.pop(context);
      },
    );
  }
}

