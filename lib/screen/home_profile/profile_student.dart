import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import '../../../extension/change_notifier.dart';
import 'card_student.dart';
import 'edit_profile.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeManager>(context);
    final isDark = theme.isDarkMode;
    final Color textColor = isDark ? Colors.white : AppColor.primaryColor;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: const Text(
            "STUDENT PROFILE",
            style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: AppColor.lightGold, size: 28),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileStudent())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CampusCardHeader()
            ),

            _buildProfileContent(textColor, isDark, context),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(Color textColor, bool isDark, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Label
          Row(
            children: [
              const Icon(Icons.badge_rounded, color: AppColor.accentGold, size: 20),
              const SizedBox(width: 10),
              Text(
                  "PERSONAL INFORMATION",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isDark ? AppColor.lightGold : AppColor.primaryColor,
                    letterSpacing: 1.2,
                  )
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Information Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColor.surfaceColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.glassBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              children: [
                _infoTile(Icons.school_rounded, "Faculty", "Computer Science", textColor, isDark),
                _divider(),
                _infoTile(Icons.hub_rounded, "Class", "CS Generation 21", textColor, isDark),
                _divider(),
                _infoTile(Icons.email_rounded, "Email", "austin.carr@example.com", textColor, isDark),
                _divider(),
                _infoTile(Icons.phone_android_rounded, "Phone", "+855 12 345 678", textColor, isDark),
                _divider(),
                _infoTile(Icons.location_on_rounded, "Address", "Phnom Penh, Cambodia", textColor, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String val, Color textColor, bool isDark) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColor.accentGold, size: 20),
      ),
      title: Text(label, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
      subtitle: Text(val, style: TextStyle(color: isDark ? Colors.white : AppColor.primaryColor, fontWeight: FontWeight.w900, fontSize: 14)),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Divider(height: 1, thickness: 1, color: AppColor.glassBorder),
    );
  }
}