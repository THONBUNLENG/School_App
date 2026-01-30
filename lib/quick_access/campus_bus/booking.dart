import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../config/app_color.dart';
import '../../extension/change_notifier.dart';

class SeatBookingView extends StatefulWidget {
  final Map<String, dynamic> busInfo;
  const SeatBookingView({super.key, required this.busInfo});

  @override
  State<SeatBookingView> createState() => _SeatBookingViewState();
}

class _SeatBookingViewState extends State<SeatBookingView>
    with SingleTickerProviderStateMixin {
  late List<int> _seatStates;
  final List<int> _selectedSeats = [];
  final double seatPrice = 5.0;
  double discount = 0;
  final TextEditingController promoController = TextEditingController();

  bool _isProcessing = false;
  String _loadingMessage = "";
  late AnimationController _rotationController;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _seatStates = List.generate(24, (i) => [3, 7, 12, 18].contains(i) ? 1 : 0);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  double get totalPrice {
    final total = (_selectedSeats.length * seatPrice) - discount;
    return total < 0 ? 0 : total;
  }

  void _applyPromo() {
    if (promoController.text.trim().toUpperCase() == "SAVE10") {
      setState(() => discount = 10);
    } else {
      setState(() => discount = 0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid promo code")),
      );
    }
  }

  // ==================== SEAT LOGIC ====================
  void _onSeatTap(int index) {
    if (_seatStates[index] == 1) return;

    HapticFeedback.lightImpact();

    setState(() {
      if (_seatStates[index] == 2) {
        _seatStates[index] = 0;
        _selectedSeats.remove(index);
      } else {
        _seatStates[index] = 2;
        if (!_selectedSeats.contains(index)) _selectedSeats.add(index);
      }
    });
  }

  // ==================== PAYMENT LOGIC ====================
  Future<void> _handlePayment({bool isBank = false}) async {
    setState(() {
      _isProcessing = true;
      _loadingMessage = isBank ? "Processing bank payment..." : "Processing online payment...";
    });
    _rotationController.repeat();

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loadingMessage = "Verifying payment...");

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loadingMessage = "Finalizing order...");

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    _rotationController.stop();
    setState(() {
      _isProcessing = false;
    });

    _showETicket();
  }

  void _showETicket() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildETicket(),
    );
  }

  void _openBankPay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _buildBankPaySheet(),
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _downloadTicket() async {
    try {
      final Uint8List? image = await _screenshotController.capture();
      if (image == null) return;
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/ticket_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket saved to $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save ticket')),
      );
    }
  }

  // ==================== UI ====================
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Select Seat", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildBusHeader(),
              const SizedBox(height: 8),
              _buildSeatLegend(),
              const SizedBox(height: 8),
              Expanded(child: _buildSeatGrid()),
              _buildBottomAction(isDark),
            ],
          ),
          if (_isProcessing) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildBusHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColor.primaryColor,
          AppColor.primaryColor.withOpacity(.8)
        ]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_bus, color: Colors.white, size: 40),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.busInfo['route'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Text("Departure: ${widget.busInfo['time']}",
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem("Available", Colors.grey[300]!),
        const SizedBox(width: 12),
        _legendItem("Booked", Colors.grey[800]!),
        const SizedBox(width: 12),
        _legendItem("Selected", AppColor.brandOrange),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildSeatGrid() {
    const int seatsPerRow = 4;
    const int totalSeats = 24;
    const int rows = totalSeats ~/ seatsPerRow;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 2 + aisle + 2
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: rows * 5,
      itemBuilder: (context, i) {
        if (i % 5 == 2) return const SizedBox();
        int row = i ~/ 5;
        int col = i % 5;
        int seatIndex = col < 2 ? row * 4 + col : row * 4 + (col - 1);
        if (seatIndex >= totalSeats) return const SizedBox();

        bool selected = _seatStates[seatIndex] == 2;
        Color color = _seatStates[seatIndex] == 0
            ? Colors.grey[300]!
            : (_seatStates[seatIndex] == 1
            ? Colors.grey[800]!
            : AppColor.brandOrange);

        return GestureDetector(
          onTap: () => _onSeatTap(seatIndex),
          child: AnimatedScale(
            scale: selected ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text("${seatIndex + 1}",
                    style: TextStyle(
                        color:
                        _seatStates[seatIndex] == 0 ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomAction(bool isDark) {
    final _ = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedSeats.isEmpty
                      ? "No seat selected"
                      : "Seats: ${_selectedSeats.map((e) => e + 1).join(', ')}",
                ),
              ),
              Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: promoController,
                  decoration: const InputDecoration(
                      hintText: "Promo code", border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _applyPromo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Apply"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedSeats.isEmpty ? null : () => _handlePayment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: _isProcessing
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotationTransition(
                        turns: _rotationController,
                        child: const Icon(Icons.sync, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          _loadingMessage,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis, // optional
                        ),
                      ),
                    ],
                  )
                      : const Text("Pay Online"),
                ),
              ),

              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _selectedSeats.isEmpty ? null : _openBankPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Bank Pay"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.75),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _rotationController,
                child: Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.accentGold, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.accentGold.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/image/logo_profile.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                _loadingMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 140,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.accentGold),
                  minHeight: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ==================== E-Ticket ====================
  Widget _buildETicket() {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Colors.green, size: 60),
            const SizedBox(height: 10),
            const Text("Booking Successful!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Show this ticket when boarding",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 25),

            Screenshot(
              controller: _screenshotController,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildTicketBrand(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _ticketRow("Route", widget.busInfo['route'], isDark),
                          _ticketRow("Time", widget.busInfo['time'], isDark),
                          _ticketRow("Seats",
                              _selectedSeats.map((e) => e + 1).join(', '), isDark),
                          const SizedBox(height: 15),
                          _buildDashedLine(),
                          const SizedBox(height: 15),
                          _ticketRow(
                            "Total",
                            "\$${totalPrice.toStringAsFixed(2)}",
                            isDark,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            // QR Code
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Icon(Icons.qr_code_2_rounded,
                  size: 100, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text("NJU-SCAN-READER",
                style: TextStyle(
                    fontSize: 10, color: Colors.grey, letterSpacing: 2)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _downloadTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Download Ticket",
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Back Home",
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  Widget _ticketRow(String label, String value, bool isDark,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 5.0;
        const dashSpace = 3.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1,
              color: Colors.grey[400],
            );
          }),
        );
      },
    );
  }

  Widget _buildTicketBrand() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: const Center(
        child: Text(
          "NJU BUS",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildBankPaySheet() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Bank Payment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text("Total: \$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Bank Account Number",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Account Holder Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                _handlePayment(isBank: true);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Pay Now"),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
