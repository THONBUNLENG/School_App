import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';

class InternationalStudentsPage extends StatelessWidget {
  const InternationalStudentsPage({super.key});

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
          "INTERNATIONAL STUDENTS",
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
              "Nanjing University is a top-tier university in China and one of the first to enroll international students. "
                  "Tens of thousands of international students from over 100 countries have studied here, including prominent alumni in politics, business, academia, and other fields.",
              isDark,
            ),
            _buildSectionHeader("Chinese Language & Culture Programs", isDark),
            _buildBulletList([
              "Training site for Chinese Department of the UN",
              "Council on International Education Exchange (CIEE)",
              "Chinese Teaching Association of New York Area",
              "American National Chinese Flagship Program",
              "National test site for HSK, C. Test, TCFL Capability Test",
              "Test participants consistently rank among the highest"
            ], isDark),
            _buildSectionHeader("Other Academic Programs", isDark),
            _buildBulletList([
              "Joint programs: Johns Hopkins University – Nanjing University Center for Chinese and American Studies",
              "Sino-German Institute for Legal Studies",
              "Individual applications accepted for various academic disciplines"
            ], isDark),
            _buildSectionHeader("Institute for International Students", isDark),
            _buildInfoNote(
              "Responsible for enrollment and academic guidance of international students. "
                  "Conducts teaching and research primarily in Chinese language and culture.",
              isDark,
            ),
            _buildSectionHeader("Contact Information", isDark),
            _buildContactCard(
              address: "Zeng Xianzi Building, 18 Jinyin Street, Nanjing 210093, China",
              phone: "+86-25-83594535, +86-25-83593586",
              fax: "+86-25-83316747",
              email: "issd@nju.edu.cn",
              website: "http://iss.nju.edu.cn",
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
          Text("Institute for International Students",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColor.lightGold : AppColor.primaryColor)),
          const SizedBox(height: 10),
          Text(address,
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse("tel:$phone")),
            child: Text(phone,
                style: TextStyle(
                    fontSize: 13,
                    color: AppColor.accentGold,
                    decoration: TextDecoration.underline)),
          ),
          if (fax != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(fax,
                  style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
            ),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse("mailto:$email")),
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.accentGold,
                    decoration: TextDecoration.underline,
                  )),
            ),
          ),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(website)),
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(website,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.accentGold,
                    decoration: TextDecoration.underline,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
