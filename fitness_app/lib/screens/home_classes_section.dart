import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import 'calendar_filter.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';

class HomeClassesSection extends StatefulWidget {
  final Function(dynamic) onClassTap;

  const HomeClassesSection({super.key, required this.onClassTap});

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
        // Календарь фильтр
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
        
        // Список занятий
        selectedDateClasses.isEmpty
            ? _buildEmptyTodayClasses()
            : Column(
                children: selectedDateClasses
                    .map((classItem) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildClassItem(classItem),
                        ))
                    .toList(),
              ),
        
      ],
    );
  }

  Widget _buildClassItem(dynamic classItem) {
    final availableSpots = classItem.maxParticipants - classItem.currentParticipants;
    final isAlmostFull = availableSpots <= 2;
    final isFull = availableSpots == 0;

    Color statusColor;
    if (isFull) {
      statusColor = AppColors.error;
    } else if (isAlmostFull) {
      statusColor = AppColors.warning;
    } else {
      statusColor = AppColors.success;
    }

    return StatefulBuilder(
      builder: (context, setState) {
        var isHovered = false;
        var isPressed = false;
        
        return GestureDetector(
          onTap: () => widget.onClassTap(classItem),
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() {
              isHovered = false;
              isPressed = false;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.identity()
                ..scale(isHovered ? 1.02 : 1.0)
                ..translate(0.0, isPressed ? 1.0 : 0.0),
              decoration: BoxDecoration(
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: isHovered
                  ? AppColors.shadowLg
                  : isPressed
                    ? AppColors.shadowSm
                    : AppColors.shadowMd,
              ),
              child: AppCard(
                padding: AppStyles.paddingLg,
                backgroundColor: isHovered
                  ? AppColors.primary.withOpacity(0.05)
                  : isPressed
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Основная информация
                    Row(
                      children: [
                        // Иконка занятия
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: AppStyles.borderRadiusLg,
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Детали занятия
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                classItem.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${DateFormatters.formatTime(classItem.startTime)} • ${classItem.trainerName}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Индикатор свободных мест
                        StatusBadge(
                          text: isFull ? 'Нет мест' : '$availableSpots мест',
                          color: statusColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyTodayClasses() {
    return EmptyState(
      icon: Icons.calendar_today,
      title: 'Сегодня нет занятий',
      subtitle: 'Посмотрите расписание на другие дни',
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
}