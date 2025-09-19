import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';

class KpiDetailScreen extends StatelessWidget {
  const KpiDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Детальная статистика KPI',
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
            // Общая статистика
            Text(
              'Общие показатели',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Карточки с основными показателями
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildKpiCard(
                  title: 'Всего клиентов',
                  value: '42',
                  icon: Icons.people,
                  color: AppColors.primary,
                ),
                _buildKpiCard(
                  title: 'Средняя оценка',
                  value: '4.8',
                  icon: Icons.star,
                  color: AppColors.accent,
                ),
                _buildKpiCard(
                  title: 'Выполнено занятий',
                  value: '156',
                  icon: Icons.fitness_center,
                  color: AppColors.success,
                ),
                _buildKpiCard(
                  title: 'Доход за месяц',
                  value: '85,600 ₽',
                  icon: Icons.attach_money,
                  color: AppColors.secondary,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Еженедельная статистика
            Text(
              'Еженедельная статистика',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: AppColors.shadowSm,
              ),
              child: Column(
                children: [
                  _buildWeekStatItem('Понедельник', '12 занятий', '95%'),
                  const Divider(height: 24),
                  _buildWeekStatItem('Вторник', '14 занятий', '98%'),
                  const Divider(height: 24),
                  _buildWeekStatItem('Среда', '10 занятий', '92%'),
                  const Divider(height: 24),
                  _buildWeekStatItem('Четверг', '16 занятий', '100%'),
                  const Divider(height: 24),
                  _buildWeekStatItem('Пятница', '13 занятий', '96%'),
                  const Divider(height: 24),
                  _buildWeekStatItem('Суббота', '8 занятий', '88%'),
                  const Divider(height: 24),
                  _buildWeekStatItem('Воскресенье', '6 занятий', '85%'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Графики эффективности
            Text(
              'Графики эффективности',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: AppColors.shadowSm,
              ),
              child: Column(
                children: [
                  _buildChartPlaceholder('Посещаемость занятий', AppColors.primary),
                  const SizedBox(height: 16),
                  _buildChartPlaceholder('Доход по неделям', AppColors.secondary),
                  const SizedBox(height: 16),
                  _buildChartPlaceholder('Оценки клиентов', AppColors.accent),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Достижения
            Text(
              'Достижения',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: AppColors.shadowSm,
              ),
              child: Column(
                children: [
                  _buildAchievementItem(
                    'Мастер качества',
                    'Средняя оценка выше 4.7',
                    Icons.emoji_events,
                    AppColors.accent,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementItem(
                    'Трудоголик',
                    'Более 150 занятий в месяц',
                    Icons.work,
                    AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementItem(
                    'Звезда месяца',
                    'Лучший показатель эффективности',
                    Icons.star,
                    AppColors.secondary,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      padding: AppStyles.paddingLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStatItem(String day, String sessions, String efficiency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            day,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          sessions,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getEfficiencyColor(efficiency),
            borderRadius: AppStyles.borderRadiusMd,
          ),
          child: Text(
            efficiency,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _getEfficiencyColor(String efficiency) {
    final value = double.parse(efficiency.replaceAll('%', ''));
    if (value >= 95) return AppColors.success;
    if (value >= 90) return AppColors.accent;
    if (value >= 85) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildChartPlaceholder(String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppStyles.borderRadiusLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Icon(
              Icons.bar_chart,
              color: color,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 20,
        ),
      ],
    );
  }
}