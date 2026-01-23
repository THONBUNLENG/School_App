import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../extension/change_notifier.dart';
import '../../home/home_screen/change_language.dart';
import '../../home/home_screen/menu_screen/logout.dart';

const Color nandaPurple = Color(0xFF81005B);

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Settings"),
        elevation: 0,

        backgroundColor: isDark ? Color(0xFF81005B) : Color(0xFF81005B),
        foregroundColor: isDark ? Colors.white : Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Account", isDark),
            const SizedBox(height: 10),
            _buildListTile(
              icon: Icons.person_outline,
              title: "Personal Information",
              subTitle: "Manage your personal details",
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.language_outlined,
              title: "Language",
              subTitle: "Set your preferred language",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangeLanguageScreen()),
              ),
            ),

            const SizedBox(height: 25),

            _buildSectionTitle("Security & Appearance", isDark),
            const SizedBox(height: 10),

            _buildListTile(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: "Dark Mode",
              subTitle: isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
              trailing: Switch(
                value: isDark,
                activeColor: nandaPurple,
                onChanged: (value) => themeManager.toggleTheme(value),
              ),
              onTap: () => themeManager.toggleTheme(!isDark),
            ),

            _buildListTile(
              icon: Icons.logout_rounded,
              title: "Log Out",
              subTitle: "Sign out from your account",
              onTap: () => LogoutDialog.show(context),
            ),

            const SizedBox(height: 25),

            _buildSectionTitle("Security", isDark),
            const SizedBox(height: 10),
            _buildListTile(
              icon: Icons.lock_reset_rounded,
              title: "Change Password",
              subTitle: "Update and secure your account password",
              onTap: () {},
            ),

            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white70 : nandaPurple,
        letterSpacing: 0.5,
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

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: nandaPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: nandaPurple, size: 24),
        ),
        title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            )
        ),
        subtitle: subTitle != null
            ? Text(subTitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54))
            : null,
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}