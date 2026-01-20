import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:school_app/extension/string_extension.dart';
import '../home/home_screen/change_notifier.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDark = themeManager.isDarkMode;


    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color welcomeTextColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white70 : Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/image/beltil_bui3.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF005696)),
                  ),
                  Container(color: const Color(0xFF005696).withOpacity(0.65)),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(color: Colors.transparent),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _iconButton(Icons.group),
                    ],
                  ),
                ),

                Image.asset(
                  'assets/image/logo_beltel_school.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, size: 80, color: Colors.white),
                ),

                const SizedBox(height: 10),
                const Text('សាលា ប៊ែលធី អន្តរជាតិ', style: TextStyle(fontFamily: 'Battambang', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('BELTEI INTERNATIONAL SCHOOL', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const Text('贝 蒂 国 际 学 校', style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 2)),

                const Spacer(),

                Text(
                  'Welcome',
                  style: TextStyle(fontFamily: 'Battambang', fontSize: 26, fontWeight: FontWeight.bold, color: welcomeTextColor),
                ),
                Text(
                  'Please select an account',
                  style: TextStyle(fontFamily: 'Battambang', color: subTextColor, fontSize: 16),
                ),
                const SizedBox(height: 25),


                _accountButton('STUDENT', 'assets/image/student.png', isDark),
                _accountButton('PARENT', 'assets/image/parent.png', isDark),
                _accountButton('TEACHER', 'assets/image/teacher.png', isDark),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountButton(String titleKey, String iconPath, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(

          backgroundColor: isDark ? const Color(0xFF0086C2) : const Color(0xFF00AEEF),
          foregroundColor: Colors.white,
          elevation: isDark ? 0 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(Icons.person, size: 18, color: Colors.grey)
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              titleKey.tr,
              style: const TextStyle(
                  fontFamily: 'Battambang',
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
      padding: const EdgeInsets.all(8),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}