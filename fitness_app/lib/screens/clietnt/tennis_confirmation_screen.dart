import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../services/mock_data_service.dart';
import '../../services/notification_service.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';

class TennisConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const TennisConfirmationScreen({super.key, required this.bookingData});

  @override
  State<TennisConfirmationScreen> createState() => _TennisConfirmationScreenState();
}

class _TennisConfirmationScreenState extends State<TennisConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final court = widget.bookingData['court'] as TennisCourt;
    final date = widget.bookingData['date'] as DateTime;
    final startTime = widget.bookingData['startTime'] as TimeOfDay;
    final endTime = widget.bookingData['endTime'] as TimeOfDay;
    final totalPrice = widget.bookingData['totalPrice'] as double;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Подтверждение бронирования',
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
              'Проверьте детали бронирования:',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Карточка с информацией о бронировании
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Информация о корте
                  Row(
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
                              court.number,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${court.surfaceType} • ${court.isIndoor ? 'Крытый' : 'Открытый'}',
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

                  // Детали времени
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    title: 'Дата',
                    value: DateFormatters.formatDate(date),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.access_time,
                    title: 'Время',
                    value: '${_formatTime(startTime)} - ${_formatTime(endTime)}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.timer,
                    title: 'Длительность',
                    value: '${endTime.hour - startTime.hour} ч',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.attach_money,
                    title: 'Тариф',
                    value: court.getPriceDescription(DateTime(
                      date.year,
                      date.month,
                      date.day,
                      startTime.hour,
                      startTime.minute,
                    )),
                  ),

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
                          'Итоговая стоимость:',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${totalPrice.toStringAsFixed(0)} ₽',
                          style: AppTextStyles.price.copyWith(
                            fontSize: 18,
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

            // Условия бронирования
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
                      'Отмена бронирования возможна не менее чем за 2 часа до начала',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Кнопки действий
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Подтвердить и оплатить',
                    onPressed: _proceedToPayment,
                  ),
                ),
              ],
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

  void _proceedToPayment() {
    // Создаем объект бронирования
    final court = widget.bookingData['court'] as TennisCourt;
    final date = widget.bookingData['date'] as DateTime;
    final startTime = widget.bookingData['startTime'] as TimeOfDay;
    final endTime = widget.bookingData['endTime'] as TimeOfDay;
    final totalPrice = widget.bookingData['totalPrice'] as double;

    final startDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );

    final endDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      endTime.hour,
      endTime.minute,
    );

    final durationHours = endTime.hour - startTime.hour;

    // Блокируем время на корте
    court.bookTimeSlot(startDateTime, durationHours);

    final booking = Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      type: BookingType.tennisCourt,
      startTime: startDateTime,
      endTime: endDateTime,
      title: 'Теннисный корт ${court.number}',
      description: '${court.surfaceType} • ${court.isIndoor ? 'Крытый' : 'Открытый'}',
      status: BookingStatus.awaitingPayment,
      price: totalPrice,
      courtNumber: court.number,
      createdAt: DateTime.now(),
    );

    // Добавляем в мок данные
    MockDataService.userBookings.add(booking);

    // Показываем уведомление об успехе
    NotificationService.showSuccess(
      context,
      'Корт успешно забронирован! Оплатите в течение 15 минут.',
    );

    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('payment', {
      'booking': booking,
      'amount': totalPrice,
      'description': 'Бронирование теннисного корта ${court.number}',
    });
  }

  String _formatTime(TimeOfDay time) {
    final dateTime = DateTime(2024, 1, 1, time.hour, time.minute);
    return DateFormatters.formatTimeRussian(dateTime);
  }
}