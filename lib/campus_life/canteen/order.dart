import 'package:flutter/material.dart';
import '../../model/food.dart';


class OrderScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const OrderScreen({super.key, required this.cartItems});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final double deliveryFee = 1.00;
  final double commonImageSize = 60.0;
  bool _isProcessing = false;


  void _clearCart() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Clear Cart"),
          content: const Text("តើអ្នកពិតជាចង់លុបទំនិញទាំងអស់ចេញពីកន្ត្រកមែនទេ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("បោះបង់", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() => widget.cartItems.clear());
                Navigator.pop(context);
              },
              child: const Text("លុបទាំងអស់",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.cartItems.fold<double>(0.0, (sum, item) => sum + item.finalTotalPrice);
    double total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text("Confirm Order",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (widget.cartItems.isNotEmpty)
            TextButton(
              onPressed: _clearCart,
              child: const Text("Clear", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: widget.cartItems.isEmpty ? _buildEmptyCart() : Column(
        children: [
          _buildAddMoreHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => setState(() => widget.cartItems.removeAt(index)),
                  background: _buildDeleteBackground(),
                  child: _buildCartTile(item),
                );
              },
            ),
          ),
          _buildCheckoutSection(subtotal, total),
        ],
      ),
    );
  }

  Widget _buildCartTile(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item.food.img, width: commonImageSize, height: commonImageSize, fit: BoxFit.cover),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text("Size: ${item.size} | Qty: ${item.quantity}", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
              Text("\$${item.finalTotalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFD85D22))),
            ],
          ),
          if (item.sides.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: Color(0xFFF5F5F5), thickness: 1.5)),
            ...item.sides.map((side) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(side['img'], width: commonImageSize, height: commonImageSize, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(side['name'], style: TextStyle(color: Colors.grey.shade800, fontSize: 14)),
                        const Text("Extra side", style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                  Text("+\$${(side['price'] as double).toStringAsFixed(2)}", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                ],
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(double subtotal, double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 35),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _priceRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
          const SizedBox(height: 10),
          _priceRow("Delivery Fee", "\$${deliveryFee.toStringAsFixed(2)}"),
          const Divider(height: 30, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("\$${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD85D22))),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : () async {
                setState(() => _isProcessing = true);
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                setState(() => _isProcessing = false);
               // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentConfirmationScreen(cartItems: widget.cartItems)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD85D22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: _isProcessing
                  ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Confirm & Pay", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ],
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(15)),
      child: const Icon(Icons.delete_sweep, color: Colors.white, size: 30),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          const Text("Your cart is empty!", style: TextStyle(color: Colors.grey, fontSize: 18)),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Browse Menu")),
        ],
      ),
    );
  }

  Widget _buildAddMoreHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFD85D22).withOpacity(0.08),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFD85D22).withOpacity(0.3)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: Color(0xFFD85D22), size: 20),
              SizedBox(width: 10),
              Text("Add New Menu Items", style: TextStyle(color: Color(0xFFD85D22), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}