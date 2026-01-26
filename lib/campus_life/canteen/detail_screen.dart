import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extension/change_notifier.dart';
import '../../extension/string_extension.dart';
import '../../model/food.dart';
import 'list_food.dart';

class DetailScreen extends StatefulWidget {
  final Food food;
  final int cartCount;
  final ValueChanged<CartItem> onAddToCart;

  const DetailScreen({
    super.key,
    required this.food,
    required this.cartCount,
    required this.onAddToCart,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final int _quantity = 1;
  String _selectedSize = 'Regular';
  bool _isLiked = false;
  final Color brandOrange = const Color(0xFFD85D22);

  // ---------------- PRICE LOGIC ----------------
  double get _totalSidesPrice => sideData
      .where((side) => side['isSelected'] == true)
      .fold<double>(0, (sum, side) => sum + (side['price'] as num).toDouble());

  double get _finalTotalPrice {
    double basePrice = widget.food.price;
    if (_selectedSize == 'Large') basePrice *= 1.3;
    return (basePrice + _totalSidesPrice) * _quantity;
  }

  CartItem _createCartItem() {
    return CartItem(
      food: widget.food,
      size: _selectedSize,
      quantity: _quantity,
      sides: sideData.where((s) => s['isSelected'] == true).toList(),
      finalTotalPrice: _finalTotalPrice,
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();
    final isDark = themeManager.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: _buildAppBar(isDark),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroHeader(isDark),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildTitlePriceRow(isDark),
                      const SizedBox(height: 24),
                      _buildSizeSelector(),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(),
                      const SizedBox(height: 28),
                      Text(
                        "Recommended sides".tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildSidesList(isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomActionSheet(isDark),
        ],
      ),
    );
  }

  // ---------------- TITLE + PRICE ----------------
  Widget _buildTitlePriceRow(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.food.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        Text(
          "\¥${_finalTotalPrice.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: brandOrange,
          ),
        ),
      ],
    );
  }

  // ---------------- BOTTOM BAR ----------------
  Widget _buildBottomActionSheet(bool isDark) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price".tr,
                  style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.grey[400] : Colors.grey),
                ),
                Text(
                  "\¥${_finalTotalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: brandOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildCartIconButton(),
                const SizedBox(width: 15),
                Expanded(child: _buildBuyNowButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIconButton() {
    return Container(
      height: 55,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: brandOrange.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(Icons.add_shopping_cart_outlined, color: brandOrange),
        onPressed: () {
          widget.onAddToCart(_createCartItem());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Added to cart!".tr),
              backgroundColor: brandOrange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 800),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBuyNowButton() {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          final newItem = _createCartItem();
          widget.onAddToCart(newItem);
          Navigator.pop(context, "go_to_checkout");
        },
        icon: const Icon(Icons.shopping_cart_checkout),
        label: Text("Order Now".tr,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(backgroundColor: brandOrange),
      ),
    );
  }

  // ---------------- SIDES ----------------
  Widget _buildSidesList(bool isDark) {
    return SizedBox(
      height: 195,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sideData.length,
        itemBuilder: (context, index) {
          final item = sideData[index];
          return GestureDetector(
            onTap: () => setState(() => item['isSelected'] = !item['isSelected']),
            child: _sideCard(
              item['name'],
              "\¥${(item['price'] as num).toStringAsFixed(2)}",
              item['img'],
              item['isSelected'],
              isDark,
            ),
          );
        },
      ),
    );
  }

  Widget _sideCard(
      String name, String price, String img, bool isSelected, bool isDark) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15, bottom: 5),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? brandOrange : Colors.grey.shade200,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: brandOrange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ]
            : [],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          child: Image.network(
            img,
            height: 90,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 90,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
              Icon(isSelected ? Icons.check_circle : Icons.add_circle,
                  color: brandOrange, size: 20),
            ]),
          ]),
        ),
      ]),
    );
  }

  // ---------------- HEADER ----------------
  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Details".tr,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined,
                    color: isDark ? Colors.white : Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              if (widget.cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.orange,
                    child: Text(widget.cartCount.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 9)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroHeader(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 250,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(alignment: Alignment.bottomRight, children: [
          Hero(
            tag: '${widget.food.name}-${widget.food.img}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(widget.food.img,
                  height: 250, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () => setState(() => _isLiked = !_isLiked),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : brandOrange,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Select Size".tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(
        children: ['Regular', 'Large'].map((size) {
          final isSelected = _selectedSize == size;
          return GestureDetector(
            onTap: () => setState(() => _selectedSize = size),
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? brandOrange : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Text(
                size,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  Widget _buildDescriptionSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Description".tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(
        widget.food.des,
        style: const TextStyle(fontSize: 14, height: 1.5),
      ),
    ]);
  }
}
