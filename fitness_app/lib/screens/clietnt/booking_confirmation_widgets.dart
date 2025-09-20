import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/booking_model.dart' as booking_models;
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';

/// Виджеты для экрана подтверждения бронирования
class BookingConfirmationWidgets {
  
  /// Секция с информацией об отмене
  static Widget buildCancellationInfo() {
    return AppCard(
      padding: AppStyles.paddingLg,
      backgroundColor: AppColors.info.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.info,
            size: 20,
            color: AppColors.info,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Отмена бронирования возможна не менее чем за 2 часа до начала',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Секция выбора товаров
  static Widget buildProductsSelectionSection({
    required List<Product> productsToShow,
    required bool showAllProducts,
    required int availableProductsCount,
    required Function(bool) onToggleShowAll,
    required Function(Product, int) onUpdateProductQuantity,
    required Function(Product) onNavigateToProductDetail,
  }) {
    if (productsToShow.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок секции
        Row(
          children: [
            Text(
              'Дополнительные товары:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (!showAllProducts && availableProductsCount > 3)
              TextButton(
                onPressed: () => onToggleShowAll(true),
                child: Text(
                  'Показать все ($availableProductsCount)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            if (showAllProducts)
              TextButton(
                onPressed: () => onToggleShowAll(false),
                child: Text(
                  'Свернуть',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Список товаров
        ...productsToShow.map((product) => _buildProductItem(
          product,
          onUpdateProductQuantity,
          onNavigateToProductDetail,
        )).toList(),

        const SizedBox(height: 16),
      ],
    );
  }

  /// Элемент товара
  static Widget _buildProductItem(
    Product product,
    Function(Product, int) onUpdateProductQuantity,
    Function(Product) onNavigateToProductDetail,
  ) {
    return GestureDetector(
      onTap: () => onNavigateToProductDetail(product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: AppStyles.paddingMd,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppStyles.borderRadiusMd,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            // Иконка категории
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: product.categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                product.categoryIcon,
                size: 20,
                color: product.categoryColor,
              ),
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
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

            // Управление количеством
            ProductQuantitySelector(
              product: product,
              onUpdateQuantity: onUpdateProductQuantity,
            ),
          ],
        ),
      ),
    );
  }

  /// Секция выбранных товаров
  static Widget buildSelectedProductsSection(List<CartItem> selectedProducts) {
    final totalProductsPrice = selectedProducts.fold(
      0.0,
      (sum, item) => sum + item.totalPrice
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Выбранные товары:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        
        ...selectedProducts.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${item.product.name} × ${item.quantity}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                item.formattedTotalPrice,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        )).toList(),

        if (totalProductsPrice > 0) ...[
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Итого за товары:',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${totalProductsPrice.toInt()} ₽',
                style: AppTextStyles.price.copyWith(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
        
        const SizedBox(height: 16),
      ],
    );
  }

  /// Финальная стоимость с товарами
  static Widget buildFinalTotalPriceSection(double basePrice, List<CartItem> selectedProducts) {
    final totalProductsPrice = selectedProducts.fold(
      0.0,
      (sum, item) => sum + item.totalPrice
    );
    final totalPrice = basePrice + totalProductsPrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: AppStyles.borderRadiusLg,
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Итоговая стоимость:',
            style: AppTextStyles.headline6.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '${totalPrice.toInt()} ₽',
            style: AppTextStyles.price.copyWith(
              fontSize: 20,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Селектор количества товара
class ProductQuantitySelector extends StatefulWidget {
  final Product product;
  final Function(Product, int) onUpdateQuantity;

  const ProductQuantitySelector({
    super.key,
    required this.product,
    required this.onUpdateQuantity,
  });

  @override
  State<ProductQuantitySelector> createState() => _ProductQuantitySelectorState();
}

class _ProductQuantitySelectorState extends State<ProductQuantitySelector> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              setState(() {
                _quantity++;
              });
              widget.onUpdateQuantity(widget.product, _quantity);
            },
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(6),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        
        // Количество (только если > 0)
        if (_quantity > 0)
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
              _quantity.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        
        // Кнопка уменьшения (только если > 0)
        if (_quantity > 0)
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
              onPressed: () {
                setState(() {
                  _quantity--;
                });
                widget.onUpdateQuantity(widget.product, _quantity);
              },
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