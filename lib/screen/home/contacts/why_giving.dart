import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';

class WhyGivingPage extends StatelessWidget {
  const WhyGivingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.backgroundColor : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildHeader(context), // ✅ pass context
          SliverToBoxAdapter(
            child: Column(
              children: [
                _sectionCard(
                  "Fundraising",
                  "In the history of Nanjing University’s development, we have received great support both from governments of different levels and from society. To build ours into a world-class university, we need large amounts of financial support. Adequate funding is the primary guarantee for the reform and development of the university.",
                  isDark,
                ),
                _sectionCard(
                  "Student Cultivation",
                  "A nation’s prosperity and progress relies on talents cultivated by universities. NJUEDF is committed to enabling students to take part in overseas exchange programs and international conferences, create scholarships and student aid, and establish overseas-exchange-and-student-activity funds to broaden their horizons and improve their social and innovation skills.",
                  isDark,
                ),
                _sectionCard(
                  "Faculty Development",
                  "A first-class university requires first-class faculty. By establishing various research grants, honored professorships, and talent support plans, the university attracts influential teaching and research faculty and stimulates the vitality of the whole university community.",
                  isDark,
                ),
                _sectionCard(
                  "Subject Support",
                  "Nanjing University emphasizes the content and quality of development. Major breakthroughs are to be made especially in the development of fundamental subjects. Such exploration requires long-term support from alumni and friends.",
                  isDark,
                ),
                _sectionCard(
                  "Campus Construction",
                  "Nanjing University has three campuses, Gulou, Pukou and Xianlin. To create a good working and learning environment for all teachers and students, support for campus construction is always an important aspect of fundraising.",
                  isDark,
                ),
                _sectionCard(
                  "Nanjing University Development Fund",
                  "The university has established a Development Fund with undesignated donations to meet important and urgent needs concerning the university’s development.",
                  isDark,
                ),
                _sectionCard(
                  "School/Department Development Fund",
                  "These funds support subject development, talent cultivation, invitation of well-known scholars, scholarships, academic conferences, and innovation research.",
                  isDark,
                ),
                _sectionCard(
                  "Communication & Cooperation",
                  "Nanjing University Education Foundation (USA) and Hong Kong-based fundraising networks help develop global financing channels and deepen cooperation with people from all walks of life.",
                  isDark,
                ),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ✅ CONTEXT PASSED IN
  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Why Giving",
          style: TextStyle(
            color: AppColor.lightGold,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: BrandGradient.luxury,
          ),
          child: const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.volunteer_activism,
                  size: 120, color: Colors.white12),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            color: AppColor.lightGold, size: 20),
        onPressed: () {
          Navigator.pop(context); // ✅ now valid
        },
      ),
    );
  }

  Widget _sectionCard(String title, String text, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.accentGold.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: AppColor.accentGold, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: AppColor.accentGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              height: 1.7,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
