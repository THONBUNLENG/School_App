import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Custom Painter for the Scanner Frame
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 10,
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()..addRect(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final boxWidth = cutOutSize;
    final boxHeight = cutOutSize;
    final left = (width - boxWidth) / 2;
    final top = (height - boxHeight) / 2;

    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.65);
    final cutOutRect = Rect.fromLTWH(left, top, boxWidth, boxHeight);

    // Draw Dark Background with Hole
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()..addRRect(RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius))),
      ),
      backgroundPaint,
    );

    // Draw Gold Corner Borders
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Top Left
    path.moveTo(left, top + borderLength);
    path.lineTo(left, top + borderRadius);
    path.arcToPoint(Offset(left + borderRadius, top), radius: Radius.circular(borderRadius));
    path.lineTo(left + borderLength, top);

    // Top Right
    path.moveTo(left + boxWidth - borderLength, top);
    path.lineTo(left + boxWidth - borderRadius, top);
    path.arcToPoint(Offset(left + boxWidth, top + borderRadius), radius: Radius.circular(borderRadius));
    path.lineTo(left + boxWidth, top + borderLength);

    // Bottom Right
    path.moveTo(left + boxWidth, top + boxHeight - borderLength);
    path.lineTo(left + boxWidth, top + boxHeight - borderRadius);
    path.arcToPoint(Offset(left + boxWidth - borderRadius, top + boxHeight), radius: Radius.circular(borderRadius));
    path.lineTo(left + boxWidth - borderLength, top + boxHeight);

    // Bottom Left
    path.moveTo(left + borderLength, top + boxHeight);
    path.lineTo(left + borderRadius, top + boxHeight);
    path.arcToPoint(Offset(left, top + boxHeight - borderRadius), radius: Radius.circular(borderRadius));
    path.lineTo(left, top + boxHeight - borderLength);

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) => this;
}