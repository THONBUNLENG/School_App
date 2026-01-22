import 'package:flutter/material.dart';

const Color nandaPurple = Color(0xFF81005B);

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F7),
      appBar: _buildHeader(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildQRCard(context, isDarkMode),
            const SizedBox(height: 40),
            _buildActionButtons(isDarkMode),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: nandaPurple,
      toolbarHeight: 80,
      elevation: 0,
      centerTitle: true,
      // កំណត់ពណ៌សសម្រាប់ប៊ូតុង Back
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white, // កំណត់ពណ៌សនៅទីនេះ
          size: 28,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/image/logo.png',
            height: 45,
            errorBuilder: (_, __, ___) => const Icon(Icons.school, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                  '南京大學',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)
              ),
              Text(
                  'NANJING UNIVERSITY',
                  style: TextStyle(fontSize: 9, color: Colors.white)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRCard(BuildContext context, bool isDarkMode) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: nandaPurple,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Row(
                children: const [
                  CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.qr_code, color: Colors.white)),
                  SizedBox(width: 15),
                  Text("Campus Access Pass", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/image/qr.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                  // Animation line
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Positioned(
                        top: _animationController.value * 180,
                        child: Container(
                          width: 200,
                          height: 2,
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: nandaPurple.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                            gradient: const LinearGradient(colors: [Colors.transparent, nandaPurple, Colors.transparent]),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Text(
                "Valid until: 23:59 PM",
                style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey, fontSize: 12)
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _iconButton(Icons.refresh, "Refresh", _handleRefresh, isDarkMode),
        _iconButton(Icons.download_rounded, "Save", _handleSave, isDarkMode),
        _iconButton(Icons.share_rounded, "Share", _handleShare, isDarkMode),
      ],
    );
  }

  Widget _iconButton(IconData icon, String label, VoidCallback onTap, bool isDarkMode) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: isDarkMode ? Colors.white12 : Colors.grey.shade300),
            ),
            child: Icon(icon, color: nandaPurple, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.black87
            ),
          ),
        ],
      ),
    );
  }
}