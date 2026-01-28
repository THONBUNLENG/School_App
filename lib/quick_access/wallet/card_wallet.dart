import 'dart:math';
import 'package:flutter/material.dart';

class VIPCardFlippable extends StatefulWidget {
  const VIPCardFlippable({super.key});

  @override
  State<VIPCardFlippable> createState() => _VIPCardFlippable3DState();
}

class _VIPCardFlippable3DState extends State<VIPCardFlippable> with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _shimmerController;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.85;

    return Center(
      child: GestureDetector(
        onTap: _toggleCard,
        child: AnimatedBuilder(
          animation: _flipController,
          builder: (context, child) {
            double angle = _flipController.value * pi;
            bool showFront = angle <= pi / 2;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..rotateY(angle),
              child: showFront
                  ? _buildFront(cardWidth)
                  : Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(pi),
                child: _buildBack(cardWidth),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront(double width) {
    return Container(
      height: 220,
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1,
              child: CustomPaint(size: Size.infinite, painter: CardMeshPainter()),
            ),
            // Shimmer effect
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor: 2,
                  child: Transform.translate(
                    offset: Offset(-width + (_shimmerController.value * 2 * width), 0),
                    child: Transform.rotate(
                      angle: pi / 4,
                      child: Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.35),
                              Colors.white.withOpacity(0),
                            ],
                            stops: const [0.4, 0.5, 0.6],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FTB",
                            style: TextStyle(
                                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1),
                          ),
                          Text(
                            "VIP BANKING",
                            style: TextStyle(
                                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/image/vip1.png',
                        width: 48,
                        height: 48,
                        color: Colors.white.withOpacity(0.8),
                      )

                    ],
                  ),
                  const Spacer(),
                  const Text(
                    "8888 8888 8888 8888",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4),
                        Shadow(color: Colors.white24, offset: Offset(-1, -1), blurRadius: 2),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _cardLabel("CARD HOLDER", "HE WENLIN"),
                      _cardLabel("VALID THRU", "01/30"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack(double width) {
    return Container(
      height: 220,
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(height: 50, color: const Color(0xFF1A1A1A)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CustomPaint(painter: SignatureLinePainter()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("CVV: 888", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "THIS CARD IS PROPERTY OF FTB BANK. USE IS SUBJECT TO TERMS AND CONDITIONS.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 8, letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF9D976),
          Color(0xFFD4AF37),
          Color(0xFFB38728),
          Color(0xFFF9D976),
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: -2,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  Widget _cardLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ],
    );
  }
}

class CardMeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    double gap = 15;
    for (double i = -size.height; i < size.width; i += gap) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
      canvas.drawLine(Offset(i + size.height, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}
class SignatureLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue.withOpacity(0.15)
      ..strokeWidth = 1.0;
    for (double i = 5; i < size.height; i += 8) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(oldDelegate) => false;
}
