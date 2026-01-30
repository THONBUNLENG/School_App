import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart'; // ប្រើ AppColor & BrandGradient របស់អ្នក
import '../../../../extension/change_notifier.dart'; // សម្រាប់ check isDarkMode
import '../courese.dart';
import '../profile_student.dart';
import 'man_screen_user.dart';

class HomeProfileScreen extends StatefulWidget {
  const HomeProfileScreen({super.key});

  @override
  State<HomeProfileScreen> createState() => _HomeProfileScreenState();
}

class _HomeProfileScreenState extends State<HomeProfileScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ManScreenUser(),
        CoursePageFix(),
      const StudentProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildFloatingNavBar(isDark),
    );
  }

  Widget _buildFloatingNavBar(bool isDark) {
    return SafeArea(
      child: Container(
        height: 65,
        margin: const EdgeInsets.fromLTRB(40, 0, 40, 25),
        decoration: BoxDecoration(

          gradient: BrandGradient.luxury,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: AppColor.glassBorder, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem("Home", 0),
            _navItem("Course", 1),
            _navItem("Profile", 2),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String label, int index) {
    final bool active = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          // បន្ថែមពន្លឺតិចៗនៅពីក្រោយអក្សរដែលបានជ្រើសរើស
          color: active ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: active ? AppColor.lightGold : Colors.white60,
                fontWeight: active ? FontWeight.w900 : FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2.5,
              width: active ? 12 : 0,
              decoration: BoxDecoration(
                color: AppColor.lightGold,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  if (active)
                    const BoxShadow(color: AppColor.accentGold, blurRadius: 4)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}