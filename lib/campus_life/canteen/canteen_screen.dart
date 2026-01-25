
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/food.dart';
import 'list_food.dart';
import 'order.dart';

// ------------------- DETAIL SCREEN -------------------
class DetailScreen extends StatefulWidget {
  final Food food;
  final int cartCount;
  final Function(CartItem) onAddToCart;

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
  final Color brandOrange = const Color(0xFFD85D22);
  bool _isLiked = false;

  final List<Map<String, dynamic>> sideData = [
    {"name": "Fried plantain", "price": 3.75, "img": "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400", "isSelected": false},
    {"name": "Fried Chicken", "price": 2.50, "img": "https://images.unsplash.com/photo-1562967914-608f82629710?w=400", "isSelected": false},
    {"name": "Mashed Potatoes", "price": 2.00, "img": "https://images.unsplash.com/photo-1514326640560-7d063ef2aed5?w=400", "isSelected": false},
    {"name": "Garden Salad", "price": 2.25, "img": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400", "isSelected": false},
    {"name": "Spring Rolls", "price": 1.50, "img": "https://images.unsplash.com/photo-1606755456206-b25206cde27e?w=400", "isSelected": false},
    {"name": "Corn on the Cob", "price": 1.25, "img": "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400", "isSelected": false},
    {"name": "Potato Wedges", "price": 1.50, "img": "https://images.unsplash.com/photo-1585109649139-366815a0d713?w=400", "isSelected": false},
    {"name": "Chicken Wings", "price": 3.50, "img": "https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=400", "isSelected": false},
    {"name": "Nuggets", "price": 2.00, "img": "https://images.unsplash.com/photo-1562967914-608f82629710?w=400", "isSelected": false},
    {"name": "Cheese Toast", "price": 1.25, "img": "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400", "isSelected": false},
    {"name": "Hash Browns", "price": 1.50, "img": "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400", "isSelected": false},
    {"name": "Brownie", "price": 2.50, "img": "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400", "isSelected": false},
    {"name": "Ice Cream", "price": 2.00, "img": "https://images.unsplash.com/photo-1501443762994-82bd5dace89a?w=400", "isSelected": false},
    {"name": "Fruit Bowl", "price": 1.75, "img": "https://images.unsplash.com/photo-1519915028121-7d3463d20b13?w=400", "isSelected": false},
    {"name": "Soda", "price": 1.00, "img": "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500", "isSelected": false},
    {"name": "Vegetable Soup", "price": 2.00, "img": "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400", "isSelected": false},
  ];

  double get _totalSidesPrice {
    return sideData
        .where((side) => side['isSelected'] == true)
        .fold(0.0, (sum, side) => sum + (side['price'] as num).toDouble());
  }

  double get _finalTotalPrice {
    double basePrice = widget.food.price.toDouble();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildTitlePriceRow(),
                      const SizedBox(height: 24),
                      _buildSizeSelector(),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(),
                      const SizedBox(height: 28),
                      const Text("Recommended sides", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildSidesList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomActionSheet(),
        ],
      ),
    );
  }

  Widget _buildBottomActionSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Price", style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500)),
                Text("\$${_finalTotalPrice.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: brandOrange)),
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
      height: 55, width: 60,
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
              content: const Text("Added to cart!"),
              backgroundColor: brandOrange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 1000),
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
          List<Map<String, dynamic>> selectedSides = sideData
              .where((side) => side['isSelected'] == true)
              .toList();

          final newItem = CartItem(
            food: widget.food,
            size: _selectedSize,
            quantity: _quantity,
            sides: selectedSides,
            finalTotalPrice: _finalTotalPrice,
          );

          widget.onAddToCart(newItem);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderScreen(cartItems: [newItem]),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text("Order Now", style: TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(backgroundColor: brandOrange),
      ),
    );
  }

  Widget _buildSidesList() {
    return SizedBox(
      height: 195,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sideData.length,
        itemBuilder: (context, index) {
          final item = sideData[index];
          return GestureDetector(
            onTap: () => setState(() => item['isSelected'] = !item['isSelected']),
            child: _sideCard(item['name'], "\$${(item['price'] as double).toStringAsFixed(2)}", item['img'], item['isSelected']),
          );
        },
      ),
    );
  }

  Widget _sideCard(String name, String price, String img, bool isSelected) {
    return Container(
      width: 140, margin: const EdgeInsets.only(right: 15, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? brandOrange : Colors.grey.shade200, width: 2),
        boxShadow: isSelected ? [BoxShadow(color: brandOrange.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))] : [],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          child: Image.network(img, height: 90, width: double.infinity, fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(height: 90, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
          ),
        ),
        Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Icon(isSelected ? Icons.check_circle : Icons.add_circle, color: brandOrange, size: 20),
          ]),
        ])),
      ]),
    );
  }

  Widget _buildTitlePriceRow() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.food.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 4),
          Text("${widget.food.rating} (59 ratings)", style: const TextStyle(color: Colors.grey))
        ]),
        const SizedBox(height: 8),
        Text("\$${widget.food.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ])),
      _buildQuantityStepper(),
    ]);
  }

  Widget _buildQuantityStepper() {
    return Container(
      decoration: BoxDecoration(color: brandOrange, borderRadius: BorderRadius.circular(30)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: () { if (_quantity > 1) setState(() => _quantity--); }, icon: const Icon(Icons.remove, color: Colors.white)),
        Text('$_quantity', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add, color: Colors.white)),
      ]),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Details",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                onPressed: () {
                },
              ),

              if (widget.cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.orange,
                    child: Text(
                      widget.cartCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildHeroHeader() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10), height: 250, width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(alignment: Alignment.bottomRight, children: [
          Hero(tag: '${widget.food.name}-${widget.food.img}', child: ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.network(widget.food.img, height: 250, width: double.infinity, fit: BoxFit.cover))),
          Padding(padding: const EdgeInsets.all(15), child: GestureDetector(onTap: () => setState(() => _isLiked = !_isLiked), child: CircleAvatar(backgroundColor: Colors.white.withOpacity(0.9), child: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : brandOrange)))),
        ]),
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Select Size", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(children: ['Regular', 'Large'].map((size) {
        bool isSelected = _selectedSize == size;
        return GestureDetector(
          onTap: () => setState(() => _selectedSize = size),
          child: Container(
            margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(color: isSelected ? brandOrange : Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300)),
            child: Text(size, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
          ),
        );
      }).toList()),
    ]);
  }

  Widget _buildDescriptionSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text("${widget.food.des} (Each serving contains 248 calories)", style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87)),
    ]);
  }
}
// ------------------- MENU SCREEN -------------------
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}
class _MenuScreenState extends State<MenuScreen> {
  int selectedCategory = 0;
  List<CartItem> cartItems = [];
  String searchQuery = '';
  final List<String> categories = ["All", "Food", "Burgers", "Pizza", "Drinks", "Desserts"];
  late final List<Food> menuItems;

  @override
  void initState() {
    super.initState();
    // សន្មតថាអ្នកមាន function getMenuItems() រួចហើយ
    menuItems = getMenuItems();
  }

  double get cartTotal => cartItems.fold(0, (sum, item) => sum + item.finalTotalPrice);

  Future<void> _openCart() async {
    if (cartItems.isNotEmpty) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderScreen(cartItems: cartItems)),
      );
      setState(() {});
    }
  }

  void addToCart(CartItem newItem) {
    setState(() {
      final index = cartItems.indexWhere((existingItem) {
        bool isSameFood = existingItem.food.name == newItem.food.name;
        bool isSameSize = existingItem.size == newItem.size;
        return isSameFood && isSameSize;
      });

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

  @override
  Widget build(BuildContext context) {
    List<Food> filteredItems = menuItems.where((item) {
      final matchesCategory = selectedCategory == 0 || item.category == categories[selectedCategory];
      final matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryList(),
          const SizedBox(height: 10),
          _buildFoodGrid(filteredItems),
        ],
      ),
      bottomNavigationBar: cartItems.isEmpty ? null : _buildFloatingCartSummary(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Canteen Menu",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: _openCart,
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            ),
            if (cartItems.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: const Color(0xFFD85D22),
                  child: Text(
                    '${cartItems.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: TextField(
          onChanged: (value) => setState(() => searchQuery = value),
          decoration: const InputDecoration(
            hintText: "Search your favorite food...",
            prefixIcon: Icon(Icons.search, color: Color(0xFFD85D22)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
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
                color: isActive ? const Color(0xFFD85D22) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isActive ? Colors.transparent : Colors.grey.shade200),
              ),
              child: Center(child: Text(categories[index], style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold))),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodGrid(List<Food> items) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(food: item, cartCount: cartItems.length, onAddToCart: addToCart)));
              if (result == "go_to_checkout") _openCart();
            },
            child: _buildFoodCard(item),
          );
        },
      ),
    );
  }

  Widget _buildFoodCard(Food item) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                item.img, fit: BoxFit.cover, width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200, child: const Icon(Icons.broken_image, color: Colors.grey)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                Text("\$${item.price.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFD85D22), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCartSummary() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFF1F2937), borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${cartItems.length} items | \$${cartTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: _openCart, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD85D22)), child: const Text("View Cart")),
          ],
        ),
      ),
    );
  }
}
// ------------------- PAYMENT CONFIRMATION -------------------
class PaymentConfirmationScreen extends StatefulWidget {
  final List<dynamic> cartItems; // ប្តូរជា dynamic ឬ CartItem តាម model របស់អ្នក

  const PaymentConfirmationScreen({super.key, required this.cartItems});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool _isProcessing = false;
  bool _isSuccess = false;
  String _loadingMessage = "Processing your order..."; // បន្ថែមអថេរដែលខ្វះ
  final double deliveryFee = 2.00;

  // មុខងារចាត់ចែងការបង់ប្រាក់ និងផ្លាស់ប្តូរសារ Loading
  void _handlePayment() async {
    setState(() => _isProcessing = true);

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
    // គណនាSubtotal
    double subtotal = widget.cartItems.fold(
      0, (sum, item) => sum + item.finalTotalPrice,
    );

    // លក្ខខណ្ឌបង្ហាញ UI: បើជោគជ័យបង្ហាញ Success, បើកំពុងដើរបង្ហាញ Loading, បើធម្មតាបង្ហាញ Checkout
    if (_isSuccess) return _buildSuccessUI();
    if (_isProcessing) return _buildLoadingUI();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: _buildCheckoutUI(subtotal),
    );
  }

  // --- CHECKOUT UI ---
  Widget _buildCheckoutUI(double subtotal) {
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
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
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
                          Text(item.food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text("Size: ${item.size} • Qty: ${item.quantity}",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                    ),
                    Text("\$${item.finalTotalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              );
            },
          ),
        ),
        _buildPaymentSummary(subtotal),
      ],
    );
  }

  Widget _buildPaymentSummary(double subtotal) {
    double total = subtotal + deliveryFee;
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
          const SizedBox(height: 12),
          _summaryRow("Delivery Fee", "\$${deliveryFee.toStringAsFixed(2)}"),
          const Divider(height: 30, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("\$${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFD85D22))),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD85D22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Pay Now", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- LOADING UI ---
  Widget _buildLoadingUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: Image.network(
                'https://cdn.pixabay.com/animation/2025/11/11/02/19/02-19-36-889_512.gif',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _loadingMessage,
                key: ValueKey(_loadingMessage),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green.shade700),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 150,
              child: LinearProgressIndicator(backgroundColor: Color(0xFFE8F5E9), valueColor: AlwaysStoppedAnimation<Color>(Colors.green), minHeight: 6),
            ),
          ],
        ),
      ),
    );
  }

  // --- SUCCESS UI ---
  Widget _buildSuccessUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 20),
                  const Text("Order Placed Successfully!", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 10),
                  const Text("Your order is being processed. You'll get a notification when it's ready.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusStep("Placed", Icons.check_circle, true),
                      _buildStatusStep("Preparing", Icons.restaurant, false),
                      _buildStatusStep("Ready", Icons.shopping_bag, false),
                    ],
                  ),
                  const Divider(height: 40),
                  _buildDetailRow("Order Number", "#123456789"),
                  _buildDetailRow("Estimated Time", "12:30 PM"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("View Order Details", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                widget.cartItems.clear();

              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                side: const BorderSide(color: Colors.green, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Back to Home", style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ],
    );
  }

  Widget _buildStatusStep(String title, IconData icon, bool isDone) {
    return Column(
      children: [
        Icon(icon, color: isDone ? Colors.green : Colors.grey.shade300, size: 30),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 11, color: isDone ? Colors.black : Colors.grey)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }
}

