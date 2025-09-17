import 'package:flutter/material.dart';

class HomeStatisticsSection extends StatelessWidget {
  const HomeStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
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

  Widget _buildStatItem(String value, String label) {
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
}