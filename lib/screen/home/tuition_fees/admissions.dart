import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';

class AdmissionsPage extends StatelessWidget {
  const AdmissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFF8F9FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "ADMISSIONS",
          style: TextStyle(
            color: AppColor.lightGold,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Overview of the Undergraduate Admissions", isDark),
            _buildInfoNote(
              "The undergraduate admissions at Nanjing University are carried out by the Undergraduate Admissions Office under the Student Affairs Office. "
                  "The admissions office is also responsible to Nanjing University undergraduate admissions committee and Nanjing University undergraduate admissions leading group.\n\n"
                  "At present, Nanjing University admits about 3,300 undergraduate students each year from 31 provinces in China and from China’s Hong Kong, Macao and Taiwan.",
              isDark,
            ),
            _buildSectionHeader("Types of Recommended Students", isDark),
            _buildBulletList([
              "Students of foreign languages",
              "Students of art majors (Theater, Movie and Television Literature)",
              "Students from high-level art troupes and high-level sports teams",
              "Students enrolled by independent recruitment (special college enrollment plans)",
              "National defense students",
              "Students in special college enrollment plans for poverty-stricken areas",
              "Special Cultivation Plan for Ethnic Minority Regions (including Tibet and Xinjiang enrollment)",
              "Admissions in Hong Kong, Macao, and Taiwan",
            ], isDark),
            _buildSectionHeader("International Students", isDark),
            _buildInfoNote(
              "Nanjing University also enrolls international students through the Institute for International Students.",
              isDark,
            ),
            _buildSectionHeader("Enrollment Numbers", isDark),
            _buildInfoNote(
              "In fall 2016, the university had 32,999 students, including 13,583 undergraduates.",
              isDark,
            ),
            _buildSectionHeader("Contact Information", isDark),
            _buildContactCard(
              title: "Undergraduate Admissions",
              address:
              "Responsible department: Undergraduate Admissions Office, Student Affairs Office, Nanjing University\n"
                  "Address: 4th Floor, Yangzhou Building, 163 Xianlin Avenue, Qixia District, Nanjing City, Jiangsu Province\n"
                  "Postal Code: 210023",
              phone: "Tel: 400-1859680",
              fax: "Fax: +86-25-89686606",
              email: "E-mail: aonju@nju.edu.cn",
              website: "Visit online website for undergraduate admissions",
              isDark: isDark,
            ),
            _buildContactCard(
              title: "International Student Admissions",
              address:
              "Responsible department: Institute for International Students, Nanjing University\n"
                  "Address: 5th Floor, Zeng Xianzi Building, 18 Jinyin Street, Shanghai Road, Nanjing City, Jiangsu Province\n"
                  "Postal Code: 210093",
              phone: "Tel: 86-25-83594535",
              fax: null,
              email: "E-mail: issd@nju.edu.cn",
              website: "Visit online website for international student admissions",
              isDark: isDark,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: isDark ? AppColor.lightGold : AppColor.primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoNote(String text, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.accentGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.accentGold.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.white70 : Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBulletList(List<String> items, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                    )),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String address,
    required String phone,
    String? fax,
    required String email,
    required String website,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColor.lightGold : AppColor.primaryColor)),
          const SizedBox(height: 10),
          Text(address,
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
          const SizedBox(height: 5),
          Text(phone,
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
          if (fax != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(fax,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(email,
                style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(website,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.accentGold,
                  decoration: TextDecoration.underline,
                )),
          ),
        ],
      ),
    );
  }
}
