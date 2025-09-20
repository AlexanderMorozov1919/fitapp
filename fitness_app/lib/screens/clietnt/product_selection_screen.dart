import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/booking_model.dart';
import '../../services/mock_data_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';

class ProductSelectionScreen extends StatefulWidget {
  final BookingType bookingType;
  final Function(List<CartItem>) onProductsSelected;

  const ProductSelectionScreen({
    super.key,
    required this.bookingType,
    required this.onProductsSelected,
  });

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  final Map<String, int> _selectedProducts = {};

  @override
  void initState() {
    super.initState();
    // Загружаем текущие товары из корзины
    for (final item in MockDataService.getCartItems()) {
      _selectedProducts[item.product.id] = item.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = MockDataService.getProductsForBooking(widget.bookingType);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Дополнительные товары',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Возвращаем текущие выбранные товары при нажатии назад
            final cartItems = MockDataService.getCartItems();
            widget.onProductsSelected(cartItems);
            final navigationService = NavigationService.of(context);
            navigationService?.onBack();
          },
        ),
        actions: [
          if (_selectedProducts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.shopping_cart_checkout),
              onPressed: _saveAndContinue,
              tooltip: 'Сохранить и продолжить',
            ),
        ],
      ),
      body: Column(
        children: [
          // Заголовок с информацией
          Container(
            padding: AppStyles.paddingLg,
            color: AppColors.primary.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_basket,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Выберите дополнительные товары для вашего бронирования',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Список товаров
          Expanded(
            child: ListView.builder(
              padding: AppStyles.paddingLg,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final quantity = _selectedProducts[product.id] ?? 0;

                return _buildProductCard(product, quantity);
              },
            ),
          ),

          // Итоговая панель
          if (_selectedProducts.isNotEmpty) _buildSummaryPanel(),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, int quantity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppStyles.elevatedCardDecoration,
      child: Column(
        children: [
          // Изображение и основная информация
          Padding(
            padding: AppStyles.paddingLg,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Изображение товара
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppStyles.borderRadiusMd,
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
                          size: 32,
                          color: product.categoryColor,
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                // Информация о товаре
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: product.categoryColor.withOpacity(0.1),
                              borderRadius: AppStyles.borderRadiusSm,
                            ),
                            child: Text(
                              product.categoryName,
                              style: AppTextStyles.caption.copyWith(
                                color: product.categoryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            product.formattedPrice,
                            style: AppTextStyles.price.copyWith(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Управление количеством
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Кнопка уменьшения
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: 20,
                    color: quantity > 0 ? AppColors.primary : AppColors.textTertiary,
                  ),
                  onPressed: quantity > 0
                      ? () => _updateQuantity(product.id, quantity - 1)
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: quantity > 0
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppStyles.borderRadiusSm,
                    ),
                  ),
                ),

                // Количество
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    quantity.toString(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Кнопка увеличения
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: () => _updateQuantity(product.id, quantity + 1),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppStyles.borderRadiusSm,
                    ),
                  ),
                ),

                const Spacer(),

                // Итоговая стоимость
                if (quantity > 0)
                  Text(
                    '${(product.price * quantity).toInt()} ₽',
                    style: AppTextStyles.price.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPanel() {
    final totalItems = _selectedProducts.values.fold(0, (sum, qty) => sum + qty);
    final totalPrice = _selectedProducts.entries.fold(0.0, (sum, entry) {
      final product = MockDataService.getProductById(entry.key);
      return sum + (product?.price ?? 0) * entry.value;
    });

    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$totalItems товар(ов)',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${totalPrice.toInt()} ₽',
                style: AppTextStyles.price.copyWith(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Сохранить',
            onPressed: _saveAndContinue,
            width: 120,
          ),
        ],
      ),
    );
  }

  void _updateQuantity(String productId, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _selectedProducts.remove(productId);
      } else {
        _selectedProducts[productId] = newQuantity;
      }
    });
  }

  void _saveAndContinue() {
    // Очищаем корзину
    MockDataService.clearCart();

    // Добавляем выбранные товары в корзину
    for (final entry in _selectedProducts.entries) {
      final product = MockDataService.getProductById(entry.key);
      if (product != null) {
        MockDataService.addToCart(product, entry.value);
      }
    }

    // Создаем список товаров для передачи обратно
    final cartItems = MockDataService.getCartItems();

    // Вызываем callback с выбранными товарами
    widget.onProductsSelected(cartItems);

    // Возвращаемся назад через кастомную навигацию
    final navigationService = NavigationService.of(context);
    navigationService?.onBack();
  }
}