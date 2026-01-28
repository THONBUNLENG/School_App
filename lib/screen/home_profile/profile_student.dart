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
    final Color textColor = isDark ? Colors.white : Colors.black87;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text("Student Profile", style: TextStyle(fontWeight: FontWeight.bold)

          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColor.primaryColor,
          foregroundColor:Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_note),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileStudent())),
            )
          ],
        ),
        body: Column(
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CampusCardHeader()
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProfileContent(textColor, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(Color textColor, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Personal Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 10),
          _infoTile(Icons.school_outlined, "Faculty", "Computer Science", textColor),
          _infoTile(Icons.class_outlined, "Class", "CS Generation 21", textColor),
          const Divider(height: 20),
          _infoTile(Icons.email_outlined, "Email", "austin.carr@example.com", textColor),
          _infoTile(Icons.phone_android_outlined, "Phone", "+855 12 345 678 999", textColor),
          _infoTile(Icons.location_on_outlined, "Address", "Phnom Penh, Cambodia", textColor),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String val, Color textColor) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColor.accentGold, size: 20),
      title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      subtitle: Text(val, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}