import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/screen/home/home_screen/change_notifier.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/home_profile_screen.dart';
import 'package:school_app/screen/profile_login/qr_login.dart';
const Color nandaPurple = Color(0xFF81005B);
class UnifiedLoginScreen extends StatefulWidget {
  const UnifiedLoginScreen({super.key});

  @override
  State<UnifiedLoginScreen> createState() => _UnifiedLoginScreenState();
}

class _UnifiedLoginScreenState extends State<UnifiedLoginScreen> {
  bool _obscurePassword = true;
  double _dragValue = 0.0;
  bool _isVerified = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isFormValid {
    return _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _isVerified;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/image/background_login.png',
              fit: BoxFit.cover,
            ),
          ),

          // Theme Overlay
          Positioned.fill(
            child: Container(
              color: isDark
                  ? Colors.black.withOpacity(0.65)
                  : Colors.white.withOpacity(0.2),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and School Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/image/logo_school.png',
                          height: 120,
                          fit: BoxFit.contain,
                          color: isDark ? Colors.white : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "南京大学",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF5B2C84),
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              "NANJING UNIVERSITY",
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? Colors.white70 : Colors.black54,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Login Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: isDark ? Colors.white12 : Colors.white38),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              const Center(
                                child: Text(
                                  "Student/Staff Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),

                              // Username Field
                              _inputField(Icons.person, "Username", isDark),
                              const SizedBox(height: 15),

                              // Password Field
                              _passwordField(isDark),
                              const SizedBox(height: 25),

                              // Slider Verification
                              _buildFunctionalSlider(isDark),
                              const SizedBox(height: 25),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isFormValid
                                      ? () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeProfileScreen()));
                                  }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: nandaPurple,
                                    disabledBackgroundColor:
                                    Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                      ),
                            ],

                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Social Login
                    _buildSocialLogin(isDark),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _inputField(IconData icon, String hint, bool isDark) {
    return TextField(
      controller: _usernameController,
      onChanged: (_) {
        setState(() {
          if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
            _isVerified = false;
            _dragValue = 0.0;
          }
        });
      },
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: isDark ? Colors.white60 : Colors.black45),
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black38),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        // --- Validation: show error if username is empty ---
        errorText: _usernameController.text.isEmpty ? "Username cannot be empty" : null,
      ),
    );
  }


  Widget _passwordField(bool isDark) {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      onChanged: (_) {
        setState(() {
          // Reset slider if fields are empty
          if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
            _isVerified = false;
            _dragValue = 0.0;
          }
        });
      },
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: isDark ? Colors.white60 : Colors.black45),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          color: isDark ? Colors.white30 : Colors.black38,
        ),
        hintText: "Password",
        hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black38),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        // --- Validation: show error if password is empty ---
        errorText: _passwordController.text.isEmpty ? "Password cannot be empty" : null,
      ),
    );
  }


  Widget _buildFunctionalSlider(bool isDark) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isVerified
            ? Colors.green.withOpacity(0.1)
            : (isDark ? Colors.white10 : Colors.black12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // Slider text
          Center(
            child: Text(
              _isVerified ? "验证成功 Success" : "向右滑动验证 Slide to Verify",
              style: TextStyle(
                color: _isVerified
                    ? Colors.green
                    : (isDark ? Colors.white38 : Colors.black45),
                fontSize: 13,
              ),
            ),
          ),

          // Slider itself
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape:
              const RoundSliderThumbShape(enabledThumbRadius: 20, elevation: 2),
              overlayShape: SliderComponentShape.noOverlay,
              trackHeight: 50,
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              thumbColor:
              _isVerified ? Colors.green : const Color(0xFF6A1B9A),
            ),
            child: Slider(
              value: _dragValue,
              onChanged: (val) {
                if (!_isVerified) setState(() => _dragValue = val);
              },
              onChangeEnd: (val) {
                // Only verify if fields are not empty
                if (val > 0.85 &&
                    _usernameController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  setState(() {
                    _dragValue = 1.0;
                    _isVerified = true;
                  });
                } else {
                  // Reset slider if incomplete
                  setState(() => _dragValue = 0.0);
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSocialLogin(bool isDark) {
    return Column(
      children: [
        Text(
          "Or login with",
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.black45,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // WeChat - Common for NJU students
            _socialBtn(
                Icons.wechat,
                Colors.green,
                isDark
            ),
            const SizedBox(width: 25),

            // Biometrics - Color adapted to Theme
            _socialBtn(
                Icons.fingerprint,
                isDark ? Colors.white : Colors.black87,
                isDark
            ),
            const SizedBox(width: 25),

            // Institutional SSO / QR Login
            _socialBtn(
                Icons.account_balance, // Represents University/Institutional login
                const Color(0xFF6A1B9A), // Nanjing Purple
                isDark
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialBtn(IconData icon, Color iconColor, bool isDark) {
    return InkWell(
      onTap: () {
        // Add haptic feedback for a premium feel
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRCodeScreen()),
        );
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(15), // Increased padding for better touch target
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Adaptive background color
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.grey.withOpacity(0.1),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12,
          ),
        ),
        child: Icon(icon, color: iconColor, size: 30),
      ),
    );
  }
}
