import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart'; // ប្រើប្រាស់ AppColor របស់អ្នក
import 'package:school_app/extension/change_notifier.dart';
import 'package:school_app/screen/home/home_screen/main_holder.dart';
import '../home_profile/home_profile_screen/home_profile_screen.dart';

class WeChatLoginScreen extends StatefulWidget {
  const WeChatLoginScreen({super.key});

  @override
  State<WeChatLoginScreen> createState() => _WeChatLoginScreenState();
}

class _WeChatLoginScreenState extends State<WeChatLoginScreen> {
  bool _isProcessing = false;
  bool _isAuthorized = true;


  final Color weChatGreen = const Color(0xFF07C160);

  void _handleConfirm() async {
    setState(() => _isProcessing = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _isProcessing = false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainHolder()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    final bgColor = isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB);
    final textColor = isDark ? Colors.white : AppColor.primaryColor;
    final subTextColor = isDark ? Colors.white60 : Colors.grey[600];
    final secondaryBtnColor = isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "OAUTH AUTHORIZATION",
          style: TextStyle(
            color: isDark ? AppColor.lightGold : AppColor.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // WeChat Identity with NJU Glow
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: weChatGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.wechat, color: weChatGreen, size: 80),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "WeChat Authorized Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Powered by Nanjing University",
                    style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "NJU Unified Authentication requests the following permissions:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Permission Card
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.surfaceColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.glassBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () => setState(() => _isAuthorized = !_isAuthorized),
                      leading: CachedNetworkImage(
                        imageUrl: "https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-1/599564005_917361570947268_8172077923485745444_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=100&ccb=1-7&_nc_sid=1d2534&_nc_ohc=lCA1FwVD-iQQ7kNvwElb0Uw&_nc_oc=AdmJAFIAliwLkPPLNjf6P74JigX6kGeaEdPYA-xhFvxvGeFEfVaIy578MTxr7wsMf60&_nc_zt=24&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=o8CbHEKedGAJ7-VyCUm42A&oh=00_AfoC2NXxXKduzdImLpJ3yyP-QNLxD6jjdPIiFAp-0hHaLA&oe=6978CBBE",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor.accentGold, width: 2),
                          ),
                          child: CircleAvatar(radius: 22, backgroundImage: imageProvider),
                        ),
                        placeholder: (context, url) => const CircleAvatar(
                          radius: 22,
                          child: CupertinoActivityIndicator(radius: 8),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.person, color: subTextColor),
                        ),
                      ),
                      title: Text(
                        "Austin Carr",
                        style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Access Profile Info (Nickname, Avatar)",
                        style: TextStyle(color: subTextColor, fontSize: 12),
                      ),
                      trailing: Icon(
                        _isAuthorized ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                        color: _isAuthorized ? weChatGreen : Colors.grey[400],
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Buttons Area
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 50),
            child: Column(
              children: [
                // Agree Button (NJU Luxury Style)
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: _isAuthorized ? BrandGradient.luxury : null,
                    color: _isAuthorized ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isAuthorized ? [
                      BoxShadow(
                        color: AppColor.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ] : [],
                  ),
                  child: ElevatedButton(
                    onPressed: (_isProcessing || !_isAuthorized) ? null : _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isProcessing
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColor.lightGold, strokeWidth: 2))
                        : const Text(
                      "ALLOW ACCESS",
                      style: TextStyle(color: AppColor.lightGold, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Refuse Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: secondaryBtnColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}