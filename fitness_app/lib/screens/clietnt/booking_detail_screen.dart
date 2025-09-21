import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import 'cancel_booking_modal.dart' as cancel_booking_modal;
import 'reschedule_booking_modal.dart' as reschedule_booking_modal;
import '../../models/product_model.dart';
import '../../widgets/products_section_widget.dart';
import 'booking_payment_info.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Детали бронирования',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final navigationService = NavigationService.of(context);
            if (navigationService != null) {
              navigationService.onBack();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка с основной информацией
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок и статус
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          booking.title,
                          style: AppTextStyles.headline6.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(
                        text: booking.statusText,
                        color: booking.statusColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Иконка и тип бронирования
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: booking.statusColor.withOpacity(0.1),
                          borderRadius: AppStyles.borderRadiusLg,
                        ),
                        child: Icon(
                          _getBookingIcon(booking),
                          size: 24,
                          color: booking.statusColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getBookingTypeText(booking.type),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (booking.description != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                booking.description!,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Разделитель
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),

                  // Детали времени
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    title: 'Дата',
                    value: DateFormatters.formatDate(booking.startTime),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.access_time,
                    title: 'Время',
                    value: '${DateFormatters.formatTime(booking.startTime)} - ${DateFormatters.formatTime(booking.endTime)}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.timer,
                    title: 'Длительность',
                    value: '${booking.endTime.difference(booking.startTime).inHours} ч',
                  ),

                  // Дополнительные детали в зависимости от типа бронирования
                  if (booking.courtNumber != null) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      icon: Icons.sports_tennis,
                      title: 'Корт',
                      value: booking.courtNumber!,
                    ),
                  ],
                  if (booking.trainerId != null) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      icon: Icons.person,
                      title: 'Тренер',
                      value: booking.trainerId!,
                    ),
                  ],
                  if (booking.className != null) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      icon: Icons.group,
                      title: 'Занятие',
                      value: booking.className!,
                    ),
                  ],
                  if (booking.lockerNumber != null) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      icon: Icons.lock,
                      title: 'Шкафчик',
                      value: booking.lockerNumber!,
                    ),
                  ],

                  // Стоимость
                  if (booking.price > 0) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      icon: Icons.attach_money,
                      title: 'Стоимость',
                      value: '${booking.price.toInt()} ₽',
                      valueStyle: AppTextStyles.price.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Кнопки действий
            if (booking.status == BookingStatus.confirmed && booking.canCancel) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SecondaryButton(
                      text: 'Отменить бронирование',
                      onPressed: _showCancelDialog,
                      color: AppColors.error,
                    ),
                  ),
                  if (booking.type == BookingType.tennisCourt ||
                      booking.type == BookingType.personalTraining) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Изменить время',
                        onPressed: _showRescheduleDialog,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
            ] else if (booking.status == BookingStatus.awaitingPayment && booking.price > 0) ...[
              // Кнопка оплаты для бронирований, ожидающих оплаты (только для обычной оплаты)
              if (!booking.hasPaymentDifference || !booking.requiresAdditionalPayment) ...[
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Оплатить ${booking.price.toInt()} ₽',
                    onPressed: _proceedToPayment,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],

            // Информация о доплате/возврате
            if (booking.hasPaymentDifference) ...[
              const SizedBox(height: 16),
              BookingPaymentInfo(
                booking: booking,
                onPayDifference: _payDifference,
                showPayButton: booking.requiresAdditionalPayment, // Показываем кнопку только для доплаты
              ),
            ],

            // Секция товаров
            ProductsSectionWidget(products: booking.products),

            // Информация о создании
            Text(
              'Бронирование создано: ${DateFormatters.formatDateTime(booking.createdAt)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
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
    TextStyle? valueStyle,
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
          style: valueStyle ?? AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  IconData _getBookingIcon(Booking booking) {
    switch (booking.type) {
      case BookingType.tennisCourt:
        return Icons.sports_tennis;
      case BookingType.groupClass:
        return Icons.group;
      case BookingType.personalTraining:
        return Icons.person;
      case BookingType.locker:
        return Icons.lock;
      default:
        return Icons.calendar_today;
    }
  }

  String _getBookingTypeText(BookingType type) {
    switch (type) {
      case BookingType.tennisCourt:
        return 'Теннисный корт';
      case BookingType.groupClass:
        return 'Групповое занятие';
      case BookingType.personalTraining:
        return 'Персональная тренировка';
      case BookingType.locker:
        return 'Аренда шкафчика';
      default:
        return 'Бронирование';
    }
  }

  void _showCancelDialog() {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('cancel_booking', widget.booking);
    } else {
      // Просто показываем сообщение, так как модальные окна требуют callback функции
      showSuccessSnackBar(context, 'Функционал отмены бронирования доступен через быстрый доступ');
    }
  }

  void _showRescheduleDialog() {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('reschedule_booking', widget.booking);
    } else {
      // Просто показываем сообщение, так как модальные окна требуют callback функции
      showSuccessSnackBar(context, 'Функционал изменения времени доступен через быстрый доступ');
    }
  }


  void _proceedToPayment() {
    final booking = widget.booking;
    final navigationService = NavigationService.of(context);
    
    if (navigationService != null) {
      navigationService.navigateTo('payment', {
        'booking': booking,
        'amount': booking.price,
        'description': 'Оплата бронирования: ${booking.title}',
      });
    } else {
      // Fallback навигация
      showSuccessSnackBar(context, 'Переход к оплате...');
    }
  }

  void _payDifference() {
    final booking = widget.booking;
    final navigationService = NavigationService.of(context);
    
    if (navigationService != null) {
      navigationService.navigateTo('payment', {
        'booking': booking,
        'amount': booking.priceDifference,
        'description': 'Доплата за перенос времени бронирования',
        'isDifferencePayment': true,
      });
    }
  }
}