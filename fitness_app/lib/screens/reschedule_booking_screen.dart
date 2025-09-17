import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';
import '../main.dart';
import 'calendar_filter.dart';

class RescheduleBookingScreen extends StatefulWidget {
  final Booking booking;

  const RescheduleBookingScreen({super.key, required this.booking});

  @override
  State<RescheduleBookingScreen> createState() => _RescheduleBookingScreenState();
}

class _RescheduleBookingScreenState extends State<RescheduleBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  final List<TimeOfDay> _allTimes = [
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

  // Моковые данные для занятых временных слотов
  List<TimeOfDay> get _occupiedTimes {
    // Для примера: заняты утренние и вечерние часы
    return [
      TimeOfDay(hour: 8, minute: 0),
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 18, minute: 0),
      TimeOfDay(hour: 19, minute: 0),
      TimeOfDay(hour: 20, minute: 0),
    ];
  }

  List<TimeOfDay> get _availableTimes {
    return _allTimes.where((time) => !_isTimeOccupied(time)).toList();
  }

  bool _isTimeOccupied(TimeOfDay time) {
    return _occupiedTimes.any((occupiedTime) =>
        occupiedTime.hour == time.hour && occupiedTime.minute == time.minute);
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.booking.startTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.booking.startTime);
  }

  void _confirmReschedule() {
    if (_selectedTime != null) {
      showSuccessSnackBar(context, 'Время бронирования изменено на ${DateFormatters.formatDate(_selectedDate)} ${_selectedTime!.format(context)}');
      final navigationService = NavigationService.of(context);
      navigationService?.onBack();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Изменение времени',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final navigationService = NavigationService.of(context);
            navigationService?.onBack();
          },
        ),
      ),
      body: Column(
        children: [
          // Информация о бронировании
          Container(
            padding: AppStyles.paddingLg,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppColors.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.booking.title,
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatters.formatDateDisplay(widget.booking.startTime),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormatters.formatTime(widget.booking.startTime)}-${DateFormatters.formatTime(widget.booking.endTime)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Календарный фильтр как на главной странице
          CalendarFilter(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _selectedTime = null;
              });
            },
            datesWithBookings: _getDatesWithAvailableTimes(),
          ),

          const SizedBox(height: 16),

          // Выбор времени
          Expanded(
            child: Padding(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите время:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: _allTimes.map((time) {
                        final isSelected = time == _selectedTime;
                        final isOccupied = _isTimeOccupied(time);
                        
                        return _TimeSlotChip(
                          time: time,
                          isSelected: isSelected,
                          isOccupied: isOccupied,
                          onTap: isOccupied ? null : () => setState(() => _selectedTime = isSelected ? null : time),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Легенда доступности
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Свободно',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Занято',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Кнопки действий
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Назад',
                          onPressed: () {
                            final navigationService = NavigationService.of(context);
                            navigationService?.onBack();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Подтвердить изменение',
                          onPressed: _confirmReschedule,
                          isEnabled: _selectedTime != null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _getDatesWithAvailableTimes() {
    final dates = <DateTime>{};
    final today = DateTime.now();
    
    // Добавляем даты на 21 день вперед (как в CalendarFilter)
    for (int i = 0; i <= 21; i++) {
      final date = today.add(Duration(days: i));
      dates.add(date);
    }
    
    return dates.toList()..sort();
  }
}

/// Кастомный виджет для отображения временного слота с индикацией занятости
class _TimeSlotChip extends StatelessWidget {
  final TimeOfDay time;
  final bool isSelected;
  final bool isOccupied;
  final VoidCallback? onTap;

  const _TimeSlotChip({
    required this.time,
    required this.isSelected,
    required this.isOccupied,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isOccupied
                  ? AppColors.background
                  : Colors.white,
          borderRadius: AppStyles.borderRadiusFull,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isOccupied
                    ? AppColors.border
                    : AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isOccupied ? null : AppColors.shadowSm,
        ),
        child: Center(
          child: Text(
            time.format(context),
            style: AppTextStyles.caption.copyWith(
              color: isSelected
                  ? Colors.white
                  : isOccupied
                      ? AppColors.textTertiary
                      : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}