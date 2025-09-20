import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../models/booking_model.dart' as booking_models;
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import '../../services/mock_data_service.dart';
import '../../services/notification_service.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import 'product_selection_screen.dart';
import 'booking_confirmation_widgets.dart';
import 'booking_confirmation_models.dart';


class BookingConfirmationScreen extends StatefulWidget {
  final BookingConfirmationConfig config;

  const BookingConfirmationScreen({super.key, required this.config});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final List<CartItem> _selectedProducts = [];
  bool _showAllProducts = false;
  bool _isProcessing = false;
  late List<Product> _availableProducts;

  @override
  void initState() {
    super.initState();
    // Получаем доступные товары в зависимости от типа бронирования
    _availableProducts = MockDataService.getProductsForBooking(
      _mapToBookingType(widget.config.type)
    );
    _sortProductsByCategory();
  }

  booking_models.BookingType _mapToBookingType(ConfirmationBookingType type) {
    return type.toBookingType();
  }

  void _sortProductsByCategory() {
    _availableProducts.sort((a, b) {
      final categoryPriority = {
        ProductCategory.fitness: 1,
        ProductCategory.drinks: 2,
        ProductCategory.accessories: 3,
        ProductCategory.tennis: 4,
        ProductCategory.other: 5,
      };
      
      final aPriority = categoryPriority[a.category] ?? 6;
      final bPriority = categoryPriority[b.category] ?? 6;
      
      return aPriority.compareTo(bPriority);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
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
            _buildBookingDetailsCard(config),

            const SizedBox(height: 24),

            // Секция с товарами (только для тренировок и групповых занятий)
            if (_shouldShowProductsSection(config.type))
              BookingConfirmationWidgets.buildProductsSelectionSection(
                productsToShow: productsToShow,
                showAllProducts: _showAllProducts,
                availableProductsCount: _availableProducts.length,
                onToggleShowAll: (showAll) {
                  setState(() {
                    _showAllProducts = showAll;
                  });
                },
                onUpdateProductQuantity: _updateProductQuantity,
                onNavigateToProductDetail: _navigateToProductDetail,
              ),

            // Отображение выбранных товаров
            if (_selectedProducts.isNotEmpty)
              BookingConfirmationWidgets.buildSelectedProductsSection(_selectedProducts),

            const SizedBox(height: 24),

            // Условия отмены
            BookingConfirmationWidgets.buildCancellationInfo(),

            const SizedBox(height: 32),

            // Итоговая стоимость
            BookingConfirmationWidgets.buildFinalTotalPriceSection(config.price, _selectedProducts),

            const SizedBox(height: 16),

            // Кнопка подтверждения
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: _getButtonText(config),
                onPressed: _confirmBooking,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetailsCard(BookingConfirmationConfig config) {
    return AppCard(
      padding: AppStyles.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок секции в зависимости от типа
          _buildSectionHeader(config),
          const SizedBox(height: 16),

          // Разделитель
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          // Детали записи
          ..._buildDetailRows(config),

          // Итоговая стоимость
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
                  '${config.price.toInt()} ₽',
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

  Widget _buildSectionHeader(BookingConfirmationConfig config) {
    switch (config.type) {
      case ConfirmationBookingType.personalTraining:
        return Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: config.trainer!.photoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        config.trainer!.photoUrl!,
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
                    config.trainer!.fullName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    config.trainer!.specialty,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      
      case ConfirmationBookingType.groupClass:
      case ConfirmationBookingType.scheduleClass:
        return Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: AppStyles.borderRadiusLg,
              ),
              child: Icon(
                _getClassIcon(config.groupClass!.type),
                size: 24,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.groupClass!.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${config.groupClass!.type} • ${config.groupClass!.level}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      
      case ConfirmationBookingType.tennisCourt:
        return Row(
          children: [
            Icon(
              Icons.sports_tennis,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.court!.number,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${config.court!.surfaceType} • ${config.court!.isIndoor ? 'Крытый' : 'Открытый'}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  List<Widget> _buildDetailRows(BookingConfirmationConfig config) {
    final rows = <Widget>[];

    switch (config.type) {
      case ConfirmationBookingType.personalTraining:
        rows.addAll([
          _buildDetailRow(
            icon: Icons.sports,
            title: 'Услуга',
            value: config.serviceName,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.calendar_today,
            title: 'Дата',
            value: DateFormatters.formatDate(config.date),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.access_time,
            title: 'Время',
            value: '${_formatTime(config.time!)} - ${_formatTime(TimeOfDay(hour: config.time!.hour + 1, minute: config.time!.minute))}',
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.timer,
            title: 'Длительность',
            value: '1 час',
          ),
        ]);
        break;

      case ConfirmationBookingType.groupClass:
      case ConfirmationBookingType.scheduleClass:
        rows.addAll([
          _buildDetailRow(
            icon: Icons.calendar_today,
            title: 'Дата',
            value: DateFormatters.formatDate(config.date),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.access_time,
            title: 'Время',
            value: '${DateFormatters.formatTime(config.startTime!)} - ${DateFormatters.formatTime(config.endTime!)}',
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.timer,
            title: 'Длительность',
            value: '${config.endTime!.difference(config.startTime!).inHours} ч',
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.location_on,
            title: 'Место',
            value: config.location!,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.person,
            title: 'Тренер',
            value: config.groupClass!.trainerName,
          ),
        ]);
        break;

      case ConfirmationBookingType.tennisCourt:
        rows.addAll([
          _buildDetailRow(
            icon: Icons.calendar_today,
            title: 'Дата',
            value: DateFormatters.formatDate(config.date),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.access_time,
            title: 'Время',
            value: '${DateFormatters.formatTime(config.startTime!)} - ${DateFormatters.formatTime(config.endTime!)}',
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.timer,
            title: 'Длительность',
            value: '${config.endTime!.difference(config.startTime!).inHours} ч',
          ),
          const SizedBox(height: 8),
          _buildTariffRow(config),
        ]);
        break;
    }

    return rows;
  }

  // Вспомогательные методы
  bool _shouldShowProductsSection(ConfirmationBookingType type) {
    return type.shouldShowProductsSection;
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

  Widget _buildTariffRow(BookingConfirmationConfig config) {
    final court = config.court!;
    final date = config.date;
    final startTime = TimeOfDay.fromDateTime(config.startTime!);
    
    return Row(
      children: [
        Icon(
          Icons.attach_money,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Тариф',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                court.getMultiTariffDescription(
                  DateTime(
                    date.year,
                    date.month,
                    date.day,
                    startTime.hour,
                    startTime.minute,
                  ),
                  DateTime(
                    date.year,
                    date.month,
                    date.day,
                    startTime.hour + 1,
                    startTime.minute,
                  ),
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getClassIcon(String type) {
    switch (type.toLowerCase()) {
      case 'йога':
        return Icons.self_improvement;
      case 'кардио':
        return Icons.directions_run;
      case 'пилатес':
        return Icons.fitness_center;
      case 'теннис':
        return Icons.sports_tennis;
      case 'массаж':
        return Icons.spa;
      case 'функциональный':
        return Icons.sports_gymnastics;
      default:
        return Icons.fitness_center;
    }
  }

  String _formatTime(TimeOfDay time) {
    final dateTime = DateTime(2024, 1, 1, time.hour, time.minute);
    return DateFormatters.formatTimeRussian(dateTime);
  }

  String _getButtonText(BookingConfirmationConfig config) {
    return config.type.getButtonText(config.price);
  }

  // Методы для работы с товарами
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

  void _navigateToProductDetail(Product product) {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('product_detail', {
      'productId': product.id,
    });
  }

  void _selectProducts() {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateToWithCallback('product_selection', {
      'bookingType': _mapToBookingType(widget.config.type),
      'onProductsSelected': (List<CartItem> products) {
        setState(() {
          _selectedProducts.clear();
          _selectedProducts.addAll(products);
        });
      },
    });
  }

  // Метод подтверждения бронирования
  void _confirmBooking() {
    final config = widget.config;
    
    setState(() {
      _isProcessing = true;
    });

    // Создаем бронирование с помощью extension метода
    final booking = config.toBooking(
      _selectedProducts,
      MockDataService.currentUser.id
    );

    // Добавляем в мок данные
    MockDataService.userBookings.add(booking);

    setState(() {
      _isProcessing = false;
    });

    // Показываем уведомление об успехе
    NotificationService.showSuccess(
      context,
      'Бронирование успешно создано!',
    );

    // Переходим на экран оплаты или домой
    final navigationService = NavigationService.of(context);
    if (booking.status == booking_models.BookingStatus.awaitingPayment) {
      navigationService?.navigateTo('payment', {
        'booking': booking,
        'amount': booking.totalPrice,
        'description': booking.title,
      });
    } else {
      navigationService?.navigateToHome();
    }
  }
}