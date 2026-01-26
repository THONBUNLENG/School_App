import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extension/change_notifier.dart';
import '../../extension/string_extension.dart';
import '../../model/food.dart';
import 'list_food.dart';
import 'order.dart';
import 'detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedCategory = 0;
  List<CartItem> cartItems = [];
  String searchQuery = '';

  final List<String> categories = [
    "All",
    "Food",
    "Popular Food Drink",
    "Street Food",
    "Drinks",
    "Desserts"
  ];
  late final List<Food> menuItems;

  @override
  void initState() {
    super.initState();
    menuItems = getMenuItems(); // Make sure this returns your Food list
  }

  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + item.finalTotalPrice);

  void addToCart(CartItem newItem) {
    setState(() {
      final index = cartItems.indexWhere(
            (existingItem) =>
        existingItem.food.name == newItem.food.name &&
            existingItem.size == newItem.size,
      );

      if (index != -1) {
        cartItems[index] = cartItems[index].copyWith(
          quantity: cartItems[index].quantity + newItem.quantity,
          finalTotalPrice:
          cartItems[index].finalTotalPrice + newItem.finalTotalPrice,
        );
      } else {
        cartItems.add(newItem);
      }
    });
  }

  Future<void> _openCart() async {
    if (cartItems.isNotEmpty) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderScreen(cartItems: cartItems),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();
    final isDark = themeManager.isDarkMode;

    // Filter items
    List<Food> filteredItems = menuItems.where((item) {
      final matchesCategory = selectedCategory == 0 ||
          item.category.toLowerCase() ==
              categories[selectedCategory].toLowerCase();
      final matchesSearch =
      item.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFFBFBFB),
      appBar: _buildAppBar(isDark),
      body: Column(
        children: [
          _buildSearchBar(isDark),
          _buildCategoryList(isDark),
          const SizedBox(height: 10),
          filteredItems.isEmpty
              ? Expanded(
            child: Center(
              child: Text(
                "No items found".tr,
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          )
              : _buildFoodGrid(filteredItems, isDark),
        ],
      ),
      bottomNavigationBar:
      cartItems.isEmpty ? null : _buildFloatingCartSummary(isDark),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Canteen Menu".tr,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _openCart,
          icon: Badge(
            label: Text('${cartItems.length}'),
            isLabelVisible: cartItems.isNotEmpty,
            child: Icon(Icons.shopping_cart_outlined,
                color: isDark ? Colors.white : Colors.black),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: "Search food...".tr,
          prefixIcon: Icon(Icons.search, color: const Color(0xFFD85D22)),
          filled: true,
          fillColor: isDark ? Colors.grey[800] : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildCategoryList(bool isDark) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isActive = selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = index),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFD85D22)
                    : (isDark ? Colors.grey[800] : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? Colors.transparent : Colors.grey.shade200,
                ),
              ),
              child: Center(
                child: Text(
                  categories[index].tr,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : (isDark ? Colors.grey[400] : Colors.grey.shade600),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodGrid(List<Food> items, bool isDark) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    food: item,
                    cartCount: cartItems.length,
                    onAddToCart: addToCart,
                  ),
                ),
              );

              if (result == "go_to_checkout") _openCart();
            },
            child: _buildFoodCard(item, isDark),
          );
        },
      ),
    );
  }

  Widget _buildFoodCard(Food item, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                item.img,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  "\¥${item.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Color(0xFFD85D22), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCartSummary(bool isDark) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${cartItems.length} items | \¥${cartTotal.toStringAsFixed(2)}",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _openCart,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD85D22)),
              child: Text("View Cart".tr),
            ),
          ],
        ),
      ),
    );
  }
}
