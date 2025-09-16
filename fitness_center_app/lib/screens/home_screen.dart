
import 'package:flutter/material.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/utils/animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _showHistory = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  bool _showStats = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF667EEA),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.black, width: 12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 25,
                offset: Offset(0, 25),
              ),
            ],
          ),
          child: Column(
            children: [
              // Notch
              Container(
                width: 150,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              // Status Bar
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.white),
                        SizedBox(width: 5),
                        Icon(Icons.wifi, size: 14, color: Colors.white),
                        SizedBox(width: 5),
                        Icon(Icons.battery_full, size: 14, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.secondaryGradient,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Fitness Center Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.success, AppTheme.primary],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              'АМ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Александр Морозов',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Премиум подписка активна',
                                style: const TextStyle(
                                  color: Color(0xE6FFFFFF), // 90% opacity white
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Statistics Grid
                      Row(
                        children: [
                          Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-0.5, 0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeOut,
                                )),
                                child: const _StatCard(
                                  number: '12',
                                  label: 'Занятий в этом месяце',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.5, 0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeOut,
                                )),
                                child: const _StatCard(
                                  number: '5',
                                  label: 'Осталось посещений',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Upcoming Classes
                      const _SectionTitle(
                        icon: Icons.calendar_today,
                        title: 'Ближайшие занятия',
                      ),
                      const SizedBox(height: 15),
                      _ScheduleItem(
                        time: '10:00',
                        title: 'Групповая тренировка',
                        trainer: 'Тренер: Мария Петрова',
                        location: 'Зал B, 2 этаж',
                        status: 'Подтверждено',
                        statusColor: AppTheme.statusConfirmed,
                        onTap: () {
                          AppNavigator.pushBookingDetail(
                            context,
                            booking: Booking(
                              id: '1',
                              service: 'Групповая тренировка',
                              trainer: 'Мария Петрова',
                              date: '12.03.2024',
                              time: '10:00-11:00',
                              location: 'Зал B, 2 этаж',
                              status: 'Подтверждено',
                              price: 0,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _ScheduleItem(
                        time: '14:00',
                        title: 'Теннис (Корт 3)',
                        trainer: 'С партнером',
                        location: 'Корт 3',
                        status: 'Подтверждено',
                        statusColor: AppTheme.statusConfirmed,
                        onTap: () {
                          AppNavigator.pushBookingDetail(
                            context,
                            booking: Booking(
                              id: '2',
                              service: 'Теннис (Корт 3)',
                              trainer: 'С партнером',
                              date: '12.03.2024',
                              time: '14:00-15:00',
                              location: 'Корт 3',
                              status: 'Подтверждено',
                              price: 1200,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      // Subscriptions
                      const _SectionTitle(
                        icon: Icons.confirmation_number,
                        title: 'Ваши абонементы',
                      ),
                      const SizedBox(height: 15),
                      _SubscriptionCard(),
                      const SizedBox(height: 25),
                      // Quick Actions
                      const _SectionTitle(
                        icon: Icons.bolt,
                        title: 'Быстрые действия',
                      ),
                      const SizedBox(height: 15),
                      const _QuickActionsGrid(),
                      const SizedBox(height: 25),
                      // History Section
                      _HistorySection(
                        showHistory: _showHistory,
                        onToggle: () => setState(() => _showHistory = !_showHistory),
                      ),
                      const SizedBox(height: 25),
                      // Stats Section
                      // _StatsSection будет добавлен позже
                    ],
                  ),
                ),
              ),
              // Bottom Navigation
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppTheme.border)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: _buildNavItem(Icons.home, 'Главная', true),
                    ),
                    GestureDetector(
                      onTap: () => AppNavigator.pushBookService(context),
                      child: _buildNavItem(Icons.calendar_today, 'Записаться', false),
                    ),
                    GestureDetector(
                      onTap: () => AppNavigator.pushTrainers(context),
                      child: _buildNavItem(Icons.fitness_center, 'Тренеры', false),
                    ),
                    GestureDetector(
                      onTap: () => AppNavigator.pushProfile(context),
                      child: _buildNavItem(Icons.person, 'Профиль', false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.pushBookService(context),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.gray,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.dark, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.dark,
          ),
        ),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final String trainer;
  final String location;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const _ScheduleItem({
    required this.time,
    required this.title,
    required this.trainer,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border(left: BorderSide(color: AppTheme.primary, width: 5)),
        ),
        child: Row(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trainer,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -10,
            right: -10,
            child: _PriceTag(label: 'Активен'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All-inclusive Премиум',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '12 990 ₽/мес',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '• Неограниченный доступ к тренажерам\n'
                '• 12 групповых занятий\n'
                '• 8 часов тенниса\n'
                '• 2 персональные тренировки',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Действует до: 15.04.2024',
                style: const TextStyle(
                  color: Color(0xE6FFFFFF), // 90% opacity white
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  AppNavigator.pushRenewSubscription(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sync, size: 18),
                    SizedBox(width: 8),
                    Text('Продлить'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final String label;

  const _PriceTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.warning,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _QuickActionItem(
          icon: Icons.calendar_today,
          label: 'Записаться',
          onTap: () => AppNavigator.pushBookService(context),
        ),
        _QuickActionItem(
          icon: Icons.directions_car,
          label: 'Парковка',
          onTap: () => AppNavigator.pushParking(context),
        ),
        _QuickActionItem(
          icon: Icons.fitness_center,
          label: 'Тренеры',
          onTap: () => AppNavigator.pushTrainers(context),
        ),
        _QuickActionItem(
          icon: Icons.lock,
          label: 'Шкафчик',
          onTap: () => AppNavigator.pushLocker(context),
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppTheme.secondaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.dark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  final bool showHistory;
  final VoidCallback onToggle;

  const _HistorySection({
    required this.showHistory,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppTheme.light,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.history, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'История бронирований',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Icon(
                  showHistory ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showHistory) ...[
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              AppNavigator.pushBookingDetail(
                context,
                booking: Booking(
                  id: '3',
                  service: 'Теннис (Корт 1)',
                  trainer: 'С партнером',
                  date: '12.03.2024',
                  time: '10:00-11:00',
                  location: 'Корт 1',
                  status: 'Завершено',
                  price: 1200,
                ),
              );
            },
            child: _buildHistoryItem('Теннис (Корт 1)', '12.03.24 • 10:00-11:00', 'Завершено', AppTheme.statusConfirmed),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              AppNavigator.pushBookingDetail(
                context,
                booking: Booking(
                  id: '4',
                  service: 'Йога',
                  trainer: 'Анна Иванова',
                  date: '10.03.2024',
                  time: '09:00-10:00',
                  location: 'Зал A, 1 этаж',
                  status: 'Завершено',
                  price: 0,
                ),
              );
            },
            child: _buildHistoryItem('Йога', '10.03.24 • 09:00-10:00', 'Завершено', AppTheme.statusConfirmed),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              AppNavigator.pushBookingDetail(
                context,
                booking: Booking(
                  id: '5',
                  service: 'Персональная тренировка',
                  trainer: 'Иван Сидоров',
                  date: '08.03.2024',
                  time: '14:00-15:00',
                  location: 'Зал C, 3 этаж',
                  status: 'Отменено',
                  price: 2500,
                ),
              );
            },
            child: _buildHistoryItem('Персональная тренировка', '08.03.24 • 14:00-15:00', 'Отменено', AppTheme.statusCancelled),
          ),
        ],
      ],
    );
  }
}

// В конец класса _HomeScreenState добавить методы:

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? AppTheme.primary : AppTheme.gray,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppTheme.primary : AppTheme.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String date, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.gray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
