import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // 💡 កុំភ្លេចបន្ថែម intl ក្នុង pubspec.yaml
import '../../config/app_color.dart';
import '../topup/top_up_pay.dart';

class TopUpWallet extends StatefulWidget {
  const TopUpWallet({super.key});

  @override
  State<TopUpWallet> createState() => _TopUpWalletScreenState();
}

class _TopUpWalletScreenState extends State<TopUpWallet> {
  // ប្រើ NumberFormat ដើម្បីដាក់ក្បៀស
  final NumberFormat _formatter = NumberFormat("#,###");
  final TextEditingController _amountController = TextEditingController(text: '0');
  final List<String> _quickAmounts = ['50', '100', '200', '500', '1000', '2000', '5000', '100000'];

  // លុបក្បៀសចេញមុននឹងបម្លែងទៅជាលេខ double
  double get amount {
    String cleanString = _amountController.text.replaceAll(',', '');
    return double.tryParse(cleanString) ?? 0;
  }

  void _updateAmount(double newValue) {
    if (newValue < 0) newValue = 0;
    setState(() {
      // Format លេខដាក់ក្បៀសពេលបង្ហាញក្នុង TextField
      _amountController.text = _formatter.format(newValue);
      _amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: _amountController.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'TOP-UP WALLET',
            style: TextStyle(
                color: AppColor.lightGold,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 16),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration(gradient: BrandGradient.luxury)),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeaderBalance(),
                  const SizedBox(height: 40),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("AMOUNT SELECTION"),
                                const SizedBox(height: 20),
                                _buildAmountInputArea(),
                                const SizedBox(height: 30),
                                _buildQuickSelection(),
                                const SizedBox(height: 40),
                                _buildSecurityInfo(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildConfirmButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBalance() {
    return Column(
      children: [
        Text(
          "¥ 120,567,123.68",
          style: TextStyle(
              color: AppColor.accentGold,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
              ]),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: const Text(
            "Current Wallet Balance",
            style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInputArea() {
    return Row(
      children: [
        _circleIconBtn(Icons.remove_rounded, () => _updateAmount(amount - 50)),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 8))
              ],
            ),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsSeparatorInputFormatter(),
              ],
              textAlign: TextAlign.center,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: AppColor.primaryColor, fontSize: 26, fontWeight: FontWeight.w900),
              decoration: const InputDecoration(
                prefixText: '¥ ',
                prefixStyle: TextStyle(color: Colors.black26, fontSize: 20, fontWeight: FontWeight.bold),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        _circleIconBtn(Icons.add_rounded, () => _updateAmount(amount + 50)),
      ],
    );
  }

  Widget _buildQuickSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("QUICK SELECTION"),
        const SizedBox(height: 15),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _quickAmounts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              String valStr = _quickAmounts[index];
              double valDouble = double.parse(valStr);
              String formattedVal = _formatter.format(valDouble);

              bool isSelected = _amountController.text.replaceAll(',', '') == valStr;

              return InkWell(
                onTap: () {
                  _updateAmount(valDouble);
                  HapticFeedback.lightImpact();
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.accentGold : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                          color: AppColor.accentGold.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ]
                        : [],
                  ),
                  child: Text(
                    "¥$formattedVal",
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityInfo() {
    if (amount < 1000) return const SizedBox.shrink();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.accentGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColor.accentGold.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.security_rounded, color: AppColor.accentGold, size: 28),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SECURITY NOTICE",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5)),
                Text("Verification required for amounts ≥ ¥1,000",
                    style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: AppColor.accentGold,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.black, size: 28),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Review Amount",
                  style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
              Text("¥${_formatter.format(amount)}",
                  style: const TextStyle(color: AppColor.lightGold, fontSize: 22, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accentGold,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: const Text("NEXT: SELECT METHOD",
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TopUpPayment(
                amount: amount,
                childName: "He Wenlin",
                note: "Wallet Recharge")));
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.5));
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat("#,###");

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '0');
    }


    String cleanString = newValue.text.replaceAll(',', '');
    int? value = int.tryParse(cleanString);

    if (value == null) return oldValue;

    String newText = _formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}