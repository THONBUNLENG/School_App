import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/campus_life/canteen/payment_confirmation_screen.dart';
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
  final double commonImageSize = 60.0;

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) {
        final themeManager = context.watch<ThemeManager>();
        final isDark = themeManager.isDarkMode;

        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Clear Cart".tr),
          content: Text("Are you sure you want to remove all items from the cart?".tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel".tr,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => widget.cartItems.clear());
                Navigator.pop(context);
              },
              child: Text(
                "Clear All".tr,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();
    final isDark = themeManager.isDarkMode;

    double subtotal = widget.cartItems.fold<double>(0.0, (sum, item) => sum + item.finalTotalPrice);
    double total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          "Confirm Order".tr,
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (widget.cartItems.isNotEmpty)
            TextButton(
              onPressed: _clearCart,
              child: Text(
                "Clear".tr,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
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
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.03),
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
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.food.img,
                  width: commonImageSize,
                  height: commonImageSize,
                  fit: BoxFit.cover,
                ),
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
                            color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(height: 5),
                    Text(
                      "Size: ${item.size} | Qty: ${item.quantity}".tr,
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    "¥${item.finalTotalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFD85D22),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // --- DELETE BUTTON ---
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        widget.cartItems.remove(item);
                      });
                    },
                    tooltip: "Delete Item".tr,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          if (item.sides.isNotEmpty) ...[
            Divider(color: isDark ? Colors.grey[700] : const Color(0xFFF5F5F5), thickness: 1.5),
            ...item.sides.map((side) {
              final price = (side['price'] as num).toDouble();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        side['img'],
                        width: commonImageSize,
                        height: commonImageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(side['name'],
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.grey.shade800,
                                  fontSize: 14)),
                          Text("Extra side".tr,
                              style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey,
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                    Text(
                      "+¥${price.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey.shade500,
                          fontSize: 14),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }


  Widget _buildCheckoutSection(double subtotal, double total, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Payment".tr,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black)),
              Text(
                "¥${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD85D22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymentConfirmationScreen(cartItems: widget.cartItems),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B2682)),
              child: Text("Confirm & Pay".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.red.shade400, borderRadius: BorderRadius.circular(15)),
      child: const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
    );
  }

  Widget _buildEmptyCart(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 100, color: isDark ? Colors.grey[700] : Colors.grey.shade300),
          const SizedBox(height: 20),
          Text("Your cart is empty!".tr,
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey, fontSize: 18)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Browse Menu".tr),
          ),
        ],
      ),
    );
  }
  Widget _buildAddMoreHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF8B2682).withOpacity(0.08),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF8B2682).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: isDark ? Colors.white : const Color(0xFF8B2682),
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                "Add New Menu Items".tr,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF8B2682),
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Fixed property name
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
