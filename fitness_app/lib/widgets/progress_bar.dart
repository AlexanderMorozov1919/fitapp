import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String label;
  final int current;
  final int total;
  final String color;

  const ProgressBar({
    super.key,
    required this.label,
    required this.current,
    required this.total,
    this.color = 'blue',
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Color>> colorGradients = {
      'blue': [Colors.blue, Colors.lightBlue],
      'green': [Colors.green, Colors.lightGreen],
      'orange': [Colors.orange, Colors.deepOrangeAccent],
    };

    final gradientColors = colorGradients[color] ?? [Colors.blue, Colors.lightBlue];
    final percentage = (current / total).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$current/$total',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: MediaQuery.of(context).size.width * percentage,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}