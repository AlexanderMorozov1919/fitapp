import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import 'calendar_filter.dart';

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
        // Календарь фильтр (как в "Мои бронирования")
        CalendarFilter(
          selectedDate: _selectedDate,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
          datesWithBookings: availableDates,
        ),
        const SizedBox(height: 16),
        
        // Заголовок с выбранной датой
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            _getSectionTitle(_selectedDate),
            style: AppTextStyles.headline5.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Список занятий
        selectedDateClasses.isEmpty
            ? _buildEmptyTodayClasses()
            : Column(
                children: selectedDateClasses
                    .map((classItem) => _buildClassItem(classItem))
                    .toList(),
              ),
        const SizedBox(height: 12),
        
        // Кнопка полного расписания
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Навигация к полному расписанию
            },
            style: AppStyles.secondaryButtonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.all(AppColors.primary),
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              )),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Полное расписания',
                  style: AppTextStyles.buttonSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getSectionTitle(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Занятия сегодня';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Занятия завтра';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Занятия вчера';
    } else {
      return 'Занятия ${date.day}.${date.month}';
    }
  }

  Widget _buildClassItem(dynamic classItem) {
    final availableSpots = classItem.maxParticipants - classItem.currentParticipants;
    final isAlmostFull = availableSpots <= 2;
    final isFull = availableSpots == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppStyles.paddingMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Иконка занятия
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: AppStyles.borderRadiusFull,
            ),
            child: Icon(
              Icons.fitness_center,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          
          // Информация о занятии
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classItem.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatTime(classItem.startTime)} • ${classItem.trainerName}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Индикатор свободных мест
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isFull
                  ? AppColors.error.withOpacity(0.1)
                  : isAlmostFull
                      ? AppColors.warning.withOpacity(0.1)
                      : AppColors.success.withOpacity(0.1),
              borderRadius: AppStyles.borderRadiusSm,
              border: Border.all(
                color: isFull
                    ? AppColors.error.withOpacity(0.3)
                    : isAlmostFull
                        ? AppColors.warning.withOpacity(0.3)
                        : AppColors.success.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              isFull ? 'Нет мест' : '$availableSpots мест',
              style: AppTextStyles.overline.copyWith(
                color: isFull
                    ? AppColors.error
                    : isAlmostFull
                        ? AppColors.warning
                        : AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTodayClasses() {
    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppStyles.borderRadiusLg,
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today,
            size: 40,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            'Сегодня нет занятий',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Посмотрите расписание на другие дни',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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

  String _formatDay(DateTime date) {
    final days = ['ВС', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'];
    return days[date.weekday % 7];
  }

  String _formatDateShort(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (_isSameDay(date, today)) return 'Сегодня';
    if (_isSameDay(date, tomorrow)) return 'Завтра';
    
    return '${date.day}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}