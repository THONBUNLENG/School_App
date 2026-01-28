import 'package:flutter/material.dart';
import 'package:school_app/quick_access/campus_bus/profile_bus_st_nju.dart';
import 'package:school_app/quick_access/campus_bus/routes_details.dart';
import 'package:school_app/quick_access/campus_bus/timetable_view.dart';
import 'campus_bus_screen.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF252525).withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
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
    final activeColor = const Color(0xFF3476E1);

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
          duration: const Duration(milliseconds: 250),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? activeColor : Colors.grey[400],
                size: isActive ? 28 : 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? activeColor : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}