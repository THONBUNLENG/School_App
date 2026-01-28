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

    final Color scaffoldBgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final Color sectionColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white70 : Colors.black87;
    final Color dividerColor = isDark ? Colors.white10 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text('more'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildSection(sectionColor, isDark, [
              _buildMenuTile(Icons.info_outline, 'about_app', AppColor.accentGold, textColor, dividerColor, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
              }),
              _buildMenuTile(Icons.chat_bubble_outline, 'faq', AppColor.accentGold, textColor, dividerColor, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AIChatBotScreen()));
              }),
              _buildMenuTile(Icons.help_outline, 'how_to_use', AppColor.accentGold, textColor, dividerColor, () {}),
              _buildMenuTile(Icons.description_outlined, 'terms_conditions', AppColor.accentGold, textColor, dividerColor, () {}, isLast: true),
            ]),

            _buildSection(sectionColor, isDark, [
              _buildMenuTile(Icons.translate, 'change_language', AppColor.accentGold, textColor, dividerColor, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeLanguageScreen()));
              }),
              _buildToggleTile(_isNotificationOn ? Icons.notifications_active : Icons.notifications_off, 'notification', _isNotificationOn, AppColor.accentGold, textColor, dividerColor, (val) => setState(() => _isNotificationOn = val)),
              _buildToggleTile(isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined, 'Dark_Mode', isDark, isDark ? Colors.orangeAccent : AppColor.accentGold, textColor, dividerColor, (val) => themeManager.toggleTheme(val), isLast: true),
            ]),

            _buildSection(sectionColor, isDark, [
              _buildMenuTile(Icons.language, 'social_media', AppColor.accentGold, textColor, dividerColor, () => _launchURL('https://www.facebook.com/belteigroups')),
              _buildMenuTile(null, 'share_app', AppColor.accentGold, textColor, dividerColor, () async {
                const String playStoreLink = 'https://play.google.com/store/apps/details?id=com.beltei.school';
                String shareTitle = 'share_title'.tr;
                await Share.share('$shareTitle\n$playStoreLink', subject: 'NANJING International University');
              }, leadingWidget: ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.asset('', width: 22, height: 22, errorBuilder: (context, error, stackTrace) => Icon(Icons.share, color: AppColor.accentGold)))),
              _buildMenuTile(Icons.qr_code_scanner, 'qr_code',AppColor.accentGold, textColor, dividerColor, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QRCodeScreen ()));
              }, isLast: true),
            ]),

            const SizedBox(height: 30),
            Text('copyright'.tr, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.black45, fontFamily: 'MaoTi')),
            const SizedBox(height: 8),
            Text('${'version'.tr} 1.0.0', style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.black38, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuTile(IconData? icon, String titleKey, Color iconColor, Color textColor, Color divColor, VoidCallback onTap, {bool isLast = false, Widget? leadingWidget}) {
    return Column(
      children: [
        ListTile(
          leading: leadingWidget ?? Icon(icon, color: iconColor, size: 22),
          title: Text(titleKey.tr, style: TextStyle(fontFamily: 'Battambang', fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
          trailing: Icon(Icons.arrow_forward_ios, size: 14, color: textColor.withOpacity(0.5)),
          onTap: onTap,
        ),
        if (!isLast) Divider(height: 1, thickness: 0.5, color: divColor, indent: 55),
      ],
    );
  }

  Widget _buildToggleTile(IconData icon, String titleKey, bool value, Color iconColor, Color textColor, Color divColor, Function(bool) onChanged, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: value ? iconColor : Colors.grey, size: 22),
          title: Text(titleKey.tr, style: TextStyle(fontFamily: 'Battambang', fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
          trailing: Switch.adaptive(value: value, onChanged: onChanged, activeColor: iconColor),
        ),
        if (!isLast) Divider(height: 1, thickness: 0.5, color: divColor, indent: 55),
      ],
    );
  }
}