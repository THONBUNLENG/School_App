import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/personal_information.dart';
import '../../../extension/change_notifier.dart';
import '../../home/home_screen/change_language.dart';
import '../../home/home_screen/menu_screen/logout.dart';

class SettingApp extends StatefulWidget {
  const SettingApp({super.key});

  @override
  State<SettingApp> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingApp> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: const Text(
          "SETTINGS",
          style: TextStyle(
              color: AppColor.lightGold,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.2
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("ACCOUNT", isDark),
            const SizedBox(height: 15),
            _buildListTile(
              icon: Icons.person_outline_rounded,
              title: "Personal Information",
              subTitle: "Manage your student profile details",
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => AppleIDSettings () ));
              },
            ),
            _buildListTile(
              icon: Icons.translate_rounded,
              title: "Language",
              subTitle: "Set your preferred interface language",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangeLanguageScreen()),
              ),
            ),

            const SizedBox(height: 30),

            _buildSectionTitle("PREFERENCES & APPEARANCE", isDark),
            const SizedBox(height: 15),

            _buildListTile(
              icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              title: "Dark Mode",
              subTitle: isDark ? "Switch to Light theme" : "Switch to Dark theme",
              trailing: Switch.adaptive(
                value: isDark,
                activeColor: AppColor.accentGold,
                onChanged: (value) => themeManager.toggleTheme(value),
              ),
              onTap: () => themeManager.toggleTheme(!isDark),
            ),

            _buildListTile(
              icon: Icons.logout_rounded,
              title: "Log Out",
              subTitle: "Sign out securely from your account",
              onTap: () => LogoutDialog.show(context),
            ),

            const SizedBox(height: 30),

            _buildSectionTitle("SECURITY", isDark),
            const SizedBox(height: 15),
            _buildListTile(
              icon: Icons.lock_reset_rounded,
              title: "Change Password",
              subTitle: "Update and secure your NJU account",
              onTap: () {},
            ),

            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const Text(
                    "NANJING UNIVERSITY STUDENT APP",
                    style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(color: isDark ? Colors.white24 : Colors.grey.shade400, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: isDark ? AppColor.lightGold : AppColor.primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subTitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColor.accentGold, size: 22),
        ),
        title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColor.primaryColor,
            )
        ),
        subtitle: subTitle != null
            ? Text(subTitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54))
            : null,
        trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded, color: isDark ? Colors.white24 : Colors.grey.shade300, size: 14),
        onTap: onTap,
      ),
    );
  }
}