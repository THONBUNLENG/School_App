import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extension/change_notifier.dart';
import '../../extension/string_extension.dart';
import '../../model/food.dart';
import '../../config/app_color.dart';

enum PaymentType { wechat, alipay, icbc }

class PaymentConfirmationScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const PaymentConfirmationScreen({super.key, required this.cartItems});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _rotationController;
  bool _isProcessing = false;
  bool _isSuccess = false;
  String _loadingMessage = "Processing your order...";
  final double deliveryFee = 0.00;
  PaymentType _selectedType = PaymentType.alipay;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handlePayment() async {
    setState(() {
      _isProcessing = true;
      _loadingMessage = "Processing your order...";
    });
    _rotationController.repeat();

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _loadingMessage = "Verifying with Canteen...");

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _loadingMessage = "Finalizing order...");

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      _rotationController.stop();
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;
    final bgColor = isDark ? AppColor.backgroundColor : Colors.white;
    final textColor = isDark ? Colors.white : AppColor.primaryColor;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade600;

    double subtotal = widget.cartItems.fold<double>(
      0, (sum, item) => sum + item.finalTotalPrice,
    );

    if (_isSuccess) return _buildSuccessUI(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: Text("Checkout".tr, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.lightGold)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          _buildCheckoutUI(subtotal, isDark, textColor, subTextColor),
          if (_isProcessing) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // --- CHECKOUT UI ---
  Widget _buildCheckoutUI(double subtotal, bool isDark, Color textColor, Color subTextColor) {
    final cardColor = isDark ? AppColor.surfaceColor : Colors.white;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              final item = widget.cartItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColor.glassBorder),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(item.food.img, width: 70, height: 70, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.food.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                          const SizedBox(height: 4),
                          Text("${item.size} • Qty: ${item.quantity}", style: TextStyle(color: subTextColor, fontSize: 13)),
                        ],
                      ),
                    ),
                    Text("¥${item.finalTotalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
              );
            },
          ),
        ),
        _buildPaymentSummary(subtotal, isDark, textColor, subTextColor),
      ],
    );
  }

  // --- LOADING OVERLAY (Fixed & Premium) ---
  Widget _buildLoadingOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _rotationController,
              child: Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.accentGold, width: 3),
                  boxShadow: [
                    BoxShadow(color: AppColor.accentGold.withOpacity(0.5), blurRadius: 20, spreadRadius: 2)
                  ],
                ),
                child: ClipOval(
                  child: Image.asset("assets/image/logo_profile.png", fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              _loadingMessage,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            const SizedBox(
              width: 140,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.accentGold),
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PAYMENT SUMMARY ---
  Widget _buildPaymentSummary(double subtotal, bool isDark, Color textColor, Color subTextColor) {
    final total = subtotal + deliveryFee;

    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _paymentTile("微信支付 (WeChat)", "assets/image/wechat.png", PaymentType.wechat, isDark),
          const SizedBox(height: 12),
          _paymentTile("支付宝 (Alipay)", "assets/image/alipay.png", PaymentType.alipay, isDark),
          const SizedBox(height: 12),
          _paymentTile("工商银行 (ICBC)", "assets/image/icbc_icon.png", PaymentType.icbc, isDark),

          const SizedBox(height: 25),
          _summaryRow("Subtotal", "¥${subtotal.toStringAsFixed(2)}", subTextColor),
          const SizedBox(height: 10),
          _summaryRow("Delivery Fee", "¥${deliveryFee.toStringAsFixed(2)}", subTextColor),
          const Divider(height: 30, thickness: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              Text("¥${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.orange)),
            ],
          ),

          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              gradient: BrandGradient.goldMetallic,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ElevatedButton(
              onPressed: _handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("确认支付 (Confirm)",
                  style: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentTile(String title, String iconPath, PaymentType type, bool isDark) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? AppColor.backgroundColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? AppColor.accentGold : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 30, height: 30),
            const SizedBox(width: 15),
            Expanded(child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColor.primaryColor))),
            Icon(isSelected ? Icons.check_circle : Icons.radio_button_off,
                color: isSelected ? AppColor.accentGold : Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- SUCCESS UI ---
  Widget _buildSuccessUI(bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, color: AppColor.accentGold, size: 100),
              const SizedBox(height: 20),
              Text("Payment Successful!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColor.primaryColor)),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Back to Home", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
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
        Text(label, style: TextStyle(color: textColor, fontSize: 14)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
      ],
    );
  }
}