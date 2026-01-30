import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_color.dart';
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
  State<TopUpPayment> createState() => _TopUpPaymentState();
}

class _TopUpPaymentState extends State<TopUpPayment> {
  int selectedIndex = -1;
  String selectedBank = '';

  final List<Map<String, dynamic>> banks = [
    {'name': 'ABA Bank', 'icon': Icons.account_balance_wallet_rounded},
    {'name': 'KHQR Pay', 'icon': Icons.qr_code_scanner_rounded},
    {'name': 'ACLEDA Bank', 'icon': Icons.account_balance_rounded},
    {'name': 'Canadia Bank', 'icon': Icons.domain_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _buildAppBar(context),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildAmountHeader(),
                      const SizedBox(height: 40),

                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.white70,
                            letterSpacing: 1.2
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildMethodTile(
                        index: 0,
                        title: 'Stripe Payment',
                        subtitle: 'Credit or Debit Card',
                        icon: Icons.credit_card_rounded,
                        onTap: () {
                          HapticFeedback.lightImpact(); // 💡 បន្ថែមរំញ័រ
                          setState(() {
                            selectedIndex = 0;
                            selectedBank = '';
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      _buildMethodTile(
                        index: 1,
                        title: 'Local Bank Transfer',
                        subtitle: selectedBank.isEmpty ? 'Select your preferred bank' : selectedBank,
                        icon: Icons.account_balance_rounded,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() => selectedIndex = 1);
                          _showBankPicker();
                        },
                      ),

                      const Spacer(),
                      _buildActionFooter(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets កែសម្រួលថ្មីៗ ---

  Widget _buildAmountHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("TOTAL RECHARGE",
                  style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("¥ ${widget.amount.toStringAsFixed(2)}",
                      style: const TextStyle(color: AppColor.accentGold, fontSize: 32, fontWeight: FontWeight.w900)),
                  const Icon(Icons.security_rounded, color: AppColor.accentGold, size: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBankPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(10), // 💡 បន្ថែម Margin ឱ្យមើលទៅដូចកាតអណ្តែត
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColor.surfaceColor,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            const Text("Select Bank", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: banks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  tileColor: Colors.white.withOpacity(0.03),
                  leading: Icon(banks[index]['icon'], color: AppColor.accentGold),
                  title: Text(banks[index]['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() => selectedBank = banks[index]['name']);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context)
      ),
      title: const Text('PAYMENT METHOD',
          style: TextStyle(color: AppColor.lightGold, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)
      ),
    );
  }

  Widget _buildActionFooter() {
    bool isEnabled = selectedIndex != -1 && (selectedIndex == 0 || selectedBank.isNotEmpty);
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isEnabled ? () {
          HapticFeedback.selectionClick();
          String method = selectedIndex == 0 ? "Stripe" : selectedBank;
          Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmTopUpScreen(
            amount: widget.amount, childName: widget.childName, note: widget.note, paymentMethod: method,
          )));
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.accentGold,
          disabledBackgroundColor: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: Text('Review Transaction',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isEnabled ? Colors.black : Colors.white24,
                letterSpacing: 0.5
            )
        ),
      ),
    );
  }

  // 💡 _buildMethodTile ទុកនៅដដែលតាមកូដដើមរបស់អ្នក ព្រោះវាស្អាតហើយ
  Widget _buildMethodTile({required int index, required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.accentGold.withOpacity(0.12) : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.accentGold : Colors.white.withOpacity(0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: isSelected ? AppColor.accentGold : Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: isSelected ? Colors.black : AppColor.accentGold, size: 24),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: isSelected ? AppColor.accentGold.withOpacity(0.8) : Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? AppColor.accentGold : Colors.white24, width: 2)),
              child: isSelected ? const Center(child: CircleAvatar(radius: 5, backgroundColor: AppColor.accentGold)) : null,
            ),
          ],
        ),
      ),
    );
  }
}