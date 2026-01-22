import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/screen/home/home_screen/change_notifier.dart';

import 'package:school_app/screen/home/home_screen/home_screen.dart';
import 'package:school_app/screen/profile_login/profile_page.dart';
import 'menu_screen/menu.dart';

class MainHolder extends StatefulWidget {
  const MainHolder({super.key});

  @override
  State<MainHolder> createState() => _MainHolderState();
}

class _MainHolderState extends State<MainHolder> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const UnifiedLoginScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDark = themeManager.isDarkMode;

     const Color primaryColor = Color(0xFF81005B);
     const Color accentColor = Color(0xFFFF005C);
    final Color navBarColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color fabBgColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final Color fabBorderColor = isDark ? Colors.white10 : Colors.grey.shade300;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: navBarColor,
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 55,
        width: 55,
        child: FloatingActionButton(
          backgroundColor: fabBgColor,
          elevation: 2,
          shape: CircleBorder(
              side: BorderSide(
                  color: _selectedIndex == 1 ? primaryColor : fabBorderColor,
                  width: 2.0
              )
          ),
          onPressed: () => setState(() => _selectedIndex = 1),
          child: Icon(
              Icons.person,
              color: _selectedIndex == 1 ? primaryColor : subTextColor,
              size: 28
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: navBarColor,
        elevation: 5,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        padding: EdgeInsets.zero,
        height: 50,
        child: Row(
          children: [
            _buildNavItem(
              index: 0,
              isDark: isDark,
              label: "home",
              imagePath: 'assets/image/home_icon.png',
              subTextColor: subTextColor,
            ),

            const SizedBox(width: 70),

            _buildNavItem(
              index: 2,
              isDark: isDark,
              label: "more",
              imagePath: 'assets/image/menu_icon.png',
              subTextColor: subTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required bool isDark,
    required String label,
    IconData? icon,
    String? imagePath,
    required Color subTextColor,
  }) {
    bool isActive = _selectedIndex == index;
    final Color activeColor =  Color(0xFF81005B);
    final Color inactiveColor = subTextColor;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imagePath != null
                ? Image.asset(
              imagePath,
              height: 24,
              width: 24,
              color: isActive ? activeColor : inactiveColor,
            )
                : Icon(
              icon,
              color: isActive ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}