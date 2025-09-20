import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../models/booking_model.dart';
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
  @override
  Widget build(BuildContext context) {
    final trainer = widget.bookingData['trainer'] as Trainer;
    final serviceName = widget.bookingData['serviceName'] as String;
    final price = widget.bookingData['price'] as double;
    final date = widget.bookingData['date'] as DateTime;
    final time = widget.bookingData['time'] as TimeOfDay;

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
                          '${price.toInt()} ₽',
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

            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Назад',
                    onPressed: () {
                      final navigationService = NavigationService.of(context);
                      navigationService?.onBack();
                    },
                  ),
                ),
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

  String _formatTime(TimeOfDay time) {
    final dateTime = DateTime(2024, 1, 1, time.hour, time.minute);
    return DateFormatters.formatTimeRussian(dateTime);
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

    final booking = Booking(
      id: 'training_${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      type: BookingType.personalTraining,
      startTime: startDateTime,
      endTime: endDateTime,
      title: '$serviceName с ${trainer.fullName}',
      description: 'Персональная тренировка',
      status: BookingStatus.awaitingPayment,
      price: price,
      trainerId: trainer.id,
      createdAt: DateTime.now(),
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
      'amount': price,
      'description': '$serviceName с ${trainer.fullName}',
    });
  }
}