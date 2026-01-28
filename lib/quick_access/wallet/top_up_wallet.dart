import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import '../../config/app_color.dart';
import '../topup/top_up_pay.dart';
import 'package:local_auth_android/local_auth_android.dart';

class TopUpWallet extends StatefulWidget {
  const TopUpWallet({super.key});

  @override
  State<TopUpWallet> createState() => _TopUpWalletScreenState();
}

class _TopUpWalletScreenState extends State<TopUpWallet> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _faceIDEnabled = false;
  final TextEditingController _amountController =
  TextEditingController(text: '50');

  double get amount => double.tryParse(_amountController.text) ?? 0;

  void _increase() {
    double current = amount;
    current += 50;
    _amountController.text = current.toStringAsFixed(0);
    setState(() {});
  }

  void _decrease() {
    double current = amount;
    if (current > 0) {
      current -= 50;
      if (current < 0) current = 0;
      _amountController.text = current.toStringAsFixed(0);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: const Text(
          'Top-up Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF806B9F), Colors.black87],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "¥ 120,567,123.68",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Current Balance",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 30),
            _buildInputCard(),
            const Spacer(),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Amount Selection",
              style: TextStyle(color: Colors.white70, fontSize: 15)),
          const SizedBox(height: 16),

          /// + - BUTTONS + INPUT
          Row(
            children: [
              _buildCircleButton(Icons.remove, _decrease),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixText: '¥ ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _buildCircleButton(Icons.add, _increase),
            ],
          ),

          const SizedBox(height: 20),

          /// SHOW FACEID ONLY IF >= 1000
          if (amount >= 1000)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Enable FaceID",
                    style: TextStyle(color: Colors.white70)),
                CupertinoSwitch(
                  value: _faceIDEnabled,
                  activeColor: AppColor.accentGold,
                  onChanged: (val) =>
                      setState(() => _faceIDEnabled = val),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomAction() {
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
          onPressed: () async {
            if (amount <= 0) return;

            bool authenticated = true;

            /// VERIFY ONLY IF >= 1000
            if (amount >= 1000) {
              authenticated = await auth.authenticate(
                localizedReason:
                'Verify your identity for large transaction',
                options: const AuthenticationOptions(
                    biometricOnly: true),
              );
            }

            if (authenticated && mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TopUpPayment(
                    amount: amount,
                    childName: "He Wenlin",
                    note: "Top up wallet",
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.accentGold,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text(
            "Next: Select Method",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
