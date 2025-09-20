import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../models/booking_model.dart';
import '../../models/payment_model.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import '../../services/mock_data_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';
import '../../utils/formatters.dart';
import 'product_selection_screen.dart';

class ClassConfirmationScreen extends StatefulWidget {
  final GroupClass selectedClass;

  const ClassConfirmationScreen({super.key, required this.selectedClass});

  @override
  State<ClassConfirmationScreen> createState() => _ClassConfirmationScreenState();
}

class _ClassConfirmationScreenState extends State<ClassConfirmationScreen> {
  bool _isProcessing = false;
  final List<CartItem> _selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    final classItem = widget.selectedClass;
    final user = MockDataService.currentUser;

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
      body: Padding(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка занятия
            Container(
              padding: AppStyles.paddingLg,
              decoration: AppStyles.elevatedCardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classItem.name,
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    '${classItem.type} • ${classItem.level}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Время и дата
                  _buildInfoRow(
                    Icons.access_time,
                    '${_formatTime(classItem.startTime)} - ${_formatTime(classItem.endTime)}',
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Дата
                  _buildInfoRow(
                    Icons.calendar_today,
                    _formatDate(classItem.startTime),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Тренер
                  _buildInfoRow(
                    Icons.person,
                    classItem.trainerName,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Локация
                  _buildInfoRow(
                    Icons.location_on,
                    classItem.location,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Статус
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: classItem.isFull ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                      borderRadius: AppStyles.borderRadiusSm,
                    ),
                    child: Text(
                      classItem.isFull ? 'Нет мест' : '${classItem.maxParticipants - classItem.currentParticipants} мест доступно',
                      style: AppTextStyles.caption.copyWith(
                        color: classItem.isFull ? AppColors.error : AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Информация о стоимости
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: AppStyles.borderRadiusLg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Стоимость:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    classItem.price > 0 ? '${classItem.price} ₽' : 'Бесплатно',
                    style: AppTextStyles.price.copyWith(
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Информация о включении в абонемент
            if (_isClassIncludedInMembership(user.membership, classItem))
              Container(
                padding: AppStyles.paddingMd,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: AppStyles.borderRadiusLg,
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Включено в ваш абонемент',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Кнопка выбора товаров
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _selectProducts,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppStyles.borderRadiusLg,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_basket,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Добавить товары к бронированию',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Отображение выбранных товаров
            if (_selectedProducts.isNotEmpty) _buildProductsSection(),

            const Spacer(),
            
            // Кнопка подтверждения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: classItem.isFull || _isProcessing ? null : _confirmBooking,
                style: AppStyles.primaryButtonStyle.copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return AppColors.textTertiary;
                    }
                    return AppColors.primary;
                  }),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        classItem.isFull ? 'Мест нет' : 'Подтвердить запись',
                        style: AppTextStyles.buttonMedium,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _confirmBooking() async {
    setState(() {
      _isProcessing = true;
    });

    // Имитация процесса бронирования
    await Future.delayed(const Duration(seconds: 1));

    // Создаем бронирование с товарами
    final booking = Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      type: BookingType.groupClass,
      startTime: widget.selectedClass.startTime,
      endTime: widget.selectedClass.endTime,
      title: widget.selectedClass.name,
      description: '${widget.selectedClass.type} • ${widget.selectedClass.level}',
      status: widget.selectedClass.price > 0 ? BookingStatus.awaitingPayment : BookingStatus.confirmed,
      price: widget.selectedClass.price,
      className: widget.selectedClass.name,
      createdAt: DateTime.now(),
      products: _selectedProducts,
    );

    // Добавляем в мок данные
    MockDataService.userBookings.add(booking);

    setState(() {
      _isProcessing = false;
    });

    // Показываем уведомление об успехе
    NotificationService.showSuccess(
      context,
      'Вы успешно записаны на занятие!',
    );

    // Переходим на экран оплаты
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('payment', {
      'booking': booking,
      'amount': booking.totalPrice,
      'description': 'Запись на занятие "${widget.selectedClass.name}"',
    });
  }

  String _formatTime(DateTime time) {
    return DateFormatters.formatTimeRussian(time);
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Сегодня';
    } else if (date.year == tomorrow.year &&
               date.month == tomorrow.month &&
               date.day == tomorrow.day) {
      return 'Завтра';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  bool _isClassIncludedInMembership(Membership? membership, GroupClass classItem) {
    if (membership == null || classItem.price > 0) return false;
    
    // Проверяем, включены ли групповые занятия в абонемент
    // Это упрощенная проверка - в реальном приложении нужно проверять тип абонемента
    return membership.includedServices.contains('group_classes') ||
           membership.type.toLowerCase().contains('full') ||
           membership.type.toLowerCase().contains('premium');
  }

  Widget _buildProductsSection() {
    final totalProductsPrice = _selectedProducts.fold(
      0.0,
      (sum, item) => sum + item.totalPrice
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  void _selectProducts() {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateToWithCallback('product_selection', {
      'bookingType': BookingType.groupClass,
      'onProductsSelected': (List<CartItem> products) {
        setState(() {
          _selectedProducts.clear();
          _selectedProducts.addAll(products);
        });
      },
    });
  }
}