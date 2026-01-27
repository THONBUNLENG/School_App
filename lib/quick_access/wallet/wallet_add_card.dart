import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_app/quick_access/wallet/qr_card.dart';
import '../../config/app_color.dart';
import 'top_up_wallet.dart';
import 'qr_scanned.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    return 120567.68; // Mock balance
  }

  double cnyToUsd(double cny) => cny * 0.138;

  String formatCurrency(double amount) {
    return NumberFormat("#,##0.00", "en_US").format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF6F7FB);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "My Wallet",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF81005B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              // Open QR Scanner
              final scannedCode = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrScannerScreen()),
              );

              if (scannedCode != null) {
                // Do something with the scanned code
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Scanned QR: $scannedCode')),
                );
              }
            },
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
          ),
        ],
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<double>(
          future: _balanceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final balance = snapshot.data ?? 0.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(textColor, isDark),
                const SizedBox(height: 16),
                _buildBalanceCard(context, balance),
                const SizedBox(height: 24),
                _buildActionButtons(),
                const SizedBox(height: 32),
                _sectionTitle('Linked Payment Methods', textColor),
                const SizedBox(height: 12),
                _buildGroupedPaymentMethods(cardColor, isDark),
                const SizedBox(height: 20),
                _sectionTitle('Transaction History', textColor),
                const SizedBox(height: 12),
                _buildTransactionList(cardColor, textColor),
                const SizedBox(height: 20),
                _sectionTitle('Spending Limits', textColor),
                const SizedBox(height: 12),
                _buildSpendingLimitCard(cardColor, textColor),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("My Wallet", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
        Text("Manage your campus funds", style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.black26)),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          colors: [AppColor.primaryColor, AppColor.primaryColor.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("WALLET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text("Available Balance", style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _isBalanceVisible ? "¥${formatCurrency(balance)}" : "¥ • • • •",
              key: ValueKey<bool>(_isBalanceVisible),
              style: TextStyle(
                color: Colors.white,
                fontSize: _isBalanceVisible ? 32.0 : 26.0,
                fontWeight: FontWeight.bold,
                letterSpacing: _isBalanceVisible ? 0.0 : 2.0,
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _isBalanceVisible ? "≈ \$${formatCurrency(cnyToUsd(balance))}" : "≈ \$ • • • •",
              key: ValueKey<String>(_isBalanceVisible ? 'showUsd' : 'hideUsd'),
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Student Wallet", style: TextStyle(color: Colors.white70, fontSize: 11)),
              Text("Tap for details", style: TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    const primaryPurple = Color(0xFF81005B);
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TopUpWallet())),
            icon: const Icon(Icons.add_circle_outline_sharp, size: 20),
            label: const Text('Add Money'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple.withOpacity(0.15),
              foregroundColor: primaryPurple,
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MyQrScreen()));
            },
            icon: const Icon(Icons.qr_code, size: 20),
            label: const Text('My QR'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple.withOpacity(0.15),
              foregroundColor: primaryPurple,
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupedPaymentMethods(Color cardColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          _methodItem('WeChat Pay', 'Digital Wallet', 'assets/image/wechat.png', true),
          const Divider(height: 1),
          _methodItem('Alipay', 'Digital Wallet', 'assets/image/alipay.png', true),
          const Divider(height: 1),
          _methodItem('ICBC Bank', 'Bank Transfer', 'assets/image/icbc_icon.png', true),
          const Divider(height: 1),
          _methodItem('Mastercard', '•••• 5678', null, false, icon: Icons.credit_card),
        ],
      ),
    );
  }

  Widget _methodItem(String title, String subtitle, String? assetPath, bool isAsset, {IconData? icon}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF81005B).withOpacity(0.1),
        child: isAsset ? Padding(padding: const EdgeInsets.all(8), child: Image.asset(assetPath!)) : Icon(icon, color: const Color(0xFF81005B)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }

  Widget _buildTransactionList(Color cardColor, Color textColor) {
    return Column(
      children: [
        _transactionItem(cardColor, textColor, Icons.receipt_long, 'Tuition Fee Payment', -500),
        _transactionItem(cardColor, textColor, Icons.add_circle, 'Wallet Top-up', 200),
      ],
    );
  }

  Widget _transactionItem(Color cardColor, Color textColor, IconData icon, String title, double amount) {
    final isPlus = amount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        trailing: Text(
          '${isPlus ? '+' : ''}¥${formatCurrency(amount.abs())}',
          style: TextStyle(color: isPlus ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSpendingLimitCard(Color cardColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        title: Text('Set spending limits', style: TextStyle(color: textColor)),
        value: _spendingLimitEnabled,
        onChanged: (val) => setState(() => _spendingLimitEnabled = val),
        activeColor: const Color(0xFF81005B),
      ),
    );
  }

  Widget _sectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
    );
  }
}
