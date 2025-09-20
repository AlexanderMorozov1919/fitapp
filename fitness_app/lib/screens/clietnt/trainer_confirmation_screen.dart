import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../models/booking_model.dart';
import '../../models/product_model.dart';
import '../../services/mock_data_service.dart';
import '../../services/notification_service.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';

class TrainerConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const TrainerConfirmationScreen({super.key, required this.bookingData});

  @override
  State<TrainerConfirmationScreen> createState() => _TrainerConfirmationScreenState();
}

class _TrainerConfirmationScreenState extends State<TrainerConfirmationScreen> {
  final List<CartItem> _selectedProducts = [];
  bool _showAllProducts = false;
  late List<Product> _availableProducts;
  
  @override
  void initState() {
    super.initState();
    // Получаем доступные товары для персональных тренировок
    _availableProducts = MockDataService.getProductsForBooking(BookingType.personalTraining);
    // Перемешиваем товары для случайного порядка
    _availableProducts.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final trainer = widget.bookingData['trainer'] as Trainer;
    final serviceName = widget.bookingData['serviceName'] as String;
    final price = widget.bookingData['price'] as double;
    final date = widget.bookingData['date'] as DateTime;
    final time = widget.bookingData['time'] as TimeOfDay;

    // Получаем товары для отображения (первые 3 или все)
    final productsToShow = _showAllProducts
        ? _availableProducts
        : _availableProducts.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Подтверждение записи',
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
            // Заголовок
            Text(
              'Проверьте детали записи:',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Карточка с информацией о записи
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Информация о тренере
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: trainer.photoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                  trainer.photoUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 24,
                                color: AppColors.textTertiary,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trainer.fullName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              trainer.specialty,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Разделитель
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),

                  // Детали записи
                  _buildDetailRow(
                    icon: Icons.sports,
                    title: 'Услуга',
                    value: serviceName,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    title: 'Дата',
                    value: DateFormatters.formatDate(date),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.access_time,
                    title: 'Время',
                    value: '${_formatTime(time)} - ${_formatTime(TimeOfDay(hour: time.hour + 1, minute: time.minute))}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.timer,
                    title: 'Длительность',
                    value: '1 час',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.attach_money,
                    title: 'Стоимость часа',
                    value: '${price.toInt()} ₽/час',
                  ),
                  
                  // Стоимость бронирования
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: AppStyles.borderRadiusMd,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Стоимость бронирования:',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${price.toInt()} ₽',
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
            ),

            const SizedBox(height: 24),

            // Секция с товарами
            _buildProductsSelectionSection(productsToShow),

            // Отображение выбранных товаров
            if (_selectedProducts.isNotEmpty) _buildSelectedProductsSection(),

            const SizedBox(height: 24),

            // Условия отмены
            AppCard(
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
                      'Отмена тренировки возможна не менее чем за 2 часа до начала',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Итоговая стоимость перед кнопкой оплаты
            _buildFinalTotalPriceSection(price),
            const SizedBox(height: 16),

            // Кнопка оплаты
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Подтвердить и оплатить',
                onPressed: _proceedToPayment,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
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
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final dateTime = DateTime(2024, 1, 1, time.hour, time.minute);
    return DateFormatters.formatTimeRussian(dateTime);
  }

  Widget _buildProductsSelectionSection(List<Product> productsToShow) {
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
            if (!_showAllProducts && _availableProducts.length > 3)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllProducts = true;
                  });
                },
                child: Text(
                  'Показать все (${_availableProducts.length})',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            if (_showAllProducts)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllProducts = false;
                  });
                },
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
        ...productsToShow.map((product) => _buildProductItem(product)).toList(),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProductItem(Product product) {
    final currentQuantity = _selectedProducts
        .where((item) => item.product.id == product.id)
        .fold(0, (sum, item) => sum + item.quantity);

    return Container(
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

          // Управление количеством - вертикальный стек
          Column(
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
                  icon: Icon(Icons.add, size: 18),
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
                    icon: Icon(Icons.remove, size: 18),
                    onPressed: () => _updateProductQuantity(product, currentQuantity - 1),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProductsSection() {
    final totalProductsPrice = _selectedProducts.fold(
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
        
        ..._selectedProducts.map((item) => Padding(
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


  Widget _buildFinalTotalPriceSection(double basePrice) {
    final totalProductsPrice = _selectedProducts.fold(
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

  void _updateProductQuantity(Product product, int newQuantity) {
    setState(() {
      // Удаляем товар из списка, если количество 0
      if (newQuantity <= 0) {
        _selectedProducts.removeWhere((item) => item.product.id == product.id);
        return;
      }

      // Ищем существующий товар
      final existingItemIndex = _selectedProducts.indexWhere(
        (item) => item.product.id == product.id
      );

      if (existingItemIndex != -1) {
        // Обновляем количество существующего товара
        _selectedProducts[existingItemIndex] = _selectedProducts[existingItemIndex].copyWith(
          quantity: newQuantity
        );
      } else {
        // Добавляем новый товар
        _selectedProducts.add(CartItem(
          product: product,
          quantity: newQuantity,
        ));
      }
    });
  }

  void _proceedToPayment() {
    final trainer = widget.bookingData['trainer'] as Trainer;
    final serviceName = widget.bookingData['serviceName'] as String;
    final price = widget.bookingData['price'] as double;
    final date = widget.bookingData['date'] as DateTime;
    final time = widget.bookingData['time'] as TimeOfDay;

    final startDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final endDateTime = startDateTime.add(const Duration(hours: 1));

    final totalProductsPrice = _selectedProducts.fold(
      0.0,
      (sum, item) => sum + item.totalPrice
    );
    
    final booking = Booking(
      id: 'training_${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      type: BookingType.personalTraining,
      startTime: startDateTime,
      endTime: endDateTime,
      title: '$serviceName с ${trainer.fullName}',
      description: 'Персональная тренировка',
      status: BookingStatus.awaitingPayment,
      price: price + totalProductsPrice,
      trainerId: trainer.id,
      createdAt: DateTime.now(),
      products: _selectedProducts,
    );

    // Добавляем в мок данные
    MockDataService.userBookings.add(booking);

    // Показываем уведомление об успехе
    NotificationService.showSuccess(
      context,
      'Тренировка успешно забронирована!',
    );

    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('payment', {
      'booking': booking,
      'amount': price + totalProductsPrice,
      'description': '$serviceName с ${trainer.fullName}',
    });
  }
}