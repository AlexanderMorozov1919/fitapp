import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/widgets/app_container.dart';

class ParkingHistoryScreen extends StatefulWidget {
  const ParkingHistoryScreen({super.key});

  @override
  State<ParkingHistoryScreen> createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  final List<Map<String, dynamic>> _parkingHistory = [
    {
      'id': '1',
      'zone': 'A',
      'spot': 15,
      'startTime': DateTime(2024, 3, 10, 14, 0),
      'endTime': DateTime(2024, 3, 10, 16, 0),
      'duration': const Duration(hours: 2),
      'status': 'completed',
      'cost': 0,
    },
    {
      'id': '2',
      'zone': 'B',
      'spot': 8,
      'startTime': DateTime(2024, 3, 9, 18, 30),
      'endTime': DateTime(2024, 3, 9, 20, 30),
      'duration': const Duration(hours: 2),
      'status': 'completed',
      'cost': 0,
    },
    {
      'id': '3',
      'zone': 'C',
      'spot': 22,
      'startTime': DateTime(2024, 3, 8, 10, 0),
      'endTime': DateTime(2024, 3, 8, 12, 30),
      'duration': const Duration(hours: 2, minutes: 30),
      'status': 'completed',
      'cost': 0,
    },
    {
      'id': '4',
      'zone': 'A',
      'spot': 5,
      'startTime': DateTime(2024, 3, 7, 16, 0),
      'endTime': DateTime(2024, 3, 7, 18, 0),
      'duration': const Duration(hours: 2),
      'status': 'completed',
      'cost': 0,
    },
  ];

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hoursч $minutesм';
    } else {
      return '$minutesм';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        children: [
          // Header with back button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => AppNavigator.pop(),
                ),
                const SizedBox(width: 10),
                const Text(
                  'История парковки',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Statistics summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.light,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Всего сеансов',
                    _parkingHistory.length.toString(),
                    Icons.history,
                  ),
                  _buildStatItem(
                    'Общее время',
                    _formatDuration(_calculateTotalTime()),
                    Icons.timer,
                  ),
                  _buildStatItem(
                    'Экономия',
                    '${_calculateTotalSavings()} ₽',
                    Icons.savings,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // History list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _parkingHistory.length,
              itemBuilder: (context, index) {
                final booking = _parkingHistory[index];
                return _buildHistoryItem(booking);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppTheme.primary),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Место ${booking['zone']}-${booking['spot']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking['status']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(booking['status']),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildHistoryDetailItem(
            Icons.calendar_today,
            _formatDateTime(booking['startTime']),
          ),
          _buildHistoryDetailItem(
            Icons.timer,
            '${_formatDateTime(booking['endTime'])} (${_formatDuration(booking['duration'])})',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Стоимость: ${booking['cost']} ₽',
                style: TextStyle(
                  fontSize: 14,
                  color: booking['cost'] == 0 ? AppTheme.success : AppTheme.dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (booking['cost'] == 0)
                const Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: AppTheme.success),
                    SizedBox(width: 4),
                    Text(
                      'Бесплатно',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.gray),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.gray,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppTheme.success;
      case 'active':
        return AppTheme.primary;
      case 'cancelled':
        return Colors.red;
      default:
        return AppTheme.gray;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Завершено';
      case 'active':
        return 'Активно';
      case 'cancelled':
        return 'Отменено';
      default:
        return status;
    }
  }

  Duration _calculateTotalTime() {
    Duration total = Duration.zero;
    for (final booking in _parkingHistory) {
      total += booking['duration'] as Duration;
    }
    return total;
  }

  int _calculateTotalSavings() {
    // Assuming 100 rubles per hour for parking
    const hourlyRate = 100;
    int totalMinutes = _calculateTotalTime().inMinutes;
    return (totalMinutes * hourlyRate) ~/ 60;
  }
}