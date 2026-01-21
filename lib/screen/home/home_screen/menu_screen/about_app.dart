import 'package:flutter/material.dart';
import 'package:school_app/extension/string_extension.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  static const Color primaryColor = Color(0xFF81005B);
  static const Color accentColor = Color(0xFFFF005C);

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
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// 🔹 APP BAR
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: primaryColor,
            leading: const BackButton(color: Colors.white),
            centerTitle: true,
            title: Text(
              'about_app'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Kantumruy Pro',
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, accentColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(height: 60),
                    Image(
                      image: AssetImage('assets/image/logo.png'),
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 15),
                    Text(
                      '南京大學',
                      style: TextStyle(
                        fontFamily: 'MaoTi',
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 8,
                      ),
                    ),
                    Text(
                      'NANJING UNIVERSITY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 🔹 FEATURE LIST
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = features[index];
                  return _buildAnimatedExpandableCard(
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

  /// 🔹 CARD
  Widget _buildAnimatedExpandableCard(
      int index,
      IconData icon,
      String title,
      String desc,
      bool isDark,
      ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final start = index * 0.08;
        final end = (start + 0.4).clamp(0.0, 1.0);
        final curve = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

        return Opacity(
          opacity: curve.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - curve.value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor),
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                desc,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontFamily: 'Battambang',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
