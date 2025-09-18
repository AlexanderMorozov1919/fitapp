import 'package:flutter/material.dart';
import '../models/trainer_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';

class DateTimeSelectionDialog extends StatefulWidget {
  final Trainer trainer;
  final String serviceName;
  final double price;
  final Function(DateTime, TimeOfDay) onDateTimeSelected;

  const DateTimeSelectionDialog({
    super.key,
    required this.trainer,
    required this.serviceName,
    required this.price,
    required this.onDateTimeSelected,
  });

  @override
  State<DateTimeSelectionDialog> createState() => _DateTimeSelectionDialogState();
}

class _DateTimeSelectionDialogState extends State<DateTimeSelectionDialog> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  final List<TimeOfDay> _availableTimes = [
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Выбор даты и времени',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            '${widget.trainer.fullName} • ${widget.serviceName}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Выбор даты
          Text(
            'Дата тренировки:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          _buildDateSelector(),
          const SizedBox(height: 24),

          // Выбор времени
          Text(
            'Время тренировки:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          _buildTimeSelector(),
          const SizedBox(height: 24),

          // Стоимость
          Container(
            padding: AppStyles.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: AppStyles.borderRadiusLg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Стоимость:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${widget.price.toInt()} ₽',
                  style: AppTextStyles.price.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Отмена',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Продолжить',
                  onPressed: _selectedTime != null ? _proceedToConfirmation : () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final today = DateTime.now();
    final dates = List.generate(14, (index) => today.add(Duration(days: index)));

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, _selectedDate);
          final isToday = _isSameDay(date, today);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _selectedTime = null;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: AppStyles.borderRadiusLg,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.day.toString(),
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormatters.getMonthName(date).substring(0, 3),
                    style: AppTextStyles.overline.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'сегодня',
                        style: AppTextStyles.overline.copyWith(
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontSize: 8,
                        ),
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

  Widget _buildTimeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableTimes.map((time) {
        final isSelected = time == _selectedTime;
        final isAvailable = _isTimeAvailable(time);

        return GestureDetector(
          onTap: isAvailable
              ? () {
                  setState(() {
                    _selectedTime = isSelected ? null : time;
                  });
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isAvailable
                      ? AppColors.background
                      : AppColors.background.withOpacity(0.5),
              borderRadius: AppStyles.borderRadiusLg,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : isAvailable
                        ? AppColors.border
                        : AppColors.border.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _formatTime(time),
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isTimeAvailable(TimeOfDay time) {
    // Простая проверка доступности времени
    // В реальном приложении нужно проверять расписание тренера
    final now = TimeOfDay.now();
    final selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      time.hour,
      time.minute,
    );

    if (_isSameDay(_selectedDate, DateTime.now())) {
      return time.hour > now.hour || (time.hour == now.hour && time.minute > now.minute);
    }

    return selectedDateTime.isAfter(DateTime.now());
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _proceedToConfirmation() {
    if (_selectedTime != null) {
      final selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      widget.onDateTimeSelected(_selectedDate, _selectedTime!);
    }
  }
}