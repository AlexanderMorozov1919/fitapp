import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import 'calendar_filter.dart';
import '../../services/mock_data_service.dart';
import 'tennis_reschedule_screen.dart';

class RescheduleBookingScreen extends StatelessWidget {
  final Booking booking;

  const RescheduleBookingScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Для теннисных кортов используем специализированный экран
    if (booking.type == BookingType.tennisCourt) {
      return TennisRescheduleScreen(booking: booking);
    }
    
    // Для других типов бронирования используем общий экран
    return _RescheduleBookingScreen(booking: booking);
  }
}

class _RescheduleBookingScreen extends StatefulWidget {
  final Booking booking;

  const _RescheduleBookingScreen({required this.booking});

  @override
  State<_RescheduleBookingScreen> createState() => __RescheduleBookingScreenState();
}

class __RescheduleBookingScreenState extends State<_RescheduleBookingScreen> {
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
      // Создаем новое время начала и окончания бронирования
      final newStartTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      
      final duration = widget.booking.endTime.difference(widget.booking.startTime);
      final newEndTime = newStartTime.add(duration);

      // Обновляем бронирование через MockDataService
      MockDataService.updateUserBookingTime(
        widget.booking.id,
        newStartTime,
        newEndTime,
      );
      
      showSuccessSnackBar(context, 'Время бронирования изменено на ${DateFormatters.formatDate(_selectedDate)} ${_selectedTime!.format(context)}');
      final navigationService = NavigationService.of(context);
      navigationService?.navigateToHome();
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
                        
                        return TimeSlotChip(
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
                        child: PrimaryButton(
                          text: 'Подтвердить изменение',
                          onPressed: _selectedTime != null ? _confirmReschedule : () {},
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
