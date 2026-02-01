import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/extension/string_extension.dart';
import 'package:school_app/screen/home/home_screen/change_language.dart';
import 'package:school_app/screen/home/home_screen/menu_screen/about_app.dart';
import 'package:school_app/screen/home/home_screen/menu_screen/faq_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../../profile_login/qr_login.dart';
import '../../../../extension/change_notifier.dart';
import 'logout.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isNotificationOn = true;
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    _localization.onTranslatedLanguage = (locale) {
      if (mounted) setState(() {});
    };
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDark = themeManager.isDarkMode;

    final Color scaffoldBgColor = isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB);
    final Color sectionColor = isDark ? AppColor.surfaceColor : Colors.white;
    final Color textColor = isDark ? Colors.white : AppColor.primaryColor;
    final Color dividerColor = isDark ? Colors.white10 : Colors.grey.shade100;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: Text(
            'more'.tr,
            style: const TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2)
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 🔹 Section 1: Support & Info
            _buildSection(sectionColor, isDark, [
              _buildMenuTile(Icons.info_outline_rounded, 'about_app', AppColor.accentGold, textColor, dividerColor, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
              }),
              _buildMenuTile(Icons.auto_awesome_outlined, 'faq', AppColor.accentGold, textColor, dividerColor, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AIChatBotScreen()));
              }),
              _buildMenuTile(Icons.menu_book_rounded, 'how_to_use', AppColor.accentGold, textColor, dividerColor, () {}),
              _buildMenuTile(Icons.verified_user_outlined, 'terms_conditions', AppColor.accentGold, textColor, dividerColor, () {}, isLast: true),
            ]),

            /// 🔹 Section 2: Preferences
            _buildSection(sectionColor, isDark, [
              _buildMenuTile(Icons.translate_rounded, 'change_language', AppColor.accentGold, textColor, dividerColor, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeLanguageScreen()));
              }),
              _buildToggleTile(_isNotificationOn ? Icons.notifications_active_rounded : Icons.notifications_off_rounded, 'notification', _isNotificationOn, AppColor.accentGold, textColor, dividerColor, (val) => setState(() => _isNotificationOn = val)),
              _buildToggleTile(isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded, 'Dark_Mode', isDark, isDark ? Colors.orangeAccent : AppColor.accentGold, textColor, dividerColor, (val) => themeManager.toggleTheme(val), isLast: true),
            ]),

            /// 🔹 Section 3: Connectivity
            _buildSection(sectionColor, isDark, [
              _buildMenuTile(Icons.facebook_rounded, 'social_media', AppColor.accentGold, textColor, dividerColor, () => _launchURL('https://www.facebook.com/nanjinguniversity')),
              _buildMenuTile(null, 'share_app', AppColor.accentGold, textColor, dividerColor, () async {
                const String playStoreLink = 'https://play.google.com/store/apps/details?id=com.nju.app';
                String shareTitle = 'share_title'.tr;
                await Share.share('$shareTitle\n$playStoreLink', subject: 'NANJING UNIVERSITY');
              }, leadingWidget: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColor.accentGold.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.share_rounded, color: AppColor.accentGold, size: 18)
              )),
              _buildMenuTile(Icons.qr_code_scanner_rounded, 'qr_code', AppColor.accentGold, textColor, dividerColor, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QRCodeScreen()));
              }, isLast: true),
            ]),

            const SizedBox(height: 10),
            Text('copyright'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45, fontFamily: 'MaoTi', letterSpacing: 1.5)),
            const SizedBox(height: 5),
            Text('${'version'.tr} 1.0.0', style: TextStyle(fontSize: 10, color: isDark ? Colors.white24 : Colors.black38, fontWeight: FontWeight.bold)),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(Color color, bool isDark, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildMenuTile(IconData? icon, String titleKey, Color iconColor, Color textColor, Color divColor, VoidCallback onTap, {bool isLast = false, Widget? leadingWidget}) {
    return Column(
      children: [
        ListTile(
          leading: leadingWidget ?? Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColor.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(titleKey.tr, style: TextStyle(fontFamily: 'Battambang', fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: textColor.withOpacity(0.3)),
          onTap: onTap,
        ),
        if (!isLast) Divider(height: 1, thickness: 1, color: divColor, indent: 60),
      ],
    );
  }

  Widget _buildToggleTile(IconData icon, String titleKey, bool value, Color iconColor, Color textColor, Color divColor, Function(bool) onChanged, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColor.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: value ? iconColor : Colors.grey.shade400, size: 20),
          ),
          title: Text(titleKey.tr, style: TextStyle(fontFamily: 'Battambang', fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
          trailing: Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.accentGold,
            activeTrackColor: AppColor.accentGold.withOpacity(0.3),
          ),
        ),
        if (!isLast) Divider(height: 1, thickness: 1, color: divColor, indent: 60),
      ],
    );
  }
}