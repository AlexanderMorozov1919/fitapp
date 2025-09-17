import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/booking_model.dart';
import 'home_welcome_section.dart';
import 'home_quick_actions.dart';
import 'home_bookings_section.dart';
import 'home_classes_section.dart';
import 'home_membership_section.dart';
import 'home_statistics_section.dart';
import 'home_section_widget.dart';
import 'booking_detail_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  final Function(String, [dynamic]) onQuickAccessNavigate;

  const HomeScreen({super.key, required this.onQuickAccessNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showQuickAccess = true;
  bool _showUpcomingBookings = true;
  bool _showTodayClasses = true;
  bool _showMembershipInfo = true;
  bool _showStatistics = true;

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;
    final allBookings = MockDataService.userBookings;

    return Scaffold(
      backgroundColor: AppColors.background,
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
              child: HomeQuickActions(onQuickAccessNavigate: widget.onQuickAccessNavigate),
            ),

            // Объединенная секция бронирований с фильтром
            if (allBookings.isNotEmpty) ...[
              const SizedBox(height: 12),
              HomeSectionWidget(
                title: 'Мои бронирования',
                isExpanded: _showUpcomingBookings,
                onToggle: () => setState(() => _showUpcomingBookings = !_showUpcomingBookings),
                child: HomeBookingsSection(
                  allBookings: allBookings,
                  onCancelBooking: _showCancelDialog,
                  onRescheduleBooking: _showRescheduleDialog,
                  onBookingTap: _navigateToBookingDetail,
                ),
              ),
            ],

            // Групповые занятия сегодня
            const SizedBox(height: 12),
            HomeSectionWidget(
              title: 'Занятия сегодня',
              isExpanded: _showTodayClasses,
              onToggle: () => setState(() => _showTodayClasses = !_showTodayClasses),
              child: HomeClassesSection(onClassTap: _navigateToClassDetail),
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
                  onQuickAccessNavigate: widget.onQuickAccessNavigate,
                ),
              ),
            ],

            // Статистика посещений
            const SizedBox(height: 12),
            HomeSectionWidget(
              title: 'Статистика посещений',
              isExpanded: _showStatistics,
              onToggle: () => setState(() => _showStatistics = !_showStatistics),
              child: const HomeStatisticsSection(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(dynamic booking) {
    widget.onQuickAccessNavigate('cancel_booking', booking);
  }

  void _showRescheduleDialog(dynamic booking) {
    widget.onQuickAccessNavigate('reschedule_booking', booking);
  }

  void _navigateToBookingDetail(Booking booking) {
    widget.onQuickAccessNavigate('booking_detail', booking);
  }
  void _navigateToClassDetail(dynamic classItem) {
    widget.onQuickAccessNavigate('class_detail', classItem);
  }
}