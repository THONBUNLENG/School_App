import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final double width = size.width;
    final double height = size.height;

    // 1. Create a darkened background with a hole
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);
    final cutoutRect = Rect.fromCenter(
      center: Offset(width / 2, height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    // This creates the "hole" effect
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, width, height)),
        Path()..addRRect(RRect.fromRectAndRadius(cutoutRect, Radius.circular(borderRadius))),
      ),
      backgroundPaint,
    );

    // 2. Draw the corner borders
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double r = borderRadius;
    final double l = borderLength;

    // Top Left
    path.moveTo(cutoutRect.left, cutoutRect.top + l);
    path.lineTo(cutoutRect.left, cutoutRect.top + r);
    path.arcToPoint(Offset(cutoutRect.left + r, cutoutRect.top), radius: Radius.circular(r));
    path.lineTo(cutoutRect.left + l, cutoutRect.top);

    // Top Right
    path.moveTo(cutoutRect.right - l, cutoutRect.top);
    path.lineTo(cutoutRect.right - r, cutoutRect.top);
    path.arcToPoint(Offset(cutoutRect.right, cutoutRect.top + r), radius: Radius.circular(r));
    path.lineTo(cutoutRect.right, cutoutRect.top + l);

    // Bottom Right
    path.moveTo(cutoutRect.right, cutoutRect.bottom - l);
    path.lineTo(cutoutRect.right, cutoutRect.bottom - r);
    path.arcToPoint(Offset(cutoutRect.right - r, cutoutRect.bottom), radius: Radius.circular(r));
    path.lineTo(cutoutRect.right - l, cutoutRect.bottom);

    // Bottom Left
    path.moveTo(cutoutRect.left + l, cutoutRect.bottom);
    path.lineTo(cutoutRect.left + r, cutoutRect.bottom);
    path.arcToPoint(Offset(cutoutRect.left, cutoutRect.bottom - r), radius: Radius.circular(r));
    path.lineTo(cutoutRect.left, cutoutRect.bottom - l);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}