import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import '../../extension/change_notifier.dart';
import 'package:school_app/quick_access/repair_hub/repair_hub.dart';

import '../../screen/home_profile/profile_student.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final pages = const [
    RepairHubScreen(),
    StudentProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return SafeArea(
      child: Container(
        height: 65,
        margin: const EdgeInsets.fromLTRB(50, 0, 50, 20),
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
            _navItem(Icons.home_rounded, 0, "Home"),
            Container(width: 1, height: 25, color: Colors.white10),
            _navItem(Icons.person_rounded, 1, "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, String label) {
    bool isActive = _index == index;
    final activeColor = AppColor.lightGold;
    final inactiveColor = Colors.white.withOpacity(0.5);

    return GestureDetector(
      onTap: () => setState(() => _index = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 3,
              width: isActive ? 15 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 6),
            Icon(
              icon,
              color: isActive ? activeColor : inactiveColor,
              size: isActive ? 28 : 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}