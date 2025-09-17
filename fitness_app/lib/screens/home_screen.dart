import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/user_model.dart';
import '../models/trainer_model.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onQuickAccessNavigate;

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
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Приветствие и баланс
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: _buildWelcomeSection(user),
            ),
            const SizedBox(height: 1),

            // Быстрый доступ
            _buildSection(
              title: 'Быстрый доступ',
              isExpanded: _showQuickAccess,
              onToggle: () => setState(() => _showQuickAccess = !_showQuickAccess),
              child: _buildQuickActions(context),
            ),

            // Предстоящие записи
            if (upcomingBookings.isNotEmpty) ...[
              _buildSection(
                title: 'Ближайшие записи',
                isExpanded: _showUpcomingBookings,
                onToggle: () => setState(() => _showUpcomingBookings = !_showUpcomingBookings),
                child: _buildUpcomingBookingsContent(upcomingBookings),
              ),
            ],

            // Групповые занятия сегодня
            _buildSection(
              title: 'Занятия сегодня',
              isExpanded: _showTodayClasses,
              onToggle: () => setState(() => _showTodayClasses = !_showTodayClasses),
              child: _buildTodayClassesContent(),
            ),

            // Информация о действующем абонементе
            if (user.membership != null) ...[
              _buildSection(
                title: 'Ваш абонемент',
                isExpanded: _showMembershipInfo,
                onToggle: () => setState(() => _showMembershipInfo = !_showMembershipInfo),
                child: _buildMembershipInfoContent(user),
              ),
            ],

            // Статистика посещений
            _buildSection(
              title: 'Статистика посещений',
              isExpanded: _showStatistics,
              onToggle: () => setState(() => _showStatistics = !_showStatistics),
              child: _buildStatisticsContent(),
            ),
          ],
        ),
      ),
    );
  }

  void onQuickAccessNavigate(String screenKey) {
    widget.onQuickAccessNavigate(screenKey);
  }

  Widget _buildSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Заголовок секции с кнопкой сворачивания
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                  onPressed: onToggle,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Контент секции
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: child,
            ),
        ],
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

  Widget _buildUpcomingBookingsContent(List<dynamic> bookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...bookings.map((booking) => _buildBookingItem(booking)).toList(),
        if (bookings.isNotEmpty)
          const SizedBox(height: 8),
        if (bookings.isNotEmpty)
          Center(
            child: TextButton(
              onPressed: () {
                // Навигация к экрану всех записей
              },
              child: const Text(
                'Все записи →',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTodayClassesContent() {
    final todayClasses = MockDataService.groupClasses
        .where((classItem) =>
            classItem.startTime.year == DateTime.now().year &&
            classItem.startTime.month == DateTime.now().month &&
            classItem.startTime.day == DateTime.now().day)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        todayClasses.isEmpty
            ? _buildEmptyTodayClasses()
            : Column(
                children: todayClasses
                    .map((classItem) => _buildClassItem(classItem))
                    .toList(),
              ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              // Навигация к полному расписанию
            },
            child: const Text(
              'Полное расписание →',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipInfoContent(User user) {
    if (user.membership == null) {
      return Container(); // Не показываем, если нет абонемента
    }

    final membership = user.membership!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      membership.type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMembershipDetailItem(
                '📅 Действует до',
                _formatDateFull(membership.endDate),
              ),
              _buildMembershipDetailItem(
                '⏰ Осталось дней',
                '${membership.daysRemaining}',
              ),
              if (membership.remainingVisits > 0)
                _buildMembershipDetailItem(
                  '🎯 Осталось посещений',
                  '${membership.remainingVisits}',
                ),
              if (membership.remainingVisits == -1)
                _buildMembershipDetailItem(
                  '♾️ Посещения',
                  'Неограниченные',
                ),
              if (membership.autoRenew)
                _buildMembershipDetailItem(
                  '🔄 Автопродление',
                  'Включено',
                  color: Colors.green,
                ),
              const SizedBox(height: 8),
              const Text(
                'Включенные услуги:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              _buildMembershipFeatures(membership),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              onQuickAccessNavigate('membership');
            },
            child: const Text(
              'Управление абонементом →',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipDetailItem(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('12', 'Посещений'),
            _buildStatItem('8', 'Теннис'),
            _buildStatItem('4', 'Групповые'),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              // Навигация к детальной статистике
            },
            child: const Text(
              'Подробная статистика →',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingBookings(List<dynamic> bookings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ближайшие записи',
          style: TextStyle(
            fontSize: 18,
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
            fontSize: 18,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Статистика посещений',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
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


  Widget _buildMembershipFeatures(Membership membership) {
    final features = <Widget>[];
    
    // Проверяем включенные услуги
    if (membership.includedServices.contains('gym')) {
      features.add(_buildFeatureItem('🏋️ Тренажерный зал'));
    }
    if (membership.includedServices.contains('group_classes')) {
      features.add(_buildFeatureItem('👥 Групповые занятия'));
    }
    if (membership.includedServices.contains('tennis')) {
      features.add(_buildFeatureItem('🎾 Теннисные корты'));
    }
    if (membership.includedServices.contains('pool')) {
      features.add(_buildFeatureItem('🏊 Бассейн'));
    }
    if (membership.includedServices.contains('yoga')) {
      features.add(_buildFeatureItem('🧘 Йога'));
    }

    // Добавляем информацию о неограниченных посещениях
    if (membership.remainingVisits == -1) {
      features.add(_buildFeatureItem('♾️ Неограниченные посещения'));
    } else if (membership.remainingVisits > 0) {
      features.add(_buildFeatureItem('📊 Посещений: ${membership.remainingVisits}'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features,
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatDateFull(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}