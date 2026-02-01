import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart';
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
    "All", "Food", "Popular", "Street Food", "Drinks", "Desserts","Coffee"
  ];
  late final List<Food> menuItems;

  @override
  void initState() {
    super.initState();
    menuItems = getMenuItems();
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
          finalTotalPrice: cartItems[index].finalTotalPrice + newItem.finalTotalPrice,
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
    final isDark = context.watch<ThemeManager>().isDarkMode;

    List<Food> filteredItems = menuItems.where((item) {
      final matchesCategory = selectedCategory == 0 ||
          item.category.toLowerCase() == categories[selectedCategory].toLowerCase();
      final matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: _buildAppBar(isDark),
      body: Column(
        children: [
          _buildSearchBar(isDark),
          _buildCategoryList(isDark),
          const SizedBox(height: 10),
          Expanded(
            child: filteredItems.isEmpty
                ? Center(child: Text("No items found".tr, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey)))
                : _buildFoodGrid(filteredItems, isDark),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: cartItems.isEmpty ? null : _buildFloatingCartSummary(isDark),
    );
  }

  AppBar _buildAppBar(bool isDark) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: BrandGradient.luxury),
      ),
      title: Text(
        "Canteen Menu".tr,
        style: const TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: _openCart,
          icon: Badge(
            backgroundColor: AppColor.brandOrange,
            label: Text('${cartItems.length}', style: const TextStyle(color: Colors.white)),
            isLabelVisible: cartItems.isNotEmpty,
            child: const Icon(Icons.shopping_bag_outlined, color: AppColor.lightGold),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: "Search food...".tr,
          prefixIcon: const Icon(Icons.search, color: AppColor.accentGold),
          filled: true,
          fillColor: isDark ? AppColor.surfaceColor : Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColor.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColor.glassBorder),
          ),
        ),
        style: TextStyle(color: isDark ? Colors.white : AppColor.primaryColor),
      ),
    );
  }

  Widget _buildCategoryList(bool isDark) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isActive = selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12, top: 5, bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: isActive ? BrandGradient.goldMetallic : null,
                color: isActive ? null : (isDark ? AppColor.surfaceColor : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isActive ? Colors.transparent : AppColor.glassBorder),
                boxShadow: isActive ? [BoxShadow(color: AppColor.accentGold.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
              ),
              child: Center(
                child: Text(
                  categories[index].tr,
                  style: TextStyle(
                    color: isActive ? AppColor.primaryColor : (isDark ? Colors.white70 : Colors.grey.shade600),
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
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildFoodCard(items[index], isDark),
    );
  }

  Widget _buildFoodCard(Food item, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(food: item, cartCount: cartItems.length, onAddToCart: addToCart),
          ),
        );
        if (result == "go_to_checkout") _openCart();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.glassBorder),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Hero(
                  tag: '${item.name}-${item.img}',
                  child: Image.network(item.img, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColor.primaryColor), maxLines: 1),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\¥${item.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w900)),
                      const Icon(Icons.add_circle, color: AppColor.accentGold, size: 22),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCartSummary(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      decoration: BoxDecoration(
        gradient: BrandGradient.luxury,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColor.primaryColor.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openCart,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_bag, color: AppColor.lightGold),
                    const SizedBox(width: 10),
                    Text(
                      "${cartItems.length} items  |  \¥${cartTotal.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text("View Cart", style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward_ios, color: AppColor.lightGold, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
