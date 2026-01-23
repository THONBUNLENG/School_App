import 'package:flutter/material.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/detail_screen.dart';

import 'man_screen_user.dart';


class HomeProfileScreen extends StatefulWidget {
  const HomeProfileScreen({super.key});

  @override
  State<HomeProfileScreen> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<HomeProfileScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ManScreenUser(),
    Center(child: Text("Messages Screen", style: TextStyle(fontSize: 24))),
    Center(child: Text("Profile Screen", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFFD1C4E9),
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem("Home", 0),
          _navItem("Messages", 1),
          _navItem("Profile", 2),
        ],
      ),
    );
  }

  Widget _navItem(String label, int index) {
    final bool active = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF6A51A3) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF6A51A3),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


