import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart';
import '../../extension/change_notifier.dart';

class ProfileBusStNju extends StatelessWidget {
  const ProfileBusStNju({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, isDark),
            const SizedBox(height: 25),
            _buildQuickActions(isDark),
            const SizedBox(height: 25),
            _buildSettingsList(isDark),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 50,
        left: 30,
        right: 30,
      ),
      decoration: BoxDecoration(
        gradient: BrandGradient.luxury,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(45)),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: AppColor.lightGold,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white24,
              backgroundImage: NetworkImage('https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=Gw8XA4kWnoYQ7kNvwExYIwu&_nc_oc=AdnOTMQyfWOLB_BheKEu5XTcy7QxFX7ZkZdd8bMbnd1rMSQcCoZp87h02O44LaMDPNs&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=7PJE6NZ8oU9kqXNiHwVOJA&oh=00_AfquH0V8VDa1gz_R6Jf0FZqVxTQDK_aV4b2Grzuwp1TaMQ&oe=697FA6B5'),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NJU Student",
                style: TextStyle(
                  color: AppColor.lightGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "ID: 2026123456",
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionIcon(Icons.account_balance_wallet_rounded, "Wallet", Colors.orange),
          _actionIcon(Icons.history_rounded, "History", Colors.blue),
          _actionIcon(Icons.star_rounded, "Saved", Colors.redAccent),
          _actionIcon(Icons.help_center_rounded, "Help", Colors.green),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 10),
        Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.3)
        ),
      ],
    );
  }

  Widget _buildSettingsList(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColor.glassBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            _settingsTile(Icons.notifications_active_rounded, "Notification Settings", isDark),
            _settingsTile(Icons.dark_mode_rounded, "Theme Preferences", isDark),
            _settingsTile(Icons.language_rounded, "Language", isDark),
            _settingsTile(Icons.info_outline_rounded, "About NJU Shuttle", isDark, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, bool isDark, {bool isLast = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isDark ? AppColor.lightGold : AppColor.primaryColor, size: 22),
      ),
      title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColor.primaryColor,
          )
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 22, color: Colors.grey),
      shape: isLast ? null : Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      onTap: () {},
    );
  }
}