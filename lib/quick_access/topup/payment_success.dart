import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/screen/home/home_screen/main_holder.dart';
import 'dart:ui';
import 'package:intl/intl.dart'; // 💡 សម្រាប់ Format លេខ
import 'package:flutter/services.dart';

class TopUpSuccessScreen extends StatefulWidget {
  final double amount;
  final String paymentMethod;

  const TopUpSuccessScreen({
    super.key,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  State<TopUpSuccessScreen> createState() => _TopUpSuccessScreenState();
}

class _TopUpSuccessScreenState extends State<TopUpSuccessScreen> {

  @override
  void initState() {
    super.initState();
    // ✅ បន្ថែមរំញ័រអបអរសាទរពេលបើកស្គ្រីន
    HapticFeedback.lightImpact();
  }

  // 💡 មុខងារ Format លេខទឹកប្រាក់
  String get _formattedAmount => NumberFormat("#,##0.00").format(widget.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        child: Stack( // 💡 ប្រើ Stack ដើម្បីអាចដាក់ Confetti ឬ background element
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // ✅ Premium Success Icon (NJU Style)
                    _buildAnimatedCheck(),

                    const SizedBox(height: 32),

                    // ✅ Success Title
                    const Text(
                      'RECHARGE SUCCESS!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColor.lightGold,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Subtitle
                    Text.rich(
                      TextSpan(
                        text: 'Your NJU Wallet has been credited with\n',
                        style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                        children: [
                          TextSpan(
                            text: '¥ $_formattedAmount',
                            style: const TextStyle(color: AppColor.accentGold, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // ✅ Glassmorphism Receipt Card
                    _buildGlassReceipt(),

                    const Spacer(),

                    // ✅ Download Receipt Button
                    _buildLuxuryButton(
                      context,
                      label: 'SHARE RECEIPT',
                      icon: Icons.share_rounded,
                      isPrimary: true,
                      onTap: () => _handleShare(context),
                    ),

                    const SizedBox(height: 16),

                    // ✅ Return Button
                    _buildLuxuryButton(
                      context,
                      label: 'BACK TO DASHBOARD',
                      icon: Icons.dashboard_rounded,
                      isPrimary: false,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MainHolder()),
                              (route) => false,
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCheck() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColor.accentGold.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColor.accentGold,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColor.accentGold, blurRadius: 30, spreadRadius: -5)
                  ],
                ),
                child: const Icon(Icons.check_rounded, size: 60, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassReceipt() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              _buildRow('Status', 'Success', color: Colors.greenAccent),
              _buildDivider(),
              _buildRow('Total Recharge', '¥ $_formattedAmount'),
              _buildDivider(),
              _buildRow('Payment via', widget.paymentMethod),
              _buildDivider(),
              _buildRow('Transaction ID', 'NJU-${DateTime.now().millisecondsSinceEpoch}'),
              _buildDivider(),
              _buildRow('Date Time', DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(height: 0.5, color: Colors.white.withOpacity(0.05)),
    );
  }

  Widget _buildLuxuryButton(BuildContext context, {required String label, required IconData icon, required bool isPrimary, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: isPrimary ? BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: AppColor.accentGold.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))]
      ) : null,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColor.accentGold : Colors.white.withOpacity(0.06),
          foregroundColor: isPrimary ? Colors.black : Colors.white70,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          side: isPrimary ? BorderSide.none : const BorderSide(color: Colors.white10),
        ),
      ),
    );
  }

  void _handleShare(BuildContext context) {
    HapticFeedback.mediumImpact();
    _showDownloadToast(context);
  }

  void _showDownloadToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 10),
            Text('Receipt details copied to clipboard!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.green[800],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}