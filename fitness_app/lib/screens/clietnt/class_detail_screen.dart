import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';

class ClassDetailScreen extends StatefulWidget {
  final GroupClass groupClass;

  const ClassDetailScreen({super.key, required this.groupClass});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final groupClass = widget.groupClass;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Детали занятия',
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
                          groupClass.name,
                          style: AppTextStyles.headline6.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(
                        text: groupClass.isFull ? 'Нет мест' : '${groupClass.spotsLeft} мест',
                        color: groupClass.isFull ? AppColors.error : AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Иконка и тип занятия
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
                              groupClass.type,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (groupClass.description.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                groupClass.description,
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
                    title: 'Уровень',
                    value: groupClass.level,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.people,
                    title: 'Участники',
                    value: '${groupClass.currentParticipants}/${groupClass.maxParticipants}',
                  ),

                  // Стоимость
                  if (groupClass.price > 0) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      icon: Icons.attach_money,
                      title: 'Стоимость',
                      value: '${groupClass.price.toInt()} ₽',
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
            if (groupClass.isAvailable) ...[
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: 'Записаться',
                      onPressed: _bookClass,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Информация о требованиях
            if (groupClass.requiresMembership) ...[
              AppCard(
                padding: AppStyles.paddingLg,
                backgroundColor: AppColors.warning.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Для участия требуется действующий абонемент',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
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

  void _bookClass() {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('schedule_confirmation', widget.groupClass);
  }
}