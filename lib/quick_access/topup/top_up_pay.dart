import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';

class TopUpPayment extends StatefulWidget {
  final double amount;
  final String childName;
  final String note;

  const TopUpPayment({
    super.key,
    required this.amount,
    required this.childName,
    required this.note,
  });

  @override
  State<TopUpPayment> createState() => _TopUpPaymentScreenState();
}

class _TopUpPaymentScreenState extends State<TopUpPayment> {
  int selectedIndex = -1;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Payment Method',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.primaryColor, Colors.black.withOpacity(0.9)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card
                    _buildSummaryCard(),
                    const SizedBox(height: 30),

                    const Text(
                      'Select Payment Method',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    // ABA Bank Option
                    _paymentTile(0, 'ABA Mobile', 'Pay via ABA Bank App', Icons.account_balance_wallet_rounded),
                    const SizedBox(height: 12),

                    // ACLEDA / Wing
                    _paymentTile(1, 'Wing / ACLEDA', 'Pay via Local Payment Gateway', Icons.qr_code_scanner_rounded),
                    const SizedBox(height: 12),

                    // Credit Card
                    _paymentTile(2, 'International Card', 'Visa, Mastercard, UnionPay', Icons.credit_card_rounded),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total Amount", style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 4),
              Text("¥ ${widget.amount.toStringAsFixed(2)}",
                  style: TextStyle(color: AppColor.accentGold, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          const Icon(Icons.receipt_long_rounded, color: Colors.white24, size: 40),
        ],
      ),
    );
  }

  Widget _paymentTile(int index, String title, String subtitle, IconData icon) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ?  AppColor.accentGold.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ?  AppColor.accentGold : Colors.white12, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ?  AppColor.accentGold: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isSelected ? Colors.black : Colors.white70),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: selectedIndex != -1 ? () {

          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:  AppColor.accentGold,
            disabledBackgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text('Continue to Pay',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}