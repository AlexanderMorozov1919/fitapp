import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';

class TrainingDetailScreen extends StatelessWidget {
  final Booking training;

  const TrainingDetailScreen({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Детали тренировки'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
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
                  Row(
                    children: [
                      // Иконка типа тренировки
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getStatusColor(training.status).withOpacity(0.1),
                          borderRadius: AppStyles.borderRadiusLg,
                        ),
                        child: Icon(
                          _getTrainingIcon(training),
                          size: 24,
                          color: _getStatusColor(training.status),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Основная информация
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              training.title,
                              style: AppTextStyles.headline6.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getTrainingTypeText(training.type),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Статус
                      StatusBadge(
                        text: _getStatusText(training.status),
                        color: _getStatusColor(training.status),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Разделитель
                  Container(
                    height: 1,
                    color: AppColors.border,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Детальная информация
                  _buildInfoItem(
                    icon: Icons.calendar_today,
                    title: 'Дата и время',
                    value: '${DateFormatters.formatDate(training.startTime)}, '
                          '${DateFormatters.formatTimeRangeRussian(training.startTime, training.endTime)}',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoItem(
                    icon: Icons.person,
                    title: 'Клиент',
                    value: training.clientName ?? 'Не указан',
                  ),
                  
                  if (training.description != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      icon: Icons.description,
                      title: 'Описание',
                      value: training.description!,
                    ),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoItem(
                    icon: Icons.attach_money,
                    title: 'Стоимость',
                    value: '${training.price} ₽',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Действия
            Text(
              'Действия',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            if (training.status == BookingStatus.confirmed) ...[
              _buildActionButton(
                icon: Icons.edit,
                text: 'Редактировать тренировку',
                onPressed: () {
                  // TODO: Реализовать редактирование
                },
              ),
              const SizedBox(height: 8),
            ],
            
            if (training.status == BookingStatus.pending) ...[
              _buildActionButton(
                icon: Icons.check,
                text: 'Подтвердить тренировку',
                onPressed: () {
                  // TODO: Реализовать подтверждение
                },
              ),
              const SizedBox(height: 8),
            ],
            
            if (training.status == BookingStatus.confirmed) ...[
              _buildActionButton(
                icon: Icons.cancel,
                text: 'Отменить тренировку',
                onPressed: () {
                  // TODO: Реализовать отмену
                },
                isDestructive: true,
              ),
              const SizedBox(height: 8),
            ],
            
            _buildActionButton(
              icon: Icons.chat,
              text: 'Написать клиенту',
              onPressed: () {
                // TODO: Реализовать переход в чат
              },
            ),
            
            const SizedBox(height: 20),
            
            // Дополнительная информация
            Text(
              'Дополнительная информация',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdditionalInfoItem(
                    title: 'ID тренировки',
                    value: training.id,
                  ),
                  const SizedBox(height: 8),
                  _buildAdditionalInfoItem(
                    title: 'Создано',
                    value: DateFormatters.formatDateTime(training.createdAt),
                  ),
                  const SizedBox(height: 8),
                  _buildAdditionalInfoItem(
                    title: 'Продолжительность',
                    value: '${training.endTime.difference(training.startTime).inMinutes} минут',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: Icon(
          icon,
          size: 20,
          color: isDestructive ? AppColors.error : AppColors.primary,
        ),
        label: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDestructive ? AppColors.error : AppColors.primary,
          ),
        ),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: AppStyles.paddingLg,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadiusLg,
            side: BorderSide(
              color: isDestructive ? AppColors.error : AppColors.border,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoItem({
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  IconData _getTrainingIcon(Booking training) {
    switch (training.type) {
      case BookingType.tennisCourt:
        return Icons.sports_tennis;
      case BookingType.groupClass:
        return Icons.group;
      case BookingType.personalTraining:
        return Icons.person;
      default:
        return Icons.fitness_center;
    }
  }

  String _getTrainingTypeText(BookingType type) {
    switch (type) {
      case BookingType.tennisCourt:
        return 'Теннисный корт';
      case BookingType.groupClass:
        return 'Групповое занятие';
      case BookingType.personalTraining:
        return 'Персональная тренировка';
      default:
        return 'Тренировка';
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.completed:
        return AppColors.info;
    }
    return AppColors.textTertiary;
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Подтверждено';
      case BookingStatus.pending:
        return 'Ожидание';
      case BookingStatus.cancelled:
        return 'Отменено';
      case BookingStatus.completed:
        return 'Завершено';
    }
    return 'Неизвестно';
  }
}