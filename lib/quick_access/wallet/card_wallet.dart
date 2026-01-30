import 'dart:math';
import 'package:flutter/material.dart';

class VIPCardFlippable extends StatefulWidget {
  const VIPCardFlippable({super.key});

  @override
  State<VIPCardFlippable> createState() => _VIPCardFlippableState();
}

class _VIPCardFlippableState extends State<VIPCardFlippable> with TickerProviderStateMixin {
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
      duration: const Duration(seconds: 4),
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
    double cardWidth = MediaQuery.of(context).size.width * 0.9;

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
                ..setEntry(3, 2, 0.001) // 3D Perspective
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
      width: width,
      height: 220,
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Mesh Background
            Opacity(
              opacity: 0.15,
              child: CustomPaint(size: Size.infinite, painter: CardMeshPainter()),
            ),

            // Shimmer Shine Animation
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(-width + (_shimmerController.value * 2 * width), 0),
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Container(
                      width: 100,
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "FTB",
                            style: TextStyle(
                                color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1.5, fontFamily: 'Roboto'),
                          ),
                          Text(
                            "VIP BANKING",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                      // Card Chip Icon
                      Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFE5E5E5), Color(0xFF9E9E9E)]),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomPaint(painter: ChipLinesPainter()),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    "8888 8888 8888 8888",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      shadows: [
                        Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _cardLabel("CARD HOLDER", "HE WENLIN"),
                      _cardLabel("VALID THRU", "01/30"),
                      // NJU Logo placeholder
                      Image.asset('assets/image/logo.png', width: 40, height: 40, color: Colors.white.withOpacity(0.5)),
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
      width: width,
      height: 220,
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(height: 50, color: const Color(0xFF1A1A1A)), // Magnetic Strip
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CustomPaint(painter: SignatureLinePainter()),
                  ),
                ),
                const SizedBox(width: 15),
                const Text("CVV: 888", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Roboto')),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "AUTHORIZED SIGNATURE • NOT VALID UNLESS SIGNED\nTHIS CARD IS PROPERTY OF FTB BANK. USE IS SUBJECT TO TERMS AND CONDITIONS.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 7, letterSpacing: 0.5, fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
          Color(0xFF7B5B0B),
          Color(0xFFD4AF37),
          Color(0xFFF9D976),
        ],
        stops: [0.0, 0.2, 0.5, 0.8, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
          blurRadius: 25,
          spreadRadius: 2,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  Widget _cardLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 8, fontWeight: FontWeight.w900, fontFamily: 'Roboto')),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1, fontFamily: 'Roboto')),
      ],
    );
  }
}

// ---------------- PAINTERS ----------------

class ChipLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black26..strokeWidth = 0.5;
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), paint);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CardMeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    double gap = 20;
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
    var paint = Paint()..color = Colors.blue.withOpacity(0.1)..strokeWidth = 1.0;
    for (double i = 8; i < size.height; i += 8) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(oldDelegate) => false;
}