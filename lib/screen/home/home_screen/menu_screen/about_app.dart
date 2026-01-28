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
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF1F5F9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// 🔹 Custom Sliver App Bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            backgroundColor: AppColor.primaryColor,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              centerTitle: true,
              title: Text(
                'about_app'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Kantumruy Pro',
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColor.primaryColor, Color(0xFF800000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Logo & Text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(height: 30),
                      Image(
                        image: AssetImage('assets/image/logo.png'),
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 12),
                      Text(
                        '南京大學',
                        style: TextStyle(
                          fontFamily: 'MaoTi',
                          fontSize: 26,
                          color: Colors.white,
                          letterSpacing: 6,
                        ),
                      ),
                      Text(
                        'NANJING UNIVERSITY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          letterSpacing: 1.2,
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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
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

  /// 🔹 Animated Card with ExpansionTile
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
            offset: Offset(0, 30 * (1 - curve.value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isDark ? Border.all(color: Colors.white10) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: AppColor.accentGold,
            collapsedIconColor: Colors.grey,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.accentGold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColor.accentGold, size: 24),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black87,
                fontFamily: 'Kantumruy Pro',
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  desc,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: isDark ? Colors.white60 : Colors.black54,
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