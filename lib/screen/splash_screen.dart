import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_app/screen/home/home_screen/main_holder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();


    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainHolder()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color nandaPurple = Color(0xFF81005B);

    return Scaffold(
      backgroundColor:  nandaPurple,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Image.asset(
                    'assets/image/logo.png',
                    height: 180,
                  ),
                ),
                const SizedBox(height: 25),

                const Text(
                  '南  京   国  际   学   校',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 2.0
                  ),
                ),
                const Text(
                  'NANJING INTERNATIONAL SCHOOL',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5
                  ),
                ),

                const SizedBox(height: 30),


                const Text(
                  '繁榮、創造力和倫理',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'MaoTi',
                      fontSize: 13,
                      color: Color(0xFFFFF176)
                  ),
                ),
                const Text(
                  'Prosperity, Innovation, and Integrity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFFFF176)
                  ),
                ),

                const SizedBox(height: 50),

                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}