import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_app/config/app_color.dart';
import '../../../profile_login/profile_page.dart';
import '../../../splash_screen.dart';
import '../main_holder.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LogoutDialog(),
    );
  }

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  bool _isLoading = false;
  bool _isSuccess = false;
  String _loadingMessage = "Preparing to sign out...";

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() => _loadingMessage = "Clearing secure data...");

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() {
        _isSuccess = true;
        _loadingMessage = "Goodbye! See you again soon.";
      });

      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UnifiedLoginScreen()),
            (route) => false,
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logout failed. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        border: Border.all(color: AppColor.glassBorder, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 35),

          // Illustration & Status Area
          SizedBox(
            height: 160,
            child: _isLoading
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isSuccess
                    ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60)
                    : const CircularProgressIndicator(color: AppColor.accentGold, strokeWidth: 3),
                const SizedBox(height: 25),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _loadingMessage,
                    key: ValueKey(_loadingMessage),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _isSuccess ? AppColor.accentGold : (isDark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                ),
              ],
            )
                : Lottie.asset(
              'assets/tottie/man.json',
              height: 140,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.logout_rounded,
                size: 80,
                color: AppColor.accentGold.withOpacity(0.8),
              ),
            ),
          ),

          if (!_isLoading) ...[
            const SizedBox(height: 20),
            Text(
              "CONFIRM LOGOUT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: isDark ? AppColor.lightGold : AppColor.primaryColor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Are you sure you want to sign out? Your student session will be cleared from this device.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey[600],
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: isDark ? Colors.white10 : Colors.grey[200]!),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: BrandGradient.luxury,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: AppColor.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}