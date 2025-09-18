import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final Function(String, [dynamic]) onQuickAccessNavigate;

  const EmployeeHomeScreen({super.key, required this.onQuickAccessNavigate});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool _showQuickAccess = true;
  bool _showTodaySchedule = true;
  bool _showKpiStats = true;
  bool _showEmployeeInfo = true;

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Приветствие и информация о сотруднике
            _buildEmployeeWelcomeSection(user),
            const SizedBox(height: 16),

            // Быстрый доступ
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Быстрый доступ',
                        style: AppTextStyles.headline6.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showQuickAccess ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _showQuickAccess = !_showQuickAccess),
                      ),
                    ],
                  ),
                  if (_showQuickAccess) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(
                          icon: Icons.calendar_today,
                          label: 'Расписание',
                          onTap: () => widget.onQuickAccessNavigate('employee_schedule'),
                        ),
                        _buildQuickAction(
                          icon: Icons.people,
                          label: 'Клиенты',
                          onTap: () => widget.onQuickAccessNavigate('employee_clients'),
                        ),
                        _buildQuickAction(
                          icon: Icons.analytics,
                          label: 'KPI',
                          onTap: () => widget.onQuickAccessNavigate('employee_kpi'),
                        ),
                        _buildQuickAction(
                          icon: Icons.chat,
                          label: 'Чат',
                          onTap: () => widget.onQuickAccessNavigate('chat'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Сегодняшнее расписание
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Сегодняшнее расписание',
                        style: AppTextStyles.headline6.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showTodaySchedule ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _showTodaySchedule = !_showTodaySchedule),
                      ),
                    ],
                  ),
                  if (_showTodaySchedule) ...[
                    const SizedBox(height: 16),
                    _buildScheduleItem(
                      time: '09:00 - 10:30',
                      title: 'Персональная тренировка',
                      client: 'Иванов А.С.',
                    ),
                    const SizedBox(height: 12),
                    _buildScheduleItem(
                      time: '11:00 - 12:00',
                      title: 'Групповое занятие: Йога',
                      client: 'Группа (12 чел.)',
                    ),
                    const SizedBox(height: 12),
                    _buildScheduleItem(
                      time: '14:00 - 15:30',
                      title: 'Персональная тренировка',
                      client: 'Петрова Е.В.',
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () => widget.onQuickAccessNavigate('employee_schedule'),
                        child: const Text('Все расписание'),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Статистика KPI
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Статистика KPI',
                        style: AppTextStyles.headline6.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showKpiStats ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _showKpiStats = !_showKpiStats),
                      ),
                    ],
                  ),
                  if (_showKpiStats) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildKpiStat(
                          value: '24',
                          label: 'Клиентов\nв этом месяце',
                          color: AppColors.primary,
                        ),
                        _buildKpiStat(
                          value: '86%',
                          label: 'Посещаемость',
                          color: AppColors.success,
                        ),
                        _buildKpiStat(
                          value: '4.8',
                          label: 'Рейтинг',
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () => widget.onQuickAccessNavigate('employee_kpi'),
                        child: const Text('Подробная статистика'),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Информация о сотруднике
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Информация о сотруднике',
                        style: AppTextStyles.headline6.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showEmployeeInfo ? Icons.expand_less : Icons.expand_more,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _showEmployeeInfo = !_showEmployeeInfo),
                      ),
                    ],
                  ),
                  if (_showEmployeeInfo) ...[
                    const SizedBox(height: 16),
                    _buildEmployeeInfoItem(
                      icon: Icons.work,
                      title: 'Должность',
                      value: 'Старший тренер',
                    ),
                    const SizedBox(height: 12),
                    _buildEmployeeInfoItem(
                      icon: Icons.calendar_month,
                      title: 'Стаж работы',
                      value: '3 года 8 месяцев',
                    ),
                    const SizedBox(height: 12),
                    _buildEmployeeInfoItem(
                      icon: Icons.star,
                      title: 'Специализация',
                      value: 'Фитнес, Йога, Персональные тренировки',
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeWelcomeSection(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Row(
        children: [
          // Аватар
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          
          // Информация
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Виноградов Игорь Вячеславович',
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Старший тренер',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chat, size: 20),
                      onPressed: () => widget.onQuickAccessNavigate('chat'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Чат с клиентами',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: AppColors.primary),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
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

  Widget _buildScheduleItem({
    required String time,
    required String title,
    required String client,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppStyles.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  client,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiStat({
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headline4.copyWith(
            color: color,
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

  Widget _buildEmployeeInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
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
}