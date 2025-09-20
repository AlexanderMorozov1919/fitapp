import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/mock_data_service.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = MockDataService.getProductById(productId);

    if (product == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Товар не найден',
            style: AppTextStyles.headline5,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final navigationService = NavigationService.of(context);
              navigationService?.onBack();
            },
          ),
        ),
        body: Center(
          child: Text(
            'Товар не найден',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          product.name,
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final navigationService = NavigationService.of(context);
            navigationService?.onBack();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение товара
            if (product.imageUrl != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: AppStyles.borderRadiusLg,
                  color: AppColors.background,
                ),
                child: ClipRRect(
                  borderRadius: AppStyles.borderRadiusLg,
                  child: Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: product.categoryColor.withOpacity(0.1),
                          borderRadius: AppStyles.borderRadiusLg,
                        ),
                        child: Icon(
                          product.categoryIcon,
                          size: 64,
                          color: product.categoryColor,
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: product.categoryColor.withOpacity(0.1),
                  borderRadius: AppStyles.borderRadiusLg,
                ),
                child: Icon(
                  product.categoryIcon,
                  size: 64,
                  color: product.categoryColor,
                ),
              ),

            const SizedBox(height: 24),

            // Заголовок и цена
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: AppTextStyles.headline4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  product.formattedPrice,
                  style: AppTextStyles.price.copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Категория
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: product.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    product.categoryIcon,
                    size: 16,
                    color: product.categoryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  product.categoryName,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Описание
            Text(
              'Описание',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Детали товара
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Детали товара',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    title: 'Цена',
                    value: product.formattedPrice,
                  ),
                  const SizedBox(height: 8),

                  _buildDetailRow(
                    title: 'Единица измерения',
                    value: product.unit,
                  ),
                  const SizedBox(height: 8),

                  _buildDetailRow(
                    title: 'Категория',
                    value: product.categoryName,
                  ),
                  const SizedBox(height: 8),

                  _buildDetailRow(
                    title: 'Доступность',
                    value: product.isAvailable ? 'В наличии' : 'Нет в наличии',
                    valueColor: product.isAvailable 
                        ? AppColors.success 
                        : AppColors.error,
                  ),
                  const SizedBox(height: 8),

                  if (product.stockQuantity < 50)
                    _buildDetailRow(
                      title: 'Остаток на складе',
                      value: '${product.stockQuantity} ${product.unit}',
                      valueColor: product.stockQuantity < 10 
                          ? AppColors.error 
                          : AppColors.warning,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}