import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final String activePage;
  final Function(String) onPageChanged;

  const NavigationBar({
    super.key,
    required this.activePage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'id': 'home', 'label': 'Главная', 'icon': Icons.home},
      {'id': 'schedule', 'label': 'Расписание', 'icon': Icons.calendar_today},
      {'id': 'trainers', 'label': 'Тренеры', 'icon': Icons.people},
      {'id': 'profile', 'label': 'Профиль', 'icon': Icons.person},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final isActive = activePage == item['id'];
          return GestureDetector(
            onTap: () => onPageChanged(item['id'] as String),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: isActive ? Colors.blue : Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.blue : Colors.grey[400],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}