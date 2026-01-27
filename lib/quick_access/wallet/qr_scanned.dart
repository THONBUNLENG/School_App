import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanCompleted = false;
  bool isTorchOn = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF81005B),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              controller.toggleTorch();
              setState(() {
                isTorchOn = !isTorchOn;
              });
            },
            icon: Icon(isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: isTorchOn ? Colors.yellow : Colors.white),
          ),
          IconButton(
            onPressed: () => controller.switchCamera(),
            icon: const Icon(Icons.cameraswitch, color: Colors.white),
          ),
        ],
      ),
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
          _buildOverlay(context),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return CustomPaint(
      painter: QrScannerOverlayPainter(
        borderColor: const Color(0xFF81005B),
        borderRadius: 15,
        borderLength: 40,
        borderWidth: 8,
        cutOutSize: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Container(),
    );
  }
}

/// Overlay Painter
class QrScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  QrScannerOverlayPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.cutOutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: cutOutSize,
      height: cutOutSize,
    );

    // Draw rounded border
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)), paint);

    final l = borderLength;

    // Draw corner lines
    canvas.drawLine(rect.topLeft, rect.topLeft + Offset(l, 0), paint);
    canvas.drawLine(rect.topLeft, rect.topLeft + Offset(0, l), paint);

    canvas.drawLine(rect.topRight, rect.topRight + Offset(-l, 0), paint);
    canvas.drawLine(rect.topRight, rect.topRight + Offset(0, l), paint);

    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(l, 0), paint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(0, -l), paint);

    canvas.drawLine(rect.bottomRight, rect.bottomRight + Offset(-l, 0), paint);
    canvas.drawLine(rect.bottomRight, rect.bottomRight + Offset(0, -l), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple Mobile Scanner Example
class MobileScannerSimple extends StatefulWidget {
  const MobileScannerSimple({super.key});

  @override
  State<MobileScannerSimple> createState() => _MobileScannerSimpleState();
}

class _MobileScannerSimpleState extends State<MobileScannerSimple> {
  Barcode? _barcode;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.isNotEmpty ? barcodes.barcodes.first : null;
      });
    }
  }

  Widget _barcodePreview(Barcode? barcode) {
    if (barcode == null) return const Text('Scan something!', style: TextStyle(color: Colors.white));
    return Text(barcode.displayValue ?? 'No display value.', style: const TextStyle(color: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Mobile Scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Colors.black45,
              child: Center(child: _barcodePreview(_barcode)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Home screen to select scanners
class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  Widget _buildItem(BuildContext context, String label, Widget page, IconData icon) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 20),
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner Example')),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildItem(context, 'Custom QR Scanner', const QrScannerScreen(), Icons.qr_code_scanner),
          _buildItem(context, 'Simple Mobile Scanner', const MobileScannerSimple(), Icons.qr_code),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
