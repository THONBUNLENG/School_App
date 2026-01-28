import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_app/quick_access/wallet/qr_card.dart';
import '../../config/app_color.dart';
import '../topup/net_topup_page.dart';
import 'card_wallet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key, required this.title});
  final String title;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _spendingLimitEnabled = true;
  bool _isBalanceVisible = true;
  late Future<double> _balanceFuture;

  @override
  void initState() {
    super.initState();
    _balanceFuture = fetchBalance();
  }

  Future<double> fetchBalance() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 120567123.68;
  }

  double cnyToUsd(double cny) => cny * 0.138;

  String formatCurrency(double amount) {
    return NumberFormat("#,##0.00", "en_US").format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildTransparentAppBar(context),
              Expanded(
                child: FutureBuilder<double>(
                  future: _balanceFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColor.accentGold),
                      );
                    }

                    final balance = snapshot.data ?? 0.0;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          // VIP Card
                          const VIPCardFlippable(),
                          const SizedBox(height: 35),
                          _buildBalanceSection(balance),
                          const SizedBox(height: 25),
                          _buildActionButtons(),
                          const SizedBox(height: 40),
                          _sectionTitle('Recent Transactions'),
                          _buildTransactionList(),
                          const SizedBox(height: 25),
                          _sectionTitle('Settings'),
                          _buildSpendingLimitCard(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransparentAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "FTB  Wallet",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColor.lightGold,
            child: ClipOval(
              child: Image.asset(
                'assets/image/me.png',
                width: 38,
                height: 38,
                fit: BoxFit.cover,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildBalanceSection(double balance) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Available Balance", style: TextStyle(color: Colors.white60, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                _isBalanceVisible ? "¥ ${formatCurrency(balance)}" : "¥ • • • • • •",
                style: const TextStyle(
                  color: AppColor.accentGold,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isBalanceVisible ? "≈ \$${formatCurrency(cnyToUsd(balance))} USD" : "≈ \$ • • • •",
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Icon(
              _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColor.accentGold,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _glassButton(icon: Icons.add_rounded, label: "Add Money", onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const  TopUpWallet()),
          );
        },)),
        const SizedBox(width: 15),
        Expanded(
          child: _glassButton(
            icon: Icons.qr_code_2_rounded,
            label: "My QR Code",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const  MyQrScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _glassButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColor.accentGold, size: 22),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final transactions = [
      {"title": "Salary Deposit", "date": "Jan 27, 2026", "amount": 20000.0, "isPlus": true, "icon": Icons.account_balance_wallet_rounded},
      {"title": "Online Purchase", "date": "Jan 26, 2026", "amount": -500.0, "isPlus": false, "icon": Icons.shopping_cart_rounded},
    ];

    return Column(
      children: transactions.map((tx) {
        return _transactionTile(tx["title"] as String, tx["date"] as String, tx["amount"] as double,
            tx["isPlus"] as bool, tx["icon"] as IconData);
      }).toList(),
    );
  }

  Widget _transactionTile(String title, String date, double amount, bool isPlus, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPlus ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isPlus ? Colors.greenAccent : Colors.redAccent, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Text(
            "${isPlus ? '+' : ''}¥${formatCurrency(amount.abs())}",
            style: TextStyle(
              color: isPlus ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingLimitCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: const Text('Daily spending limit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        value: _spendingLimitEnabled,
        onChanged: (val) => setState(() => _spendingLimitEnabled = val),
        activeColor: AppColor.accentGold,
        inactiveTrackColor: Colors.white10,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
