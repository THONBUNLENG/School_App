class Food {
  final String name, des, img, category;
  final double price, rating;

  Food({
    required this.name,
    required this.des,
    required this.price,
    required this.img,
    required this.rating,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'des': des,
    'price': price,
    'img': img,
    'rating': rating,
    'category': category,
  };

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    name: json['name'] ?? '',
    des: json['des'] ?? '',
    price: (json['price'] as num).toDouble(),
    img: json['img'] ?? '',
    rating: (json['rating'] as num).toDouble(),
    category: json['category'] ?? '',
  );
}

class CartItem {
  final Food food;
  final String size;
  final int quantity;
  final List<Map<String, dynamic>> sides;
  final double finalTotalPrice;

  CartItem({
    required this.food,
    required this.size,
    required this.quantity,
    this.sides = const [],
    required this.finalTotalPrice,
  });

  CartItem copyWith({
    int? quantity,
    double? finalTotalPrice,
  }) {
    return CartItem(
      food: food,
      size: size,
      sides: sides,
      quantity: quantity ?? this.quantity,
      finalTotalPrice: finalTotalPrice ?? this.finalTotalPrice,
    );
  }

  Map<String, dynamic> toJson() => {
    'food': food.toJson(),
    'size': size,
    'quantity': quantity,
    'sides': sides,
    'finalTotalPrice': finalTotalPrice,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    food: Food.fromJson(json['food']),
    size: json['size'] ?? 'Regular',
    quantity: json['quantity'] ?? 1,
    sides: List<Map<String, dynamic>>.from(json['sides'] ?? []),
    finalTotalPrice: (json['finalTotalPrice'] as num).toDouble(),
  );
}
