import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/extension/change_notifier.dart';
import 'package:school_app/screen/home/home_screen/home_screen.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/home_profile_screen.dart';
import 'package:school_app/screen/home/home_screen/menu_screen/menu.dart';

class MainHolder extends StatefulWidget {
  const MainHolder({super.key});

  @override
  State<MainHolder> createState() => _MainHolderState();
}

class _MainHolderState extends State<MainHolder> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SizedBox.shrink(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDark = themeManager.isDarkMode;

    final Color navBarColor = isDark ? AppColor.surfaceColor : Colors.white;
    final Color subTextColor = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : Colors.grey.shade50,
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 64,
        width: 64,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColor.backgroundColor : Colors.grey.shade50,
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          backgroundColor: navBarColor,
          elevation: 2,
          shape: CircleBorder(
              side: BorderSide(color: AppColor.glassBorder, width: 1.5)
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeProfileScreen()),
            );
          },
          child: Icon(
              Icons.person_rounded,
              color: subTextColor,
              size: 30
          ),
        ),
      ),

      // --- Bottom Navigation Bar (Fixed Overflow) ---
      bottomNavigationBar: BottomAppBar(
        color: navBarColor,
        elevation: 20,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        height: 70,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              label: "HOME",
              iconData: Icons.home_rounded,
              subTextColor: subTextColor,
            ),

            // 💡 ចន្លោះទទេសម្រាប់ Notch (FAB)
            const SizedBox(width: 80),

            _buildNavItem(
              index: 2,
              label: "MORE",
              iconData: Icons.grid_view_rounded,
              subTextColor: subTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData iconData,
    required Color subTextColor,
  }) {
    bool isActive = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // 💡 សំខាន់បំផុត៖ ការពារ Overflow Error
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4),
              child: Icon(
                iconData,
                color: isActive ? AppColor.accentGold : subTextColor,
                size: 24,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w500,
                color: isActive ? AppColor.accentGold : subTextColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              width: isActive ? 12 : 0,
              decoration: BoxDecoration(
                color: AppColor.accentGold,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}