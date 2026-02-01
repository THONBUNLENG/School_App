import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/extension/string_extension.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> features = const [
    {'icon': Icons.science_outlined, 'title': 'science_title', 'desc': 'science_desc'},
    {'icon': Icons.engineering_outlined, 'title': 'engineering_title', 'desc': 'engineering_desc'},
    {'icon': Icons.medical_services_outlined, 'title': 'medicine_title', 'desc': 'medicine_desc'},
    {'icon': Icons.computer_outlined, 'title': 'computer_title', 'desc': 'computer_desc'},
    {'icon': Icons.calculate_outlined, 'title': 'math_title', 'desc': 'math_desc'},
    {'icon': Icons.biotech_outlined, 'title': 'biology_title', 'desc': 'biology_desc'},
    {'icon': Icons.public_outlined, 'title': 'environment_title', 'desc': 'environment_desc'},
    {'icon': Icons.account_balance_outlined, 'title': 'humanities_title', 'desc': 'humanities_desc'},
    {'icon': Icons.gavel_outlined, 'title': 'law_title', 'desc': 'law_desc'},
    {'icon': Icons.business_center_outlined, 'title': 'business_title', 'desc': 'business_desc'},
    {'icon': Icons.language_outlined, 'title': 'language_title', 'desc': 'language_desc'},
    {'icon': Icons.psychology_outlined, 'title': 'psychology_title', 'desc': 'psychology_desc'},
    {'icon': Icons.auto_awesome_outlined, 'title': 'ai_title', 'desc': 'ai_desc'},
    {'icon': Icons.architecture_outlined, 'title': 'architecture_title', 'desc': 'architecture_desc'},
    {'icon': Icons.history_edu_outlined, 'title': 'history_title', 'desc': 'history_desc'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(

      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// 🔹 Custom Sliver App Bar (Luxury NJU Style)
          SliverAppBar(
            expandedHeight: 270,
            pinned: true,
            stretch: true,
            backgroundColor: AppColor.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              centerTitle: true,
              title: Text(

                'about_app'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColor.lightGold,
                  letterSpacing: 1.0,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: BrandGradient.luxury,
                    ),
                  ),
                  // Logo & Text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(height: 40),
                      Image(
                        image: AssetImage('assets/image/logo.png'),
                        width: 90,
                        height: 90,
                      ),
                      SizedBox(height: 15),
                      Text(
                        '南京大學',
                        style: TextStyle(
                          fontFamily: 'MaoTi',
                          fontSize: 28,
                          color: AppColor.lightGold,
                          letterSpacing: 8,
                        ),
                      ),
                      Text(
                        'NANJING UNIVERSITY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white70,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 Feature List Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = features[index];
                  return _buildAnimatedCard(
                    index,
                    item['icon'] as IconData,
                    (item['title'] as String).tr,
                    (item['desc'] as String).tr,
                    isDark,
                  );
                },
                childCount: features.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Animated Card with Premium Design
  Widget _buildAnimatedCard(int index, IconData icon, String title, String desc, bool isDark) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final start = (index * 0.05).clamp(0.0, 1.0);
        final end = (start + 0.4).clamp(0.0, 1.0);
        final curve = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutQuart),
        );

        return Opacity(
          opacity: curve.value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - curve.value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: AppColor.primaryColor.withOpacity(0.05),
          ),
          child: ExpansionTile(
            iconColor: AppColor.accentGold,
            collapsedIconColor: Colors.grey.shade400,
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: isDark ? AppColor.lightGold : AppColor.primaryColor, size: 24),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isDark ? Colors.white : AppColor.primaryColor,
                letterSpacing: 0.3,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                child: Text(
                  desc,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.7,
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontFamily: 'Battambang',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}