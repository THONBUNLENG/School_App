import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/screen/home/contacts/ways_of_giving.dart';
import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';
import 'contact_us.dart';
import 'learn_more.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _whyGivingKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.backgroundColor : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildMainHeader(),
          SliverToBoxAdapter(child: _buildNavigationMenu(isDark)),

          /// 🔑 Why Giving Section
          SliverToBoxAdapter(
            child: Container(
              key: _whyGivingKey,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Why Giving",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _sectionText(
                    "Fundraising",
                    "In the history of Nanjing University’s development, we have received great support both from governments of different levels and from society. To build ours into a world-class university, we need large amounts of financial support. Adequate funding is the primary guarantee for the reform and development of the university.",
                    isDark,
                  ),
                  _sectionText(
                    "Student Cultivation",
                    "A nation’s prosperity and progress relies on talents cultivated by universities. NJUEDF is committed to enabling students to take part in overseas exchange programs and international conferences, create scholarships and student aid, and establish overseas-exchange-and-student-activity funds to broaden their horizons and improve their social and innovation skills.",
                    isDark,
                  ),
                  _sectionText(
                    "Faculty Development",
                    "A first-class university requires first-class faculty. By establishing various research grants, honored professorships, and talent support plans, the university attracts influential teaching and research faculty and stimulates the vitality of the whole university community.",
                    isDark,
                  ),
                  _sectionText(
                    "Subject Support",
                    "Nanjing University emphasizes the content and quality of development. Major breakthroughs are to be made especially in the development of fundamental subjects. Such exploration requires long-term support from alumni and friends.",
                    isDark,
                  ),
                  _sectionText(
                    "Campus Construction",
                    "Nanjing University has three campuses, Gulou, Pukou and Xianlin. To create a good working and learning environment for all teachers and students, support for campus construction is always an important aspect of fundraising.",
                    isDark,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          /// Add extra space to allow scrolling
          SliverToBoxAdapter(
            child: SizedBox(height: 400),
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
          "Contacts",
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
              child: Icon(Icons.call, size: 150, color: Colors.white.withOpacity(0.05)),
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
      {"title": "Why Giving", "isScroll": true, "key": _whyGivingKey},
      {"title": "Ways of Giving", "page": const WaysOfGivingPage()},
      {"title": "Contact Us", "page": const ContactUsPage ()},
      {"title": "Learn More", "page": const LearnMorePage ()},
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
                if (item["isScroll"] == true && item["key"].currentContext != null) {
                  Scrollable.ensureVisible(
                    item["key"].currentContext!,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item["page"]),
                  );
                }
              },
              backgroundColor: isDark ? AppColor.surfaceColor : AppColor.primaryColor,
              label: Text(
                item["title"],
                style: TextStyle(
                  color: isDark ? AppColor.lightGold : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 2,
            ),
          );
        },
      ),
    );
  }

  Widget _sectionText(String title, String content, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.accentGold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Dummy Page")),
    );
  }
}
