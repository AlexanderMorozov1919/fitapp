import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../models/booking_model.dart';
import '../../services/mock_data_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';

class TrainingConfirmationScreen extends StatefulWidget {
  final Trainer trainer;
  final String serviceName;
  final double price;
  final DateTime date;
  final TimeOfDay time;

  const TrainingConfirmationScreen({
    super.key,
    required this.trainer,
    required this.serviceName,
    required this.price,
    required this.date,
    required this.time,
  });

  @override
  State<TrainingConfirmationScreen> createState() => _TrainingConfirmationScreenState();
}

class _TrainingConfirmationScreenState extends State<TrainingConfirmationScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final startDateTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      widget.time.hour,
      widget.time.minute,
    );
    final endDateTime = startDateTime.add(const Duration(hours: 1));

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
                        child: widget.trainer.photoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                  widget.trainer.photoUrl!,
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
                              widget.trainer.fullName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              widget.trainer.specialty,
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
                    value: widget.serviceName,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    title: 'Дата',
                    value: DateFormatters.formatDateWithMonth(widget.date),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.access_time,
                    title: 'Время',
                    value: '${_formatTime(widget.time)} - ${_formatTime(TimeOfDay(hour: widget.time.hour + 1, minute: widget.time.minute))}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.timer,
                    title: 'Длительность',
                    value: '1 час',
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
                          '${widget.price.toInt()} ₽',
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

            const Spacer(),

            // Кнопка подтверждения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _confirmBooking,
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
                        'Подтвердить и оплатить',
                        style: AppTextStyles.buttonMedium,
                      ),
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

  void _confirmBooking() async {
    setState(() {
      _isProcessing = true;
    });

    // Имитация процесса бронирования
    await Future.delayed(const Duration(seconds: 1));

    final startDateTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      widget.time.hour,
      widget.time.minute,
    );
    final endDateTime = startDateTime.add(const Duration(hours: 1));

    final booking = Booking(
      id: 'training_${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      type: BookingType.personalTraining,
      startTime: startDateTime,
      endTime: endDateTime,
      title: '${widget.serviceName} с ${widget.trainer.fullName}',
      description: 'Персональная тренировка',
      status: BookingStatus.pending,
      price: widget.price,
      trainerId: widget.trainer.id,
      createdAt: DateTime.now(),
    );

    // Добавляем в мок данные
    MockDataService.userBookings.add(booking);

    setState(() {
      _isProcessing = false;
    });

    // Переходим на экран оплаты
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('payment', {
      'booking': booking,
      'amount': widget.price,
      'description': '${widget.serviceName} с ${widget.trainer.fullName}',
    });
  }
}