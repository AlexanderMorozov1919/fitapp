import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/trainer_model.dart';
import '../services/mock_data_service.dart';
import '../services/notification_service.dart';
import '../main.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';

class ScheduleConfirmationScreen extends StatefulWidget {
  final GroupClass groupClass;

  const ScheduleConfirmationScreen({super.key, required this.groupClass});

  @override
  State<ScheduleConfirmationScreen> createState() => _ScheduleConfirmationScreenState();
}

class _ScheduleConfirmationScreenState extends State<ScheduleConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final groupClass = widget.groupClass;

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
                  // Информация о занятии
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: AppStyles.borderRadiusLg,
                        ),
                        child: Icon(
                          _getClassIcon(groupClass.type),
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
                              groupClass.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${groupClass.type} • ${groupClass.level}',
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
                    icon: Icons.calendar_today,
                    title: 'Дата',
                    value: DateFormatters.formatDate(groupClass.startTime),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.access_time,
                    title: 'Время',
                    value: '${DateFormatters.formatTime(groupClass.startTime)} - ${DateFormatters.formatTime(groupClass.endTime)}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.timer,
                    title: 'Длительность',
                    value: '${groupClass.endTime.difference(groupClass.startTime).inHours} ч',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.location_on,
                    title: 'Место',
                    value: groupClass.location,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.person,
                    title: 'Тренер',
                    value: groupClass.trainerName,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.group,
                    title: 'Участники',
                    value: '${groupClass.currentParticipants + 1}/${groupClass.maxParticipants}',
                  ),

                  // Стоимость
                  if (groupClass.price > 0) ...[
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
                            '${groupClass.price.toInt()} ₽',
                            style: AppTextStyles.price.copyWith(
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      'Отмена занятия возможна не менее чем за 2 часа до начала',
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
                    text: groupClass.price > 0 ? 'Подтвердить и оплатить' : 'Подтвердить запись',
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

  void _proceedToPayment() {
    final groupClass = widget.groupClass;

    final booking = Booking(
      id: 'class_${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      type: BookingType.groupClass,
      startTime: groupClass.startTime,
      endTime: groupClass.endTime,
      title: groupClass.name,
      description: '${groupClass.type} • ${groupClass.level} • ${groupClass.trainerName}',
      status: BookingStatus.pending,
      price: groupClass.price,
      createdAt: DateTime.now(),
    );

    // Обновляем количество участников в групповом занятии
    // Для этого нужно обновить данные в mock сервисе
    MockDataService.updateGroupClassParticipants(groupClass.id, groupClass.currentParticipants + 1);

    // Добавляем в мок данные
    MockDataService.userBookings.add(booking);

    // Показываем уведомление об успехе
    NotificationService.showSuccess(
      context,
      'Вы успешно записаны на занятие!',
    );

    if (groupClass.price > 0) {
      // Переходим на экран оплаты
      final navigationService = NavigationService.of(context);
      navigationService?.navigateTo('payment', {
        'booking': booking,
        'amount': groupClass.price,
        'description': 'Групповое занятие: ${groupClass.name}',
      });
    } else {
      // Бесплатное занятие - сразу переходим на главный экран
      final navigationService = NavigationService.of(context);
      navigationService?.navigateToHome();
    }
  }
}