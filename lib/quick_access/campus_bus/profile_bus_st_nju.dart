import 'package:flutter/material.dart';

class ProfileBusStNju extends StatelessWidget {
  const ProfileBusStNju({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, isDark),
            const SizedBox(height: 20),
            _buildQuickActions(isDark),
            const SizedBox(height: 20),
            _buildSettingsList(isDark),
            const SizedBox(height: 40), // Spacing for the floating nav bar
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
        bottom: 40,
        left: 30,
        right: 30,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1B263B), const Color(0xFF0D1B2A)]
              : [const Color(0xFF3476E1), const Color(0xFF67B0F5)],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            backgroundImage: NetworkImage('https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=Gw8XA4kWnoYQ7kNvwExYIwu&_nc_oc=AdnOTMQyfWOLB_BheKEu5XTcy7QxFX7ZkZdd8bMbnd1rMSQcCoZp87h02O44LaMDPNs&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=7PJE6NZ8oU9kqXNiHwVOJA&oh=00_AfquH0V8VDa1gz_R6Jf0FZqVxTQDK_aV4b2Grzuwp1TaMQ&oe=697FA6B5'),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "NJU Student",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "ID: 2026123456",
                style: TextStyle(color: Colors.white70, fontSize: 14),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionIcon(Icons.account_balance_wallet, "Wallet", Colors.orange),
          _actionIcon(Icons.history, "History", Colors.blue),
          _actionIcon(Icons.star, "Saved", Colors.red),
          _actionIcon(Icons.help_outline, "Help", Colors.green),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSettingsList(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          _settingsTile(Icons.notifications_active, "Notification Settings", isDark),
          _settingsTile(Icons.dark_mode, "Theme Preferences", isDark),
          _settingsTile(Icons.language, "Language", isDark),
          _settingsTile(Icons.info_outline, "About NJU Shuttle", isDark, isLast: true),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, bool isDark, {bool isLast = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade300),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      shape: isLast ? null : Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      onTap: () {},
    );
  }
}