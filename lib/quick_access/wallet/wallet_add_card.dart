import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_app/quick_access/wallet/qr_card.dart';
import '../../config/app_color.dart';
import '../topup/net_topup_page.dart';
import 'card_wallet.dart'; // 💡 ត្រូវប្រាកដថា VIPCardFlippable នៅក្នុងនេះ

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
    await Future.delayed(const Duration(milliseconds: 1200));
    return 120567123.68;
  }

  double cnyToUsd(double cny) => cny * 0.138;

  String formatCurrency(double amount) {
    return NumberFormat("#,##0.00", "en_US").format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background ខ្មៅដើម្បីឱ្យ Gradient ចាំងខ្លាំង
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: BrandGradient.luxury, // ស្វាយដិតទៅកាន់ខ្មៅ
        ),
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
                        child: CircularProgressIndicator(
                          color: AppColor.accentGold,
                          strokeWidth: 2,
                        ),
                      );
                    }

                    final balance = snapshot.data ?? 0.0;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // --- ១. VIP Flip Card (NJU Luxury) ---
                          const VIPCardFlippable(),

                          const SizedBox(height: 40),

                          // --- ២. Balance Section ---
                          _buildBalanceSection(balance),

                          const SizedBox(height: 30),

                          // --- ៣. Action Buttons (Glass Style) ---
                          _buildActionButtons(),

                          const SizedBox(height: 40),

                          // --- ៤. Recent Transactions ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _sectionTitle('Recent Transactions'),
                              TextButton(
                                onPressed: () {},
                                child: const Text("See All", style: TextStyle(color: AppColor.accentGold, fontSize: 13)),
                              )
                            ],
                          ),
                          _buildTransactionList(),

                          const SizedBox(height: 30),

                          // --- ៥. Settings Section ---
                          _sectionTitle('Security Settings'),
                          _buildSpendingLimitCard(),

                          const SizedBox(height: 60), // Space សម្រាប់បាត
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
            "NJU  WALLET", // ប្តូរមក Branding របស់សាលាវិញ
            style: TextStyle(
              color: AppColor.lightGold,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [AppColor.accentGold, Colors.white24]),
            ),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset('assets/image/me.png', fit: BoxFit.cover, width: 34, height: 34),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(double balance) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Assets", style: TextStyle(color: Colors.white38, fontSize: 13, letterSpacing: 1)),
                const SizedBox(height: 10),
                Text(
                  _isBalanceVisible ? "¥ ${formatCurrency(balance)}" : "¥ • • • • • •",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isBalanceVisible ? "≈ \$${formatCurrency(cnyToUsd(balance))} USD" : "≈ \$ • • • •",
                  style: TextStyle(color: AppColor.accentGold.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.accentGold.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColor.accentGold,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _glassButton(
          icon: Icons.account_balance_wallet_rounded,
          label: "Top Up",
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TopUpWallet())),
        )),
        const SizedBox(width: 15),
        Expanded(child: _glassButton(
          icon: Icons.qr_code_scanner_rounded,
          label: "My QR",
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyQrScreen())),
        )),
      ],
    );
  }

  Widget _glassButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.03)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColor.accentGold, size: 20),
                const SizedBox(width: 10),
                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final transactions = [
      {"title": "Library Printing", "date": "Jan 29, 2026", "amount": -15.0, "isPlus": false, "icon": Icons.print_rounded},
      {"title": "Scholarship", "date": "Jan 27, 2026", "amount": 5000.0, "isPlus": true, "icon": Icons.stars_rounded},
      {"title": "Canteen Payment", "date": "Jan 26, 2026", "amount": -45.5, "isPlus": false, "icon": Icons.fastfood_rounded},
    ];

    return Column(
      children: transactions.map((tx) {
        return _transactionTile(
            tx["title"] as String,
            tx["date"] as String,
            tx["amount"] as double,
            tx["isPlus"] as bool,
            tx["icon"] as IconData
        );
      }).toList(),
    );
  }

  Widget _transactionTile(String title, String date, double amount, bool isPlus, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPlus ? Colors.green.withOpacity(0.1) : AppColor.accentGold.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: isPlus ? Colors.greenAccent : AppColor.accentGold, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.white24, fontSize: 11)),
              ],
            ),
          ),
          Text(
            "${isPlus ? '+' : ''}¥${formatCurrency(amount.abs())}",
            style: TextStyle(
              color: isPlus ? Colors.greenAccent : Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingLimitCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: SwitchListTile(
        title: const Text('Biometric Authentication', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: const Text('Use FaceID for quick payments', style: TextStyle(color: Colors.white24, fontSize: 11)),
        value: _spendingLimitEnabled,
        onChanged: (val) => setState(() => _spendingLimitEnabled = val),
        activeColor: AppColor.accentGold,
        inactiveTrackColor: Colors.white10,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)
    );
  }
}