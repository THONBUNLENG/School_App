import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extension/change_notifier.dart';
import '../../model/food.dart';

enum PaymentType { wechat, alipay, icbc }

class PaymentConfirmationScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const PaymentConfirmationScreen({super.key, required this.cartItems});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  // --- 2. STATE VARIABLES ---
  bool _isProcessing = false;
  bool _isSuccess = false;
  String _loadingMessage = "Processing your order...";
  final double deliveryFee = 0.00;

  PaymentType _selectedType = PaymentType.alipay;

  void _handlePayment() async {
    setState(() => _isProcessing = true);

    // Simulated API calls
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _loadingMessage = "Verifying with Canteen...");

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _loadingMessage = "Finalizing order...");

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey.shade600;

    // Calculate subtotal
    double subtotal = widget.cartItems.fold<double>(
      0,
          (sum, item) => sum + item.finalTotalPrice,
    );

    if (_isSuccess) return _buildSuccessUI();
    if (_isProcessing) return _buildLoadingUI();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
        elevation: 0,
        foregroundColor: textColor,
        centerTitle: true,
      ),
      body: _buildCheckoutUI(subtotal, cardColor, textColor, subTextColor),
    );
  }

  // --- CHECKOUT UI ---
  Widget _buildCheckoutUI(
      double subtotal, Color? cardColor, Color? textColor, Color? subTextColor) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              final item = widget.cartItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  border: Border.all(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(item.food.img,
                          width: 70, height: 70, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.food.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: textColor)),
                          const SizedBox(height: 4),
                          Text(
                            "Size: ${item.size} • Qty: ${item.quantity}",
                            style: TextStyle(color: subTextColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "¥${item.finalTotalPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildPaymentSummary(subtotal, cardColor, textColor, subTextColor),
      ],
    );
  }

  // --- PAYMENT SUMMARY SECTION ---
  Widget _buildPaymentSummary(
      double subtotal, Color? cardColor, Color? textColor, Color? subTextColor) {
    final total = subtotal + deliveryFee;
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : const Color(0xFFF5F5F5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5))
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _paymentTile("微信", "assets/image/wechat.png", PaymentType.wechat, textColor!),
          const SizedBox(height: 12),
          _paymentTile("支付宝", "assets/image/alipay.png", PaymentType.alipay, textColor),
          const SizedBox(height: 12),
          _paymentTile("工商银行卡", "assets/image/icbc_icon.png", PaymentType.icbc, textColor),

          const SizedBox(height: 30),

          _summaryRow("Subtotal", "¥${subtotal.toStringAsFixed(2)}", subTextColor!),
          const SizedBox(height: 12),
          _summaryRow("Delivery Free", "¥${deliveryFee.toStringAsFixed(2)}", subTextColor),
          const Divider(height: 30, thickness: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
              Text("¥${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD85D22))),
            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B2682),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("确认支付",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile(String title, String iconPath, PaymentType type, Color textColor) {
    bool isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Provider.of<ThemeManager>(context).isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 28, height: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF8B2682) : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                      color: Color(0xFF8B2682), shape: BoxShape.circle),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // --- LOADING UI ---
  Widget _buildLoadingUI() {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF8B2682)),
            const SizedBox(height: 30),
            Text(_loadingMessage,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }

  // --- SUCCESS UI ---
  Widget _buildSuccessUI() {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              Text("Order Successful!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text("Back to Menu",
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: textColor, fontSize: 15)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor)),
      ],
    );
  }
}
