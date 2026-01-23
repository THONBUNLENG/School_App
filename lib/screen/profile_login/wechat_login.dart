import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/screen/home/home_screen/change_notifier.dart';

import '../home_profile/home_profile_screen/home_profile_screen.dart'; // ប្រើ ThemeManager របស់អ្នក

class WeChatLoginScreen extends StatefulWidget {
  const WeChatLoginScreen({super.key});

  @override
  State<WeChatLoginScreen> createState() => _WeChatLoginScreenState();
}

class _WeChatLoginScreenState extends State<WeChatLoginScreen> {
  bool _isProcessing = false;
  bool _isAuthorized = true;
  void _handleConfirm() async {
    setState(() => _isProcessing = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isProcessing = false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeProfileScreen()),
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

    final bgColor = isDark ? const Color(0xFF191919) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white60 : Colors.grey[600];
    final dividerColor = isDark ? Colors.white10 : Colors.grey[300];
    final secondaryBtnColor = isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // App Icon
                  const Icon(Icons.wechat, color: Color(0xFF07C160), size: 80),
                  const SizedBox(height: 15),
                  Text(
                    "WeChat Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 40),

                  // Permission Text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "南京大学 统一身份认证 申请获得以下权限：",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Divider(color: dividerColor),

                  // Mock Profile Section
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      setState(() {
                        _isAuthorized = !_isAuthorized;
                      });
                    },
                    leading: CachedNetworkImage(
                      imageUrl: "https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-1/599564005_917361570947268_8172077923485745444_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=100&ccb=1-7&_nc_sid=1d2534&_nc_ohc=lCA1FwVD-iQQ7kNvwElb0Uw&_nc_oc=AdmJAFIAliwLkPPLNjf6P74JigX6kGeaEdPYA-xhFvxvGeFEfVaIy578MTxr7wsMf60&_nc_zt=24&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=o8CbHEKedGAJ7-VyCUm42A&oh=00_AfoC2NXxXKduzdImLpJ3yyP-QNLxD6jjdPIiFAp-0hHaLA&oe=6978CBBE",
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 20,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => CircleAvatar(
                        radius: 20,
                        backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                        child: const CupertinoActivityIndicator(radius: 8),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 20,
                        backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                        child: Icon(Icons.person, color: subTextColor),
                      ),
                    ),
                    title: Text(
                      "Long search for your WeChat account",
                      style: TextStyle(color: textColor, fontSize: 14),
                    ),
                    subtitle: Text(
                      "Get information Profile (Nickname, Avatar, etc.)",
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),

                    trailing: Icon(
                      _isAuthorized ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: _isAuthorized ? const Color(0xFF07C160) : Colors.grey,
                    ),
                  ),
                  Divider(color: dividerColor),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                // Agree Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    // កែសម្រួល៖ onPressed ត្រូវនៅខាងក្រៅ style
                    onPressed: (_isProcessing || !_isAuthorized) ? null : _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07C160),
                      disabledBackgroundColor: const Color(0xFF07C160).withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      // លុប onPressed ដែលនៅក្នុងនេះចេញ ព្រោះវាខុស Syntax
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : const Text(
                      "同意 (Agree)",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Refuse Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: secondaryBtnColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      "拒绝 (Refuse)",
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 16
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