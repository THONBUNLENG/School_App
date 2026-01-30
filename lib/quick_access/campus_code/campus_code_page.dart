import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart'; // ប្រើ AppColor & BrandGradient របស់អ្នក
import '../../extension/change_notifier.dart'; // សម្រាប់ check isDarkMode
import '../../model/model_qr.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanCompleted = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Scanner Layer
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (!isScanCompleted) {
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  isScanCompleted = true;
                  final code = barcodes.first.rawValue ?? "Unknown";
                  Navigator.pop(context, code);
                }
              }
            },
          ),

          // 2. Premium Darkened Overlay with Gold Border
          _buildOverlay(context),

          // 3. Top Controls (Back, Flash, Switch Camera)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _scannerActionBtn(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.close_rounded,
                  isCloseBtn: true,
                ),
                Row(
                  children: [
                    _scannerActionBtn(
                      onPressed: () => controller.toggleTorch(),
                      icon: Icons.flashlight_on_rounded,
                    ),
                    const SizedBox(width: 12),
                    _scannerActionBtn(
                      onPressed: () => controller.switchCamera(),
                      icon: Icons.cameraswitch_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Bottom Instructions & Gallery Button
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Align QR code within the frame",
                    style: TextStyle(color: AppColor.lightGold, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 30),

                // Gallery Button with Luxury Gradient
                Container(
                  width: 220,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: BrandGradient.luxury,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: AppColor.primaryColor.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      // Logic for Image Picker
                    },
                    icon: const Icon(Icons.photo_library_rounded, color: AppColor.lightGold),
                    label: const Text(
                      "Scan from Gallery",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scannerActionBtn({required VoidCallback onPressed, required IconData icon, bool isCloseBtn = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.glassBorder, width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: isCloseBtn ? Colors.white : AppColor.accentGold, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: ShapeDecoration(
          shape: QrScannerOverlayShape(
            borderColor: AppColor.accentGold,
            borderRadius: 25,
            borderLength: 35,
            borderWidth: 8,
            cutOutSize: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ),
    );
  }
}

