import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';

class EmployeeKpiScreen extends StatelessWidget {
  const EmployeeKpiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('KPI и Статистика'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Общая статистика
            _buildOverallStats(),
            const SizedBox(height: 20),

            // Статистика по месяцам
            Text(
              'Статистика по месяцам',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildMonthlyStats(),

            const SizedBox(height: 24),

            // Детальная статистика
            Text(
              'Детальная статистика',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailedStats(),

            const SizedBox(height: 24),

            // Цели и достижения
            Text(
              'Цели и достижения',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildGoals(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                title: 'Общий KPI',
                value: '87%',
                progress: 0.87,
                color: AppColors.primary,
              ),
              _buildStatCard(
                title: 'Посещаемость',
                value: '92%',
                progress: 0.92,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                title: 'Удовлетворенность',
                value: '4.8/5',
                progress: 0.96,
                color: AppColors.accent,
              ),
              _buildStatCard(
                title: 'Выручка',
                value: '₽156K',
                progress: 0.78,
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.headline6.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthlyStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        children: [
          _buildMonthStatItem(
            month: 'Сентябрь 2024',
            clients: 24,
            revenue: 156000,
            rating: 4.8,
          ),
          const SizedBox(height: 12),
          _buildMonthStatItem(
            month: 'Август 2024',
            clients: 22,
            revenue: 142000,
            rating: 4.7,
          ),
          const SizedBox(height: 12),
          _buildMonthStatItem(
            month: 'Июль 2024',
            clients: 20,
            revenue: 135000,
            rating: 4.6,
          ),
          const SizedBox(height: 12),
          _buildMonthStatItem(
            month: 'Июнь 2024',
            clients: 18,
            revenue: 120000,
            rating: 4.5,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthStatItem({
    required String month,
    required int clients,
    required int revenue,
    required double rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppStyles.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$clients клиентов',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(revenue / 1000).toStringAsFixed(0)}K ₽',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        children: [
          _buildDetailStatItem(
            title: 'Всего клиентов',
            value: '86',
            icon: Icons.people,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildDetailStatItem(
            title: 'Персональных тренировок',
            value: '142',
            icon: Icons.fitness_center,
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          _buildDetailStatItem(
            title: 'Групповых занятий',
            value: '68',
            icon: Icons.group,
            color: AppColors.accent,
          ),
          const SizedBox(height: 12),
          _buildDetailStatItem(
            title: 'Средняя выручка в месяц',
            value: '₽138K',
            icon: Icons.attach_money,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGoals() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        children: [
          _buildGoalItem(
            title: 'Новых клиентов в месяц',
            current: 24,
            target: 30,
            unit: 'клиентов',
          ),
          const SizedBox(height: 12),
          _buildGoalItem(
            title: 'Выручка в месяц',
            current: 156000,
            target: 200000,
            unit: '₽',
          ),
          const SizedBox(height: 12),
          _buildGoalItem(
            title: 'Рейтинг удовлетворенности',
            current: 4.8,
            target: 5.0,
            unit: 'звезд',
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem({
    required String title,
    required num current,
    required num target,
    required String unit,
  }) {
    final progress = current / target;
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1 ? AppColors.success : AppColors.primary,
          ),
          minHeight: 8,
          borderRadius: AppStyles.borderRadiusSm,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$current/$target $unit',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '$percentage%',
              style: AppTextStyles.caption.copyWith(
                color: progress >= 1 ? AppColors.success : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}