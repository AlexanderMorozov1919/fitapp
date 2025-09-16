import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String color;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.color = 'blue',
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Color>> colorGradients = {
      'blue': [Colors.blue, Colors.lightBlue],
      'green': [Colors.green, Colors.lightGreen],
      'orange': [Colors.orange, Colors.deepOrangeAccent],
      'purple': [Colors.purple, Colors.deepPurpleAccent],
    };

    final gradientColors = colorGradients[color] ?? [Colors.blue, Colors.lightBlue];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}