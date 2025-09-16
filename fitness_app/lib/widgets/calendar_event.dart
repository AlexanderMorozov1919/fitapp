import 'package:flutter/material.dart';

class CalendarEvent extends StatelessWidget {
  final String title;
  final String time;
  final String location;
  final String trainer;
  final String color;
  final Function()? onTap;

  const CalendarEvent({
    super.key,
    required this.title,
    required this.time,
    required this.location,
    required this.trainer,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Color>> colorGradients = {
      'blue': [Colors.blue.shade400, Colors.blue.shade300],
      'green': [Colors.green.shade400, Colors.green.shade300],
      'orange': [Colors.orange.shade400, Colors.orange.shade300],
      'purple': [Colors.purple.shade400, Colors.purple.shade300],
      'red': [Colors.red.shade400, Colors.red.shade300],
      'teal': [Colors.teal.shade400, Colors.teal.shade300],
    };

    final gradientColors = colorGradients[color] ?? [Colors.blue.shade400, Colors.blue.shade300];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$location • $time',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 12,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  trainer,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}