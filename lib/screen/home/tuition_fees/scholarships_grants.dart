import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';

class ScholarshipsPage extends StatelessWidget {
  const ScholarshipsPage({super.key});

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
          "SCHOLARSHIPS & GRANTS",
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
            _buildSectionHeader("Overview", isDark),
            _buildInfoNote(
              "The Student Financial Aid Center, under the Student Affairs Office, is responsible for matters concerning scholarships and grants of undergraduates studying in Nanjing University.",
              isDark,
            ),
            _buildSectionHeader("University and School-Level Scholarships", isDark),
            _buildInfoNote(
              "The university has established 30 university-level scholarships programs, over 30 school-level scholarships programs, and 42 grant programs. "
                  "With a total of more than 30 million yuan each year, more than half of the students can receive these scholarships and grants, "
                  "among which the highest scholarship reaches 20,000 yuan and the highest grant reaches 10,000 yuan.",
              isDark,
            ),
            _buildSectionHeader("Additional Financial Aid", isDark),
            _buildBulletList([
              "National Student Loan (up to 8,000 yuan per year)",
              "Work-study program (over 1,500 jobs on campus)",
              "Tuition remission",
              "Interim grants for needy students",
              "Green channel support",
            ], isDark),
            _buildSectionHeader("International Exchange Scholarships", isDark),
            _buildInfoNote(
              "Since 2011, the university has established several international exchange scholarships including:\n"
                  "- Zhenxing international exchange scholarship\n"
                  "- Zhang Jiahe international exchange scholarship\n"
                  "- Shanyuan international exchange scholarship\n"
                  "- Sun Dalun scholarship (for exchanges in Hong Kong, Macao, Taiwan)\n"
                  "- Xu Xin international exchange scholarship\n\n"
                  "These scholarships offer amounts ranging from 25,000 to 60,000 yuan and provide financial aid for students from poor families to study, research, complete internships, or pursue a degree at top universities worldwide.",
              isDark,
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
            .map((item) => Padding(
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
        ))
            .toList(),
      ),
    );
  }
}
