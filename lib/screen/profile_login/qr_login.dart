import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _handleRefresh() => _showSnackBar("Updating QR Code...");
  void _handleSave() => _showSnackBar("QR Code saved to gallery");
  void _handleShare() => _showSnackBar("Opening share options...");

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.primaryColor,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: _buildHeader(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildQRCard(context, isDark),
            const SizedBox(height: 40),
            _buildActionButtons(isDark),
            const SizedBox(height: 30),
            _buildSecurityNotice(isDark),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(decoration: const BoxDecoration(gradient: BrandGradient.luxury)),
      toolbarHeight: 80,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/image/logo.png',
            height: 45,
            errorBuilder: (_, __, ___) => const Icon(Icons.school, color: AppColor.lightGold),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                  '南京大學',
                  style: TextStyle(fontSize: 20, color: AppColor.lightGold, fontWeight: FontWeight.bold, fontFamily: 'MaoTi', letterSpacing: 2)
              ),
              Text(
                  'NANJING UNIVERSITY',
                  style: TextStyle(fontSize: 8, color: Colors.white70, fontWeight: FontWeight.w900, letterSpacing: 1.2)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRCard(BuildContext context, bool isDark) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceColor : Colors.white,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: AppColor.glassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            // Card Header with Gradient
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
              decoration: const BoxDecoration(
                gradient: BrandGradient.luxury,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.qr_code_scanner_rounded, color: AppColor.lightGold, size: 20),
                  ),
                  const SizedBox(width: 15),
                  const Text("CAMPUS ACCESS PASS", style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 45),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // QR Frame
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColor.primaryColor.withOpacity(0.1), blurRadius: 20)],
                    ),
                    child: Image.asset(
                      'assets/image/qr.png',
                      width: 190,
                      height: 190,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code_2_rounded, size: 150, color: AppColor.primaryColor),
                    ),
                  ),
                  // Animated Scanning Line
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Positioned(
                        top: 15 + (_animationController.value * 190),
                        child: Container(
                          width: 210,
                          height: 3,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: AppColor.accentGold.withOpacity(0.6), blurRadius: 12, spreadRadius: 2),
                            ],
                            gradient: LinearGradient(
                              colors: [Colors.transparent, AppColor.accentGold, Colors.transparent],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.accentGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Expires at: 23:59 PM",
                style: TextStyle(color: isDark ? AppColor.lightGold : AppColor.primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _iconButton(Icons.refresh_rounded, "Refresh", _handleRefresh, isDark),
        _iconButton(Icons.save_alt_rounded, "Save", _handleSave, isDark),
        _iconButton(Icons.share_rounded, "Share", _handleShare, isDark),
      ],
    );
  }

  Widget _iconButton(IconData icon, String label, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColor.surfaceColor : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.glassBorder),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Icon(icon, color: AppColor.accentGold, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: isDark ? Colors.white70 : AppColor.primaryColor, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        "Please do not share this QR code with others. It is linked to your student ID and used for campus entry and exit.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 11, height: 1.5),
      ),
    );
  }
}