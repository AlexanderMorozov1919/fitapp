import 'package:flutter/material.dart';

class HomeQuickActions extends StatelessWidget {
  final Function(String) onQuickAccessNavigate;

  const HomeQuickActions({super.key, required this.onQuickAccessNavigate});

  @override
  Widget build(BuildContext context) {
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
}