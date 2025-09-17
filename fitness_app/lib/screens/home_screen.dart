import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/user_model.dart';
import '../models/trainer_model.dart';
import './tennis_booking_screen.dart';
import './schedule_screen.dart';
import './trainers_screen.dart';
import './membership_screen.dart';
import './payment_screen.dart';
import './locker_screen.dart';
import '../widgets/phone_frame.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) onQuickAccessNavigate;

  const HomeScreen({super.key, required this.onQuickAccessNavigate});

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;
    final upcomingBookings = MockDataService.userBookings
        .where((booking) => booking.isUpcoming)
        .take(3)
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Приветствие и баланс
            _buildWelcomeSection(user),
            const SizedBox(height: 24),

            // Быстрый доступ
            const Text(
              'Быстрый доступ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // Предстоящие записи
            if (upcomingBookings.isNotEmpty) ...[
              _buildUpcomingBookings(upcomingBookings),
              const SizedBox(height: 24),
            ],

            // Групповые занятия сегодня
            _buildTodayClasses(),
            const SizedBox(height: 24),

            // Статистика посещений
            _buildStatistics(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(User user) {
    return Row(
      children: [
        // Аватар
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: user.photoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    user.photoUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.blue,
                ),
        ),
        const SizedBox(width: 16),

        // Информация
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Добро пожаловать,',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                user.firstName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user.membership != null) ...[
                const SizedBox(height: 4),
                Text(
                  user.membership!.type,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Баланс
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${user.balance} руб.',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildQuickAction(
          Icons.sports_tennis,
          'Теннис',
          Colors.green,
          () {
            onQuickAccessNavigate('tennis');
          },
        ),
        _buildQuickAction(
          Icons.calendar_today,
          'Расписание',
          Colors.blue,
          () {
            onQuickAccessNavigate('trainers');
          },
        ),
        _buildQuickAction(
          Icons.people,
          'Тренеры',
          Colors.orange,
          () {
            onQuickAccessNavigate('trainers');
          },
        ),
        _buildQuickAction(
          Icons.credit_card,
          'Абонемент',
          Colors.purple,
          () {
            onQuickAccessNavigate('membership');
          },
        ),
        _buildQuickAction(
          Icons.account_balance_wallet,
          'Пополнить',
          Colors.teal,
          () {
            onQuickAccessNavigate('payment');
          },
        ),
        _buildQuickAction(
          Icons.lock,
          'Шкафчик',
          Colors.brown,
          () {
            onQuickAccessNavigate('locker');
          },
        ),
        _buildQuickAction(
          Icons.book_online,
          'Мои записи',
          Colors.indigo,
          () {
            // Навигация уже реализована через нижнее меню
          },
        ),
        _buildQuickAction(
          Icons.star,
          'Рейтинги',
          Colors.amber,
          () {
            onQuickAccessNavigate('trainers');
          },
        ),
      ],
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings(List<dynamic> bookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ближайшие записи',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...bookings.map((booking) => _buildBookingItem(booking)).toList(),
      ],
    );
  }

  Widget _buildBookingItem(dynamic booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_formatDate(booking.startTime)} • ${_formatTime(booking.startTime)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: booking.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              booking.statusText,
              style: TextStyle(
                fontSize: 10,
                color: booking.statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayClasses() {
    final todayClasses = MockDataService.groupClasses
        .where((classItem) =>
            classItem.startTime.year == DateTime.now().year &&
            classItem.startTime.month == DateTime.now().month &&
            classItem.startTime.day == DateTime.now().day)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Занятия сегодня',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        todayClasses.isEmpty
            ? _buildEmptyTodayClasses()
            : Column(
                children: todayClasses
                    .map((classItem) => _buildClassItem(classItem))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildEmptyTodayClasses() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          Icon(Icons.calendar_today, size: 32, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Сегодня нет занятий',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassItem(GroupClass classItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classItem.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_formatTime(classItem.startTime)} • ${classItem.trainerName}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${classItem.spotsLeft} мест',
            style: TextStyle(
              fontSize: 12,
              color: classItem.isFull ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статистика посещений',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '12',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Посещений',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '8',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Теннис',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '4',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Групповые',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}