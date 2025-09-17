import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';

class CalendarFilter extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<DateTime> datesWithBookings;

  const CalendarFilter({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.datesWithBookings,
  });

  @override
  State<CalendarFilter> createState() => _CalendarFilterState();
}

class _CalendarFilterState extends State<CalendarFilter> {
  late DateTime _selectedDate;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(CalendarFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate;
      });
      _scrollToSelectedDate();
    }
  }

  void _scrollToSelectedDate() {
    final index = _getDateIndex(_selectedDate);
    final itemWidth = 70.0;
    
    final offset = index * itemWidth - MediaQuery.of(context).size.width / 2 + itemWidth / 2;
    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  int _getDateIndex(DateTime date) {
    final dates = _generateDateRange();
    for (int i = 0; i < dates.length; i++) {
      if (dates[i].year == date.year &&
          dates[i].month == date.month &&
          dates[i].day == date.day) {
        return i;
      }
    }
    return 0; // Возвращаем индекс сегодняшнего дня по умолчанию
  }

  List<DateTime> _generateDateRange() {
    final today = DateTime.now();
    final dates = <DateTime>[];
    
    // Сегодняшний день первый
    dates.add(today);
    
    // 21 день вперед (включая сегодняшний день всего 22 дня)
    for (int i = 1; i <= 21; i++) {
      dates.add(today.add(Duration(days: i)));
    }
    
    return dates;
  }

  bool _hasBookings(DateTime date) {
    return widget.datesWithBookings.any((bookingDate) =>
        bookingDate.year == date.year &&
        bookingDate.month == date.month &&
        bookingDate.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDateRange();

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _selectedDate.year == date.year &&
              _selectedDate.month == date.month &&
              _selectedDate.day == date.day;
          final hasBookings = _hasBookings(date);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
              widget.onDateSelected(date);
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : hasBookings
                          ? AppColors.primary.withOpacity(0.3)
                          : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayName(date),
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasBookings)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Сегодня';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Завтра';
    } else {
      return DateFormatters.getWeekdayName(date);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}