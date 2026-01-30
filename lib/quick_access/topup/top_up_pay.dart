import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';
import 'comfirm_top_up.dart';

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

  final List<String> _methods = ["ABA Mobile", "Wing / ACLEDA", "International Card"];

  @override
  Widget build(BuildContext context) {
    final _ = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'PAYMENT METHOD',
          style: TextStyle(
              color: AppColor.lightGold,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 16
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- ១. Summary Card (Glass Style) ---
                    _buildSummaryCard(),

                    const SizedBox(height: 40),

                    const Text(
                      'Select Payment Provider',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- ២. ជម្រើសបង់ប្រាក់នីមួយៗ ---
                    _paymentTile(0, 'ABA Mobile', 'Instant pay via ABA Bank', Icons.account_balance_wallet_rounded),
                    const SizedBox(height: 15),
                    _paymentTile(1, 'Wing / ACLEDA', 'Pay via Local Gateway', Icons.qr_code_scanner_rounded),
                    const SizedBox(height: 15),
                    _paymentTile(2, 'Credit Card', 'Visa, Mastercard, UnionPay', Icons.credit_card_rounded),
                  ],
                ),
              ),
            ),

            // --- ៣. ប៊ូតុងបញ្ជាក់នៅខាងក្រោម ---
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("RECHARGE AMOUNT",
                      style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text("¥ ${widget.amount.toStringAsFixed(2)}",
                      style: const TextStyle(color: AppColor.accentGold, fontSize: 32, fontWeight: FontWeight.w900)),
                ],
              ),
              const Icon(Icons.security_rounded, color: AppColor.accentGold, size: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentTile(int index, String title, String subtitle, IconData icon) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.accentGold.withOpacity(0.12) : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColor.accentGold : Colors.white.withOpacity(0.08),
              width: isSelected ? 1.5 : 1
          ),
          boxShadow: isSelected ? [BoxShadow(color: AppColor.accentGold.withOpacity(0.1), blurRadius: 10)] : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.accentGold : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: isSelected ? Colors.black : AppColor.accentGold, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColor.accentGold),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    bool isEnabled = selectedIndex != -1;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: isEnabled ? () {
            // 🔥 រុញទៅស្គ្រីន Confirmation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConfirmTopUpScreen(
                  amount: widget.amount,
                  childName: widget.childName,
                  note: widget.note,
                  paymentMethod: _methods[selectedIndex],
                ),
              ),
            );
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.accentGold,
            disabledBackgroundColor: Colors.white.withOpacity(0.05),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 0,
          ),
          child: Text(
              isEnabled ? 'Review Transaction' : 'Select Method',
              style: TextStyle(
                  color: isEnabled ? Colors.black : Colors.white24,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1
              )
          ),
        ),
      ),
    );
  }
}