import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/screen/home/tuition_fees/tuition.dart';
import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';
import 'admissions.dart';
import 'undergraduate.dart';
import 'scholarships_grants.dart';
import 'hk_macau_taiwan_student.dart';
import 'graduate.dart';
import 'internatonal_student.dart';

class TuitionPage extends StatefulWidget {
  const TuitionPage({super.key});

  @override
  State<TuitionPage> createState() => _TuitionPageState();
}

class _TuitionPageState extends State<TuitionPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _undergradKey = GlobalKey();
  final GlobalKey _tuitionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildMainHeader(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavigationMenu(isDark),

                _buildSectionHeader(
                    "1. Undergraduate Programs",
                    isDark,
                    key: _undergradKey
                ),

                _buildInfoNote(
                  "• Dormitory fee: 1,200 Yuan / school year.\n"
                      "• Software Engineering (Y3-Y4) costs 16,000 Yuan/year.",
                  isDark,
                ),


                TuitionTableWidget(isDark: isDark, key: _tuitionKey),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainHeader() {
    return SliverAppBar(
      expandedHeight: 180.0,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          "TUITION & FEES",
          style: TextStyle(
            color: AppColor.lightGold,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(decoration: const BoxDecoration(gradient: BrandGradient.luxury)),
            Positioned(
              right: -20,
              top: -20,
              child: Icon(Icons.account_balance_rounded, size: 150, color: Colors.white.withOpacity(0.05)),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildNavigationMenu(bool isDark) {
    final List<Map<String, dynamic>> menuItems = [
      {"title": "Tuition", "isScroll": true, "key": _tuitionKey},
      {"title": "Undergraduate", "page": const UndergraduateFullPage()},
      {"title": "Admissions", "page": const AdmissionsPage()},
      {"title": "Scholarships", "page": const ScholarshipsPage()},
      {"title": "HK/Macau/Taiwan", "page": const HKMacauTaiwanPage()},
      {"title": "Graduate", "page": const GraduateAdmissionsPage()},
      {"title": "International", "page": const InternationalStudentsPage()},
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ActionChip(
              onPressed: () {
                if (item["isScroll"] == true) {
                  Scrollable.ensureVisible(
                    item["key"].currentContext!,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => item["page"]));
                }
              },
              backgroundColor: isDark ? AppColor.surfaceColor : AppColor.primaryColor,
              label: Text(
                item["title"],
                style: TextStyle(
                    color: isDark ? AppColor.lightGold : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
              elevation: 2,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, color: AppColor.accentGold, size: 22),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isDark ? AppColor.lightGold : AppColor.primaryColor,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNote(String text, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.accentGold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.accentGold.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white70 : Colors.black87,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}