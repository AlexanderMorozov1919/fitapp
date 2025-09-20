import 'package:flutter/material.dart';

enum ProductCategory {
  tennis,
  fitness,
  drinks,
  accessories,
  other,
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final ProductCategory category;
  final String? imageUrl;
  final bool isAvailable;
  final int stockQuantity;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    this.isAvailable = true,
    this.stockQuantity = 100,
    this.unit = 'шт.',
  });

  String get categoryName {
    switch (category) {
      case ProductCategory.tennis:
        return 'Теннис';
      case ProductCategory.fitness:
        return 'Фитнес';
      case ProductCategory.drinks:
        return 'Напитки';
      case ProductCategory.accessories:
        return 'Аксессуары';
      case ProductCategory.other:
        return 'Другое';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case ProductCategory.tennis:
        return Icons.sports_tennis;
      case ProductCategory.fitness:
        return Icons.fitness_center;
      case ProductCategory.drinks:
        return Icons.local_drink;
      case ProductCategory.accessories:
        return Icons.shopping_bag;
      case ProductCategory.other:
        return Icons.category;
    }
  }

  Color get categoryColor {
    switch (category) {
      case ProductCategory.tennis:
        return Colors.green;
      case ProductCategory.fitness:
        return Colors.blue;
      case ProductCategory.drinks:
        return Colors.orange;
      case ProductCategory.accessories:
        return Colors.purple;
      case ProductCategory.other:
        return Colors.grey;
    }
  }

  String get formattedPrice => '${price.toInt()} ₽';

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    ProductCategory? category,
    String? imageUrl,
    bool? isAvailable,
    int? stockQuantity,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
    );
  }
}

class CartItem {
  final Product product;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.product,
    required this.quantity,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  double get totalPrice => product.price * quantity;

  String get formattedTotalPrice => '${totalPrice.toInt()} ₽';

  CartItem copyWith({
    Product? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

class ShoppingCart {
  final List<CartItem> items;
  final DateTime createdAt;

  ShoppingCart({
    List<CartItem>? items,
    DateTime? createdAt,
  })  : items = items ?? [],
        createdAt = createdAt ?? DateTime.now();

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  String get formattedTotalPrice => '${totalPrice.toInt()} ₽';

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  void addItem(Product product, [int quantity = 1]) {
    final existingItemIndex = items.indexWhere((item) => item.product.id == product.id);
    
    if (existingItemIndex != -1) {
      items[existingItemIndex].quantity += quantity;
    } else {
      items.add(CartItem(product: product, quantity: quantity));
    }
  }

  void removeItem(String productId, [int quantity = 1]) {
    final existingItemIndex = items.indexWhere((item) => item.product.id == productId);
    
    if (existingItemIndex != -1) {
      if (items[existingItemIndex].quantity <= quantity) {
        items.removeAt(existingItemIndex);
      } else {
        items[existingItemIndex].quantity -= quantity;
      }
    }
  }

  void updateItemQuantity(String productId, int newQuantity) {
    final existingItemIndex = items.indexWhere((item) => item.product.id == productId);
    
    if (existingItemIndex != -1) {
      if (newQuantity <= 0) {
        items.removeAt(existingItemIndex);
      } else {
        items[existingItemIndex].quantity = newQuantity;
      }
    }
  }

  void clear() {
    items.clear();
  }

  bool containsProduct(String productId) {
    return items.any((item) => item.product.id == productId);
  }

  int getProductQuantity(String productId) {
    final item = items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: Product(id: '', name: '', description: '', price: 0, category: ProductCategory.other), quantity: 0),
    );
    return item.quantity;
  }

  ShoppingCart copyWith({
    List<CartItem>? items,
    DateTime? createdAt,
  }) {
    return ShoppingCart(
      items: items ?? this.items.map((item) => item.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}