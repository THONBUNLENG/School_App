import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';
import 'list_fees.dart';

class GraduateAdmissionsPage extends StatelessWidget {
  const GraduateAdmissionsPage({super.key});

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
          "GRADUATE ADMISSIONS",
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
              "Nanjing University is one of the earliest universities in China to carry out graduate education. "
                  "After the founding of New China, the university resumed its graduate student enrollment in 1954. "
                  "Each year, the university enrolls about 4,000 full-time graduate students (2,100 academic track, 1,900 professional track) "
                  "and 1,400 part-time graduate students. Students will receive both graduation and degree certificates upon completion. "
                  "The university conducts nationwide and local exams for applicants depending on the program, combining written tests, interviews, and foreign language tests.",
              isDark,
            ),
            _buildSectionHeader("Graduate Programs", isDark),
            _buildGraduateProgramsTable(isDark),
            _buildSectionHeader("Contact", isDark),
            _buildContactCard(
              title: "Graduate School",
              address: "Nanjing University",
              phone: "+86-25-89683251 / 83593251",
              email: "njuyzb@163.com",
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

  Widget _buildGraduateProgramsTable(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(
          isDark
              ? Colors.grey.shade900.withOpacity(0.8) // dark mode header
              : BrandGradient.luxury.colors.first.withOpacity(0.2), // light mode header
        ),
        dataRowColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return isDark
                ? Colors.grey.shade700.withOpacity(0.3)
                : Colors.grey.shade200.withOpacity(0.3);
          }
          return isDark ? Colors.grey.withOpacity(0.2) : Colors.white;
        }),
        columnSpacing: 20,
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.w900,
          color: isDark ? AppColor.lightGold : AppColor.primaryColor,
          fontSize: 12,
          letterSpacing: 1,
        ),
        dataTextStyle: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        columns: const [
          DataColumn(label: Text("Disciplinary Category")),
          DataColumn(label: Text("First-Level Discipline")),
          DataColumn(label: Text("Doctoral Degree Discipline / Major")),
          DataColumn(label: Text("Master’s Degree Discipline / Major")),
        ],
        rows: graduatePrograms.map((program) {
          return DataRow(
            cells: [
              DataCell(Text(program['discipline']!)),
              DataCell(Text(program['firstLevel']!)),
              DataCell(Text(program['doctoral']!)),
              DataCell(Text(program['master']!)),
            ],
          );
        }).toList(),
      ),
    );
  }


  Widget _buildContactCard({
    required String title,
    required String address,
    required String phone,
    String? email,
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
          Text(address, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
          const SizedBox(height: 5),
          Text(phone, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
          if (email != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(email, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
            ),
        ],
      ),
    );
  }
}
