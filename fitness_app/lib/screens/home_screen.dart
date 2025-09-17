import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import 'home_welcome_section.dart';
import 'home_quick_actions.dart';
import 'home_bookings_section.dart';
import 'home_classes_section.dart';
import 'home_membership_section.dart';
import 'home_statistics_section.dart';
import 'home_section_widget.dart';
import 'home_utils.dart';

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
  DateTime _selectedDate = DateTime.now();

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Фитнес Центр',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Приветствие и баланс
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: HomeWelcomeSection(user: user),
            ),
            const SizedBox(height: 1),

            // Быстрый доступ
            HomeSectionWidget(
              title: 'Быстрый доступ',
              isExpanded: _showQuickAccess,
              onToggle: () => setState(() => _showQuickAccess = !_showQuickAccess),
              child: HomeQuickActions(onQuickAccessNavigate: onQuickAccessNavigate),
            ),

            // Мои бронирования сегодня
            if (todayBookings.isNotEmpty) ...[
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
            HomeSectionWidget(
              title: 'Занятия сегодня',
              isExpanded: _showTodayClasses,
              onToggle: () => setState(() => _showTodayClasses = !_showTodayClasses),
              child: HomeClassesSection(),
            ),

            // Информация о действующем абонементе
            if (user.membership != null) ...[
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
            HomeSectionWidget(
              title: 'Статистика посещений',
              isExpanded: _showStatistics,
              onToggle: () => setState(() => _showStatistics = !_showStatistics),
              child: HomeStatisticsSection(),
            ),
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
        title: const Text('Отменить бронирование'),
        content: const Text('Вы уверены, что хотите отменить это бронирование?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Бронирование отменено'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Да, отменить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(dynamic booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Перенести бронирование'),
        content: const Text('Функция переноса бронирования будет доступна в ближайшее время.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}