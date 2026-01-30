import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';
import 'list_fees.dart';

class HKMacauTaiwanPage extends StatelessWidget {
  const HKMacauTaiwanPage({super.key});

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
          "HK, MACAU & TAIWAN STUDENTS",
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
              "Nanjing University has been admitting students from Hong Kong, Macao, and Taiwan since 1994. "
                  "Currently, 124 students from these regions are registered. "
                  "Admission programs include Joint Enrollment, Exam-free students, and Recommendation from Macao.",
              isDark,
            ),
            _buildSectionHeader("Enrollment Programs", isDark),
            _buildSubHeader("Joint Enrollment", isDark),
            _buildBulletList([
              "High school degree (Grade 6, middle school) required.",
              "Hong Kong/Macao Permanent Identity Card for applicants from Hong Kong/Macao.",
              "Mainland travel permit for Taiwan residents.",
              "Overseas Chinese applicants must have lived abroad >2 years in past 4 years.",
            ], isDark),
            _buildSubHeader("Exam-free Students from Hong Kong", isDark),
            _buildInfoNote(
              "Students with Hong Kong Permanent or Identity Card and Mainland travel permit with HKDSE scores of 4,4,4,4 can apply.",
              isDark,
            ),
            _buildSubHeader("Students by Recommendation from Macao", isDark),
            _buildInfoNote(
              "Students with Macao Permanent or Identity Card and Mainland travel permit whose consolidated high school scores are in the top 10% can apply.",
              isDark,
            ),
            _buildSubHeader("Exam-free Students from Taiwan", isDark),
            _buildInfoNote(
              "High school students graduating in Taiwan or Mainland schools for Taiwan students whose theory test scores reached the top level can apply.",
              isDark,
            ),
            _buildSectionHeader("Undergraduate Programs", isDark),
            _buildInfoNote(
              "Programs and majors for HK, Macau, and Taiwan students are the same as other undergraduates.",
              isDark,
            ),
            // Here we can reuse the same DataTable as your UndergraduateProgramsPage
            _buildProgramsTable(isDark),
            _buildSectionHeader("Tuition and Scholarships", isDark),
            _buildSubHeader("Tuition and Fees", isDark),
            _buildInfoNote(
              "Tuition and accommodation fees are consistent with mainland students. Tuition: 5,200–6,380 yuan/year (Software Engineering Y3-Y4: 16,000 yuan/year). Accommodation: 1,200 yuan/year.",
              isDark,
            ),
            _buildSubHeader("Scholarships", isDark),
            _buildInfoNote(
              "The Student Financial Management Center oversees scholarships. University: 30 scholarships, Department: 30+, Grants: 42 programs. "
                  "Special scholarships for HK, Macao, Taiwan: 1st class 5,000 yuan, 2nd 4,000 yuan, 3rd 3,000 yuan.",
              isDark,
            ),
            _buildSectionHeader("Contact Information", isDark),
            _buildInfoNote(
              "Guangdong Institute of Education and Examination and Mainland Universities Admissions Information Network.",
              isDark,
            ),
            _buildContactCard(
              title: "[Beijing] Beijing University Admissions Office",
              address: "9 Zhixindong Road, Haidian District, Beijing\nPost code: 100083",
              phone: "Tel: (010) 82837212",
              email: "",
              website: "",
              isDark: isDark,
            ),
            _buildContactCard(
              title: "[Shanghai] Shanghai University Admissions Office",
              address: "500 Qinzhounan Road, Shanghai\nPost Code: 200235",
              phone: "Tel: (021) 64946010, (021) 64511200",
              email: "",
              website: "",
              isDark: isDark,
            ),
            _buildContactCard(
              title: "[Fujian] Fujian Institute of Education and Examination",
              address: "59 Beihuanzhong Road\nPost Code: 350003",
              phone: "Tel: (0591) 86215678, Fax: (0591) 87841550",
              email: "",
              website: "",
              isDark: isDark,
            ),
            _buildContactCard(
              title: "[Fujian] Xiamen Admission Committee",
              address: "269 Huojuer Road, Xiamen\nPost Code: 361006",
              phone: "Tel: (0592) 5703107, Fax: (0592) 5703106",
              email: "",
              website: "",
              isDark: isDark,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Section header
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

  // Sub-header
  Widget _buildSubHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 20, 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  // Info note
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

  // Bullet list
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

  // Contact card
  Widget _buildContactCard({
    required String title,
    required String address,
    required String phone,
    String? email,
    String? website,
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
          if (email != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(email,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
            ),
          if (website != null)
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

  Widget _buildProgramsTable(bool isDark) {


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(15),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(BrandGradient.luxury.colors.first.withOpacity(0.2)),
        columnSpacing: 20,
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.w900,
          color: isDark ? AppColor.lightGold : AppColor.primaryColor,
          fontSize: 12,
        ),
        dataTextStyle: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        columns: const [
          DataColumn(label: Text("Program")),
          DataColumn(label: Text("Major")),
          DataColumn(label: Text("Category")),
          DataColumn(label: Text("Length (year)")),
        ],
        rows: programs.map((prog) {
          return DataRow(cells: [
            DataCell(Text(prog['program']!)),
            DataCell(Text(prog['major']!)),
            DataCell(Text(prog['category']!)),
            DataCell(Text(prog['length']!)),
          ]);
        }).toList(),
      ),
    );
  }
}
