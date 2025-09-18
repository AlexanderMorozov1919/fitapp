
import 'package:flutter/material.dart';
import '../../services/mock_data/kpi_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';

class EmployeeKpiScreen extends StatelessWidget {
  const EmployeeKpiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kpiData = KpiData.employeeKpi;

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
            // Общая финансовая статистика
            _buildFinancialOverview(kpiData),
            const SizedBox(height: 20),

            // Основные KPI
            Text(
              'Основные показатели',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildMainKpiCards(kpiData),
            const SizedBox(height: 20),

            // Теннисные тренировки
            _buildSection(
              title: '🎾 Теннисные тренировки',
              child: Column(
                children: [
                  _buildKpiRow(
                    'Индивидуальные тренировки',
                    '${kpiData['tennisStats']['individualTrainings']}',
                    Icons.sports_tennis,
                    AppColors.primary,
                  ),
                  _buildKpiRow(
                    'Групповые тренировки',
                    '${kpiData['tennisStats']['groupTrainings']}',
                    Icons.group,
                    AppColors.accent,
                  ),
                  _buildKpiRow(
                    'Аренда кортов',
                    '${kpiData['tennisStats']['courtsRented']}',
                    Icons.calendar_today,
                    AppColors.success,
                  ),
                  _buildKpiRow(
                    'Средняя длительность',
                    '${kpiData['tennisStats']['avgTrainingDuration']} мин',
                    Icons.timer,
                    AppColors.warning,
                  ),
                  _buildProgressRow(
                    'Прогресс учеников',
                    kpiData['tennisStats']['studentProgress']['beginnerToIntermediate'] / 10,
                    '${kpiData['tennisStats']['studentProgress']['beginnerToIntermediate']} переходов',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Тренажерный зал
            _buildSection(
              title: '💪 Тренажерный зал',
              child: Column(
                children: [
                  _buildKpiRow(
                    'Индивидуальные программы',
                    '${kpiData['gymStats']['individualPrograms']}',
                    Icons.fitness_center,
                    AppColors.primary,
                  ),
                  _buildKpiRow(
                    'Регулярные клиенты',
                    '${kpiData['gymStats']['regularClients']}%',
                    Icons.people,
                    AppColors.success,
                  ),
                  _buildKpiRow(
                    'Консультации по питанию',
                    '${kpiData['gymStats']['nutritionConsultations']}',
                    Icons.restaurant,
                    AppColors.accent,
                  ),
                  _buildProgressRow(
                    'Достижение целей клиентов',
                    kpiData['gymStats']['clientProgress']['goalAchievement'] / 100,
                    '${kpiData['gymStats']['clientProgress']['goalAchievement']}%',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Групповые тренировки
            _buildSection(
              title: '👥 Групповые тренировки',
              child: Column(
                children: [
                  _buildKpiRow(
                    'Тренировок в неделю',
                    '${kpiData['groupStats']['weeklyTrainings']}',
                    Icons.event,
                    AppColors.primary,
                  ),
                  _buildKpiRow(
                    'Средняя наполняемость',
                    '${kpiData['groupStats']['avgAttendance']} чел',
                    Icons.people_outline,
                    AppColors.success,
                  ),
                  _buildKpiRow(
                    'Новые участники',
                    '${kpiData['groupStats']['newParticipants']}',
                    Icons.person_add,
                    AppColors.accent,
                  ),
                  _buildKpiRow(
                    'Форматы тренировок',
                    '${kpiData['groupStats']['trainingFormats']}',
                    Icons.format_list_bulleted,
                    AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Финансовые показатели
            _buildSection(
              title: '💰 Финансовые показатели',
              child: Column(
                children: [
                  _buildKpiRow(
                    'Продажи абонементов',
                    '${kpiData['financialStats']['membershipsSold']}',
                    Icons.credit_card,
                    AppColors.primary,
                  ),
                  _buildKpiRow(
                    'Общая выручка',
                    '${(kpiData['financialStats']['totalSales'] / 1000).toStringAsFixed(0)}K ₽',
                    Icons.attach_money,
                    AppColors.success,
                  ),
                  _buildKpiRow(
                    'Конверсия',
                    '${kpiData['financialStats']['conversionRate']}%',
                    Icons.trending_up,
                    AppColors.accent,
                  ),
                  _buildKpiRow(
                    'Средний чек',
                    '${(kpiData['financialStats']['averageCheck'] / 1000).toStringAsFixed(1)}K ₽',
                    Icons.receipt,
                    AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Распределение выручки
            _buildRevenueBreakdown(kpiData['revenueBreakdown']),
            const SizedBox(height: 20),

            // Бонусные KPI
            _buildSection(
              title: '🎯 Бонусные показатели',
              child: Column(
                children: [
                  _buildKpiRow(
                    'Турниры и мероприятия',
                    '${kpiData['bonusKpi']['tournaments']}',
                    Icons.emoji_events,
                    AppColors.primary,
                  ),
                  _buildKpiRow(
                    'Работа с юниорами',
                    '${kpiData['bonusKpi']['juniorWork']}',
                    Icons.school,
                    AppColors.success,
                  ),
                  _buildKpiRow(
                    'Социальный контент',
                    '${kpiData['bonusKpi']['socialContent']}',
                    Icons.video_library,
                    AppColors.accent,
                  ),
                  _buildKpiRow(
                    'Положительные отзывы',
                    '${kpiData['bonusKpi']['positiveReviews']}',
                    Icons.thumb_up,
                    AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Цели и достижения
            _buildGoalsSection(kpiData['goals']),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview(Map<String, dynamic> kpiData) {
    final overall = kpiData['overallStats'];
    return AppCard(
      padding: AppStyles.paddingLg,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Финансовый обзор',
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Сентябрь 2024',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFinancialCard(
                'Выручка',
                '${(overall['revenue'] / 1000).toStringAsFixed(0)}K ₽',
                AppColors.success,
                Icons.attach_money,
              ),
              _buildFinancialCard(
                'KPI',
                '${overall['totalKpi']}%',
                AppColors.primary,
                Icons.bar_chart,
              ),
              _buildFinancialCard(
                'Загрузка',
                '${overall['workload']}%',
                AppColors.accent,
                Icons.work,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(String title, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headline6.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMainKpiCards(Map<String, dynamic> kpiData) {
    final overall = kpiData['overallStats'];
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            'Удовлетворенность',
            '${overall['satisfaction']}/5',
            '⭐ ${overall['satisfaction']}',
            AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            'Посещаемость',
            '${overall['attendance']}%',
            '👥 ${overall['attendance']}%',
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiCard(
            'Всего клиентов',
            '${kpiData['generalMetrics']['totalTrainings']}',
            '🏋️ ${kpiData['generalMetrics']['totalTrainings']}',
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color) {
    return Container(
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
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headline6.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return AppCard(
      padding: AppStyles.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildKpiRow(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
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
      ),
    );
  }

  Widget _buildProgressRow(String title, double progress, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1 ? AppColors.success : AppColors.primary,
            ),
            minHeight: 6,
            borderRadius: AppStyles.borderRadiusSm,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdown(Map<String, dynamic> breakdown) {
    final total = breakdown.values.fold<int>(0, (sum, value) => sum + (value as int));
    return AppCard(
      padding: AppStyles.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 Распределение выручки',
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildRevenueItem('Теннис', breakdown['tennis'], total, AppColors.primary),
          _buildRevenueItem('Тренажерный зал', breakdown['gym'], total, AppColors.success),
          _buildRevenueItem('Групповые занятия', breakdown['group'], total, AppColors.accent),
          _buildRevenueItem('Абонементы', breakdown['memberships'], total, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildRevenueItem(String title, int value, int total, Color color) {
    final percentage = (value / total * 100).toInt();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(value / 1000).toStringAsFixed(1)}K ₽ ($percentage%)',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / total,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: AppStyles.borderRadiusSm,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(Map<String, dynamic> goals) {
    return AppCard(
      padding: AppStyles.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 Цели на месяц',
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildGoalItem(
            'Новые клиенты',
            goals['monthlyClients']['current'],
            goals['monthlyClients']['target'],
            'клиентов',
          ),
          _buildGoalItem(
            'Выручка',
            goals['monthlyRevenue']['current'],
            goals['monthlyRevenue']['target'],
            '₽',
          ),
          _buildGoalItem(
            'Рейтинг',
            goals['satisfactionRating']['current'],
            goals['satisfactionRating']['target'],
            'звезд',
          ),
          _buildGoalItem(
            'Теннис тренировки',
            goals['tennisTrainings']['current'],
            goals['tennisTrainings']['target'],
            'тренировок',
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String title, num current, num target, String unit) {
    final progress = current / target;
    final percentage = (progress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$current/$target $unit',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1 ? AppColors.success : AppColors.primary,
            ),
            minHeight: 8,
            borderRadius: AppStyles.borderRadiusSm,
          ),
          const SizedBox(height: 4),
          Text(
            '$percentage%',
            style: AppTextStyles.caption.copyWith(
              color: progress >= 1 ? AppColors.success : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}