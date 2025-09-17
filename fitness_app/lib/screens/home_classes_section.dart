import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';

class HomeClassesSection extends StatefulWidget {
  const HomeClassesSection({super.key});

  @override
  State<HomeClassesSection> createState() => _HomeClassesSectionState();
}

class _HomeClassesSectionState extends State<HomeClassesSection> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final availableDates = _getAvailableDates();
    final selectedDateClasses = MockDataService.groupClasses
        .where((classItem) =>
            classItem.startTime.year == _selectedDate.year &&
            classItem.startTime.month == _selectedDate.month &&
            classItem.startTime.day == _selectedDate.day)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Селектор дат
        _buildDateSelector(availableDates),
        const SizedBox(height: 16),
        
        // Список занятий
        selectedDateClasses.isEmpty
            ? _buildEmptyTodayClasses()
            : Column(
                children: selectedDateClasses
                    .map((classItem) => _buildClassItemSimple(classItem))
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

  Widget _buildDateSelector(List<DateTime> dates) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: dates.map((date) {
          final isSelected = _isSameDay(date, _selectedDate);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                _formatDateShort(date),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.blue.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<DateTime> _getAvailableDates() {
    final dates = <DateTime>{};
    for (final classItem in MockDataService.groupClasses) {
      final date = DateTime(
        classItem.startTime.year,
        classItem.startTime.month,
        classItem.startTime.day,
      );
      dates.add(date);
    }
    return dates.toList()..sort();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDateShort(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (_isSameDay(date, today)) return 'Сегодня';
    if (_isSameDay(date, tomorrow)) return 'Завтра';
    
    return '${date.day}.${date.month}';
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

  Widget _buildClassItemSimple(dynamic classItem) {
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
            '${classItem.maxParticipants - classItem.currentParticipants} мест',
            style: TextStyle(
              fontSize: 12,
              color: (classItem.maxParticipants - classItem.currentParticipants) > 0
                  ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}