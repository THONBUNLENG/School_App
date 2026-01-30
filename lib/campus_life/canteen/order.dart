import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/campus_life/canteen/payment_confirmation_screen.dart';
import '../../config/app_color.dart';
import '../../extension/change_notifier.dart';
import '../../extension/string_extension.dart';
import '../../model/food.dart';

class OrderScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const OrderScreen({super.key, required this.cartItems});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final double deliveryFee = 0.00;
  final double commonImageSize = 65.0; // បង្កើនទំហំបន្តិចឱ្យមើលទៅច្បាស់

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = context.watch<ThemeManager>().isDarkMode;

        return AlertDialog(
          backgroundColor: isDark ? AppColor.surfaceColor : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Clear Cart".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to remove all items from the cart?".tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr, style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() => widget.cartItems.clear());
                Navigator.pop(context);
              },
              child: Text("Clear All".tr, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeManager>().isDarkMode;

    double subtotal = widget.cartItems.fold<double>(0.0, (sum, item) => sum + item.finalTotalPrice);
    double total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: Text(
          "Confirm Order".tr,
          style: const TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.cartItems.isNotEmpty)
            TextButton(
              onPressed: _clearCart,
              child: Text("Clear".tr, style: const TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: widget.cartItems.isEmpty
          ? _buildEmptyCart(isDark)
          : Column(
        children: [
          _buildAddMoreHeader(isDark),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Dismissible(
                  key: ValueKey(item.hashCode),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => setState(() => widget.cartItems.removeAt(index)),
                  background: _buildDeleteBackground(),
                  child: _buildCartTile(item, isDark),
                );
              },
            ),
          ),
          _buildCheckoutSection(subtotal, total, isDark),
        ],
      ),
    );
  }

  Widget _buildCartTile(CartItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.food.img, width: commonImageSize, height: commonImageSize, fit: BoxFit.cover),
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
                            color: isDark ? Colors.white : AppColor.primaryColor)),
                    const SizedBox(height: 5),
                    Text(
                      "Size: ${item.size} | Qty: ${item.quantity}".tr,
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "¥${item.finalTotalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color:Colors.orange),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                    onPressed: () => setState(() => widget.cartItems.remove(item)),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          if (item.sides.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: isDark ? Colors.white10 : Colors.grey.shade100, thickness: 1),
            ),
            ...item.sides.map((side) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(side['img'], width: 40, height: 40, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(side['name'],
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade800, fontSize: 13)),
                  ),
                  Text("+¥${(side['price'] as num).toDouble().toStringAsFixed(2)}",
                      style: TextStyle(color: isDark ? AppColor.lightGold : Colors.grey.shade500, fontSize: 13)),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(double subtotal, double total, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 35),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Payment".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
              Text(
                "¥${total.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              gradient: BrandGradient.goldMetallic,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: AppColor.accentGold.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentConfirmationScreen(cartItems: widget.cartItems)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text("Confirm & Pay".tr,
                  style: const TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 25),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(color: Colors.redAccent.shade400, borderRadius: BorderRadius.circular(20)),
      child: const Icon(Icons.delete_forever, color: Colors.white, size: 28),
    );
  }

  Widget _buildEmptyCart(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: isDark ? Colors.white10 : Colors.grey.shade200),
          const SizedBox(height: 20),
          Text("Your cart is empty!".tr, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 16)),
          const SizedBox(height: 25),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
           // style: OutlinedButton.styleFrom(side: const Border.all(color:Colors.orange)),
            child: Text("Browse Menu".tr, style: const TextStyle(color: AppColor.primaryColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColor.primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: AppColor.primaryColor, size: 20),
              const SizedBox(width: 10),
              Text(
                "Add New Menu Items".tr,
                style: const TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
