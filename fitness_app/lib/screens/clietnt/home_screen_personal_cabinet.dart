import 'package:flutter/material.dart';
import 'package:fitness_app/services/custom_notification_service.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import 'home_welcome_section.dart';
import 'home_quick_actions.dart';
import 'home_bookings_section.dart';
import 'home_classes_section.dart';
import 'home_membership_section.dart';
import 'home_statistics_section.dart';
import 'home_section_widget.dart';
import 'booking_detail_screen.dart';
import 'membership_detail_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/news_banner_widget.dart';

class HomeScreenPersonalCabinet extends StatefulWidget {
  final Function(String, [dynamic]) onQuickAccessNavigate;

  const HomeScreenPersonalCabinet({super.key, required this.onQuickAccessNavigate});

  @override
  State<HomeScreenPersonalCabinet> createState() => _HomeScreenPersonalCabinetState();
}

class _HomeScreenPersonalCabinetState extends State<HomeScreenPersonalCabinet> {
  @override
  void initState() {
    super.initState();
  }
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
            HomeWelcomeSection(
              user: user,
              onQuickAccessNavigate: widget.onQuickAccessNavigate,
            ),

            // Новости фитнес-центра
            const SizedBox(height: 12),
            NewsBannerWidget(onBannerTap: widget.onQuickAccessNavigate),

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

  void _navigateToMembershipDetail(dynamic membership) {
    widget.onQuickAccessNavigate('membership_detail', membership);
  }
}