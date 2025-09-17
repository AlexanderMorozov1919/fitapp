import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import 'home_welcome_section.dart';
import 'home_quick_actions.dart';
import 'home_bookings_section.dart';
import 'home_classes_section.dart';
import 'home_membership_section.dart';
import 'home_statistics_section.dart';
import 'home_section_widget.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onQuickAccessNavigate;

  const HomeScreen({super.key, required this.onQuickAccessNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showQuickAccess = true;
  bool _showTodayBookings = true;
  bool _showUpcomingBookings = true;
  bool _showTodayClasses = true;
  bool _showMembershipInfo = true;
  bool _showStatistics = true;

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;
    final upcomingBookings = MockDataService.userBookings
        .where((booking) => booking.startTime.isAfter(DateTime.now()))
        .toList();
    
    final todayBookings = MockDataService.userBookings
        .where((booking) {
          final today = DateTime.now();
          return booking.startTime.year == today.year &&
                 booking.startTime.month == today.month &&
                 booking.startTime.day == today.day;
        })
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Фитнес Центр',
          style: AppTextStyles.headline4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Приветствие и баланс
            HomeWelcomeSection(user: user),
            const SizedBox(height: 16),

            // Быстрый доступ
            HomeSectionWidget(
              title: 'Быстрый доступ',
              isExpanded: _showQuickAccess,
              onToggle: () => setState(() => _showQuickAccess = !_showQuickAccess),
              child: HomeQuickActions(onQuickAccessNavigate: onQuickAccessNavigate),
            ),

            // Мои бронирования сегодня
            if (todayBookings.isNotEmpty) ...[
              const SizedBox(height: 12),
              HomeSectionWidget(
                title: 'Мои бронирования сегодня',
                isExpanded: _showTodayBookings,
                onToggle: () => setState(() => _showTodayBookings = !_showTodayBookings),
                child: HomeBookingsSection(
                  bookings: todayBookings,
                  onCancelBooking: _showCancelDialog,
                  onRescheduleBooking: _showRescheduleDialog,
                ),
              ),
            ],

            // Мои бронирования
            if (upcomingBookings.isNotEmpty) ...[
              const SizedBox(height: 12),
              HomeSectionWidget(
                title: 'Мои бронирования',
                isExpanded: _showUpcomingBookings,
                onToggle: () => setState(() => _showUpcomingBookings = !_showUpcomingBookings),
                child: HomeBookingsSection(
                  bookings: upcomingBookings,
                  onCancelBooking: _showCancelDialog,
                  onRescheduleBooking: _showRescheduleDialog,
                ),
              ),
            ],

            // Групповые занятия сегодня
            const SizedBox(height: 12),
            HomeSectionWidget(
              title: 'Занятия сегодня',
              isExpanded: _showTodayClasses,
              onToggle: () => setState(() => _showTodayClasses = !_showTodayClasses),
              child: HomeClassesSection(),
            ),

            // Информация о действующем абонементе
            if (user.membership != null) ...[
              const SizedBox(height: 12),
              HomeSectionWidget(
                title: 'Ваш абонемент',
                isExpanded: _showMembershipInfo,
                onToggle: () => setState(() => _showMembershipInfo = !_showMembershipInfo),
                child: HomeMembershipSection(
                  user: user,
                  onQuickAccessNavigate: onQuickAccessNavigate,
                ),
              ),
            ],

            // Статистика посещений
            const SizedBox(height: 12),
            HomeSectionWidget(
              title: 'Статистика посещений',
              isExpanded: _showStatistics,
              onToggle: () => setState(() => _showStatistics = !_showStatistics),
              child: HomeStatisticsSection(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void onQuickAccessNavigate(String screenKey) {
    widget.onQuickAccessNavigate(screenKey);
  }

  void _showCancelDialog(dynamic booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Отменить бронирование',
          style: AppTextStyles.headline5,
        ),
        content: Text(
          'Вы уверены, что хотите отменить это бронирование?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Нет',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Бронирование отменено',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppStyles.borderRadiusLg,
                  ),
                ),
              );
            },
            child: Text(
              'Да, отменить',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(dynamic booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Перенести бронирование',
          style: AppTextStyles.headline5,
        ),
        content: Text(
          'Функция переноса бронирования будет доступна в ближайшее время.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}