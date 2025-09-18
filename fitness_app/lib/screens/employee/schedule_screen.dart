import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';

class EmployeeScheduleScreen extends StatelessWidget {
  const EmployeeScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Мое расписание'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фильтр по дате
            _buildDateFilter(),
            const SizedBox(height: 20),

            // Расписание на сегодня
            Text(
              'Сегодня, 18 сентября',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            _buildScheduleItem(
              time: '09:00 - 10:30',
              type: 'Персональная тренировка',
              client: 'Иванов Александр Сергеевич',
              status: 'Подтверждено',
              statusColor: AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildScheduleItem(
              time: '11:00 - 12:00',
              type: 'Групповое занятие: Йога',
              client: 'Группа (12 человек)',
              status: 'Подтверждено',
              statusColor: AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildScheduleItem(
              time: '14:00 - 15:30',
              type: 'Персональная тренировка',
              client: 'Петрова Елена Владимировна',
              status: 'Ожидание',
              statusColor: AppColors.warning,
            ),
            const SizedBox(height: 12),
            _buildScheduleItem(
              time: '16:00 - 17:00',
              type: 'Консультация',
              client: 'Сидоров Михаил Иванович',
              status: 'Подтверждено',
              statusColor: AppColors.success,
            ),

            const SizedBox(height: 24),

            // Расписание на завтра
            Text(
              'Завтра, 19 сентября',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            _buildScheduleItem(
              time: '10:00 - 11:30',
              type: 'Персональная тренировка',
              client: 'Кузнецова Ольга Петровна',
              status: 'Подтверждено',
              statusColor: AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildScheduleItem(
              time: '12:00 - 13:00',
              type: 'Групповое занятие: Фитнес',
              client: 'Группа (15 человек)',
              status: 'Подтверждено',
              statusColor: AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildScheduleItem(
              time: '15:00 - 16:30',
              type: 'Персональная тренировка',
              client: 'Николаев Дмитрий Алексеевич',
              status: 'Отменено',
              statusColor: AppColors.error,
            ),

            const SizedBox(height: 24),

            // Статистика недели
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: AppColors.shadowSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статистика недели',
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeekStat(
                        value: '18',
                        label: 'Всего\nзанятий',
                      ),
                      _buildWeekStat(
                        value: '12',
                        label: 'Персональных\nтренировок',
                      ),
                      _buildWeekStat(
                        value: '6',
                        label: 'Групповых\nзанятий',
                      ),
                    ],
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

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Период:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              Text(
                'Эта неделя',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required String time,
    required String type,
    required String client,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Время
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: AppStyles.borderRadiusSm,
            ),
            child: Text(
              time,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Информация о занятии
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  client,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: AppStyles.borderRadiusSm,
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Действия
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () {
              // TODO: Реализовать меню действий
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStat({
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}