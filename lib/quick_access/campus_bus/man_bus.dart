import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart';
import '../../extension/change_notifier.dart';
import 'campus_bus_screen.dart';
import 'package:school_app/quick_access/campus_bus/profile_bus_st_nju.dart';
import 'package:school_app/quick_access/campus_bus/routes_details.dart';
import 'package:school_app/quick_access/campus_bus/timetable_view.dart';

class Main_Bus extends StatefulWidget {
  const Main_Bus({super.key});

  @override
  State<Main_Bus> createState() => _MainHolderState();
}

class _MainHolderState extends State<Main_Bus> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MainBusScreen(),
    const TimetableView(),
    const RoutesDetailsPage(),
    const ProfileBusStNju(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return SafeArea(
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          gradient: BrandGradient.luxury,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(isDark ? 0.5 : 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],

          border: Border.all(color: AppColor.glassBorder, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(Icons.map_rounded, 0, "Map"),
            _navItem(Icons.access_time_filled, 1, "Time"),
            _navItem(Icons.alt_route_rounded, 2, "Routes"),
            _navItem(Icons.person_rounded, 3, "Me"),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, String label) {
    bool isActive = _currentIndex == index;


    final Color activeColor = AppColor.lightGold;
    final Color inactiveColor = Colors.white.withOpacity(0.5);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                width: isActive ? 20 : 0,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 6),
              Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: isActive ? 26 : 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? activeColor : inactiveColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}