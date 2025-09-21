import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../services/mock_data_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';
import 'payment_screen.dart';
import 'purchase_history_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<CartItem> _cartItems = [];
  bool _showAllProducts = false;
  late List<Product> _availableProducts;
  ProductCategory? _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _availableProducts = MockDataService.allProducts;
    _sortProductsByCategory();
  }

  void _sortProductsByCategory() {
    _availableProducts.sort((a, b) {
      final categoryOrder = {
        ProductCategory.tennis: 1,
        ProductCategory.fitness: 2,
        ProductCategory.drinks: 3,
        ProductCategory.accessories: 4,
        ProductCategory.other: 5,
      };
      return (categoryOrder[a.category] ?? 6).compareTo(categoryOrder[b.category] ?? 6);
    });
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == null) {
      return _availableProducts;
    }
    return _availableProducts.where((product) => product.category == _selectedCategory).toList();
  }

  List<ProductCategory> get _availableCategories {
    final categories = _availableProducts.map((p) => p.category).toSet().toList();
    categories.sort((a, b) => a.index.compareTo(b.index));
    return categories;
  }

  void _updateProductQuantity(Product product, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _cartItems.removeWhere((item) => item.product.id == product.id);
        return;
      }

      final existingItemIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
      if (existingItemIndex != -1) {
        _cartItems[existingItemIndex] = _cartItems[existingItemIndex].copyWith(quantity: newQuantity);
      } else {
        _cartItems.add(CartItem(product: product, quantity: newQuantity));
      }
    });
  }

  double get _totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void _proceedToPayment() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте товары в корзину')),
      );
      return;
    }

    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('payment', {
      'amount': _totalPrice,
      'description': 'Покупка товаров в магазине',
      'onPaymentSuccess': () {
        // Сохраняем покупку в историю
        MockDataService.addPurchase(_cartItems, _totalPrice, paymentMethod: 'Карта');
        
        // Очищаем корзину после успешной оплаты
        setState(() {
          _cartItems.clear();
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Покупка успешно оплачена!')),
        );
      },
    });
  }

  void _navigateToPurchaseHistory() {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('purchase_history', {});
  }

  void _navigateToProductDetail(Product product) {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('product_detail', {'productId': product.id});
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts;
    final productsToShow = _showAllProducts
        ? filteredProducts
        : filteredProducts.take(12).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Магазин'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _navigateToPurchaseHistory,
            tooltip: 'История покупок',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                // Фильтры по категориям
                if (_availableCategories.length > 1)
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        // Кнопка "Все товары"
                        FilterChipWidget(
                          label: 'Все товары',
                          isSelected: _selectedCategory == null,
                          onTap: () {
                            setState(() {
                              _selectedCategory = null;
                              _scrollController.jumpTo(0);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ..._availableCategories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChipWidget(
                              label: category.categoryName,
                              isSelected: _selectedCategory == category,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                  _scrollController.jumpTo(0);
                                });
                              },
                              selectedColor: category.categoryColor,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: AppStyles.paddingLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок
                        Text(
                          _selectedCategory == null
                            ? 'Все товары'
                            : _selectedCategory!.categoryName,
                          style: AppTextStyles.headline6.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Список товаров
                        if (filteredProducts.isEmpty)
                          Center(
                            child: Text(
                              'Товары не найдены',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        else
                          ...productsToShow.map((product) => _buildProductItem(product)).toList(),

                        // Кнопка показать все/свернуть
                        if (filteredProducts.length > 12)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _showAllProducts = !_showAllProducts;
                                });
                              },
                              child: Text(
                                _showAllProducts ? 'Свернуть' : 'Показать все товары',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 80), // Отступ для плавающей кнопки
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Плавающая панель с корзиной
          if (_cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border, width: 1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Корзина',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_cartItems.length} товар(ов)',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${_totalPrice.toInt()} ₽',
                    style: AppTextStyles.price.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  PrimaryButton(
                    text: 'К оплате',
                    onPressed: _proceedToPayment,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    final currentQuantity = _cartItems
        .firstWhere(
          (item) => item.product.id == product.id,
          orElse: () => CartItem(product: product, quantity: 0),
        )
        .quantity;

    return GestureDetector(
      onTap: () => _navigateToProductDetail(product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: AppStyles.paddingMd,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppStyles.borderRadiusMd,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
          // Изображение товара
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: product.categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              image: product.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(product.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: product.imageUrl == null
                ? Icon(
                    product.categoryIcon,
                    size: 24,
                    color: product.categoryColor,
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // Информация о товаре
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.formattedPrice} / ${product.unit}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Селектор количества
          _buildQuantitySelector(product, currentQuantity),
        ],
      ),
      ),
    );
  }

  Widget _buildQuantitySelector(Product product, int currentQuantity) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Кнопка увеличения
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => _updateProductQuantity(product, currentQuantity + 1),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(6),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        
        // Количество (только если > 0)
        if (currentQuantity > 0)
          Container(
            width: 36,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              currentQuantity.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        
        // Кнопка уменьшения (только если > 0)
        if (currentQuantity > 0)
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.remove, size: 18),
              onPressed: () => _updateProductQuantity(product, currentQuantity - 1),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(6),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
      ],
    );
  }
}