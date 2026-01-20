import 'package:flutter/material.dart';
import 'package:school_app/extension/string_extension.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

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

    const Color primaryColor = Color(0xFF005696);
    const Color accentColor = Color(0xFF00AEEF);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: primaryColor,
            centerTitle: true,

            leading: const BackButton(color: Colors.white),
            title: Text(
              'about_app'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Kantumruy Pro',
                color: Colors.white,
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [

                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, accentColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'app_logo',
                          child: Image.asset(
                            'assets/image/logo_beltel_school.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        const Text(
                          'សាលា ប៊ែលធី អន្តរជាតិ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kantumruy Pro'
                          ),
                        ),
                        const Text(
                          'BELTEI INTERNATIONAL SCHOOL',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5
                          ),
                        ),
                        const Text(
                          '贝尔 蒂 国 际 学 校',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              letterSpacing: 1.5
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final features = [
                    {'icon': Icons.school_outlined, 'title': 'general_education_title', 'desc': 'general_education_desc'},
                    {'icon': Icons.language_outlined, 'title': 'english_program_title', 'desc': 'english_program_desc'},
                    {'icon': Icons.translate_outlined, 'title': 'chinese_program_title', 'desc': 'chinese_program_desc'},
                    {'icon': Icons.auto_awesome_outlined, 'title': 'ima_program_title', 'desc': 'ima_program_desc'},
                  ];

                  if (index >= features.length) return null;

                  final item = features[index];
                  return _buildAnimatedExpandableCard(
                    index,
                    item['icon'] as IconData,
                    (item['title'] as String).tr,
                    (item['desc'] as String).tr,
                    isDark,
                  );
                },
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAnimatedExpandableCard(int index, IconData icon, String title, String desc, bool isDark) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double start = index * 0.15;
        final double end = (start + 0.5).clamp(0.0, 1.0);
        final curve = CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeOutCubic));

        return Opacity(
          opacity: curve.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - curve.value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF00AEEF).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: const Color(0xFF00AEEF), size: 24),
            ),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87, fontFamily: 'Kantumruy Pro')),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text(desc, style: TextStyle(fontSize: 13, height: 1.6, color: isDark ? Colors.white70 : Colors.black54, fontFamily: 'Battambang'), textAlign: TextAlign.justify),
              ),
            ],
          ),
        ),
      ),
    );
  }
}