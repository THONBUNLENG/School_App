import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
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
          // Darkened Overlay
          _buildOverlay(context),
          // Top Controls (Back and Flash)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Row(
                  children: [
                    _scannerActionBtn(
                      onPressed: () => controller.toggleTorch(),
                      icon: Icons.flashlight_on_outlined,
                    ),
                    const SizedBox(width: 10),
                    _scannerActionBtn(
                      onPressed: () => controller.switchCamera(),
                      icon: Icons.cameraswitch_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text("Align QR code within the frame",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81005B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () async {
                    // Logic to pick image and use controller.analyzeImage(path)
                    // Note: Needs 'image_picker' package
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Scan from Gallery"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scannerActionBtn({required VoidCallback onPressed, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: Colors.black38,
      child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: QrScannerOverlayPainter(
          borderColor: const Color(0xFF81005B),
          borderRadius: 24,
          borderLength: 30,
          borderWidth: 6,
          cutOutSize: MediaQuery.of(context).size.width * 0.65,
        ),
      ),
    );
  }
}