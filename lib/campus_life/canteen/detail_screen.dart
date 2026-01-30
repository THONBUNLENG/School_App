import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart';
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
  int _quantity = 1;
  String _selectedSize = 'Regular';
  bool _isLiked = false;

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
                      _buildTitlePriceRowWithQuantity(isDark),
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

  // ---------------- TITLE + PRICE + QUANTITY ----------------
  Widget _buildTitlePriceRowWithQuantity(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                color: AppColor.brandOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildQuantitySelector(isDark),
      ],
    );
  }

  // ---------------- QUANTITY SELECTOR ----------------
  Widget _buildQuantitySelector(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // move to right
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: isDark ? Colors.white : Colors.black),
                onPressed: () {
                  if (_quantity > 1) setState(() => _quantity--);
                },
              ),
              Text(
                _quantity.toString(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black),
              ),
              IconButton(
                icon: Icon(Icons.add, color: isDark ? Colors.white : Colors.black),
                onPressed: () {
                  setState(() => _quantity++);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }


  // ---------------- SIZE SELECTOR ----------------
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
                color: isSelected ?AppColor.brandOrange : Colors.grey[100],
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

  // ---------------- DESCRIPTION ----------------
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
      String name, String price, String img, bool isSelected, bool isDark,
      {double rating = 4.5}) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 15, bottom: 5),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColor.accentGold : Colors.grey.shade200,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: AppColor.accentGold.withOpacity(0.1),
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
            const SizedBox(height: 4),

            // -------- Add rating stars here --------
            Row(
              children: List.generate(5, (index) {
                if (index < rating.floor()) {
                  return const Icon(Icons.star, color: Colors.amber, size: 14);
                } else if (index < rating) {
                  return const Icon(Icons.star_half, color: Colors.amber, size: 14);
                } else {
                  return const Icon(Icons.star_border, color: Colors.amber, size: 14);
                }
              }),
            ),
            const SizedBox(height: 6),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
              Icon(isSelected ? Icons.check_circle : Icons.add_circle,
                  color:AppColor.brandOrange, size: 20),
            ]),
          ]),
        ),
      ]),
    );
  }


  // ---------------- APPBAR ----------------
  AppBar _buildAppBar(bool isDark) {
    final Color contentColor = AppColor.lightGold;

    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: BrandGradient.luxury,
        ),
      ),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: contentColor, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Details".tr,
        style: TextStyle(
          color: contentColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: contentColor),
                onPressed: () => Navigator.pushNamed(context, 'cart'),
              ),
              if (widget.cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColor.brandOrange,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.primaryColor, width: 1.5),
                    ),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      '${widget.cartCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- HERO HEADER ----------------
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
                  color: _isLiked ? Colors.red : AppColor.brandOrange,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ---------------- BOTTOM ACTION SHEET ----------------
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
                    color: AppColor.brandOrange,
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
        color: AppColor.accentGold.withOpacity(0.1),
        border: Border.all(
          color: AppColor.accentGold.withOpacity(0.4),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(Icons.add_shopping_cart_outlined, color: AppColor.accentGold),
        onPressed: () {
          widget.onAddToCart(_createCartItem());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Added to cart!".tr,
                style: const TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColor.lightGold,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(milliseconds: 1500),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBuyNowButton() {
    return Container(
      height: 55,
      decoration: BoxDecoration(

        gradient: BrandGradient.goldMetallic,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColor.accentGold.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          final newItem = _createCartItem();
          widget.onAddToCart(newItem);
          Navigator.pop(context, "go_to_checkout");
        },
        icon: const Icon(
          Icons.shopping_cart_checkout,
          color: AppColor.primaryColor,
        ),
        label: Text(
          "Order Now".tr,
          style: const TextStyle(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
