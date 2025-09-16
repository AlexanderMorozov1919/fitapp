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
      padding: const EdgeInsets.only(top: 6),
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
                  size: 22,
                ),
                const SizedBox(height: 1),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 9,
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