import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import '../../services/mock_data_service.dart';
import '../../screens/clietnt/calendar_filter.dart';

class RescheduleTrainingScreen extends StatefulWidget {
  final Booking training;

  const RescheduleTrainingScreen({super.key, required this.training});

  @override
  State<RescheduleTrainingScreen> createState() => _RescheduleTrainingScreenState();
}

class _RescheduleTrainingScreenState extends State<RescheduleTrainingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.training.startTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.training.startTime);
  }

  void _confirmReschedule() {
    if (_selectedTime != null) {
      // Создаем новое время начала и окончания тренировки
      final newStartTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      
      final duration = widget.training.endTime.difference(widget.training.startTime);
      final newEndTime = newStartTime.add(duration);

      // Обновляем тренировку через MockDataService
      MockDataService.updateEmployeeTrainingTime(
        widget.training.id,
        newStartTime,
        newEndTime,
      );
      
      showSuccessSnackBar(context, 'Тренировка перенесена на ${DateFormatters.formatDate(newStartTime)} ${_selectedTime!.format(context)}');
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

  // Получаем доступные временные слоты для сотрудника на выбранную дату
  List<TimeOfDay> get _availableTimes {
    final freeSlots = MockDataService.getEmployeeFreeTimeSlots(_selectedDate);
    final availableTimes = <TimeOfDay>[];

    for (final slot in freeSlots) {
      // Проверяем, достаточно ли длинный слот для тренировки
      final trainingDuration = widget.training.endTime.difference(widget.training.startTime);
      if (slot.endTime.difference(slot.startTime) >= trainingDuration) {
        // Добавляем все возможные времена начала в пределах свободного слота
        var currentTime = slot.startTime;
        while (currentTime.add(trainingDuration).isBefore(slot.endTime) || 
               currentTime.add(trainingDuration) == slot.endTime) {
          availableTimes.add(TimeOfDay.fromDateTime(currentTime));
          currentTime = currentTime.add(const Duration(minutes: 30));
        }
      }
    }

    return availableTimes;
  }

  // Проверяем, занято ли время (для отображения в сетке)
  bool _isTimeAvailable(TimeOfDay time) {
    return _availableTimes.any((availableTime) =>
        availableTime.hour == time.hour && availableTime.minute == time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Перенос тренировки',
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
          // Информация о тренировке
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
                  widget.training.title,
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
                      DateFormatters.formatDateDisplay(widget.training.startTime),
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
                      '${DateFormatters.formatTime(widget.training.startTime)}-${DateFormatters.formatTime(widget.training.endTime)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                if (widget.training.clientName != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Клиент: ${widget.training.clientName}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Календарный фильтр
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
                      children: _generateAllTimes().map((time) {
                        final isSelected = time == _selectedTime;
                        final isAvailable = _isTimeAvailable(time);
                        
                        return TimeSlotChip(
                          time: time,
                          isSelected: isSelected,
                          isOccupied: !isAvailable,
                          onTap: isAvailable ? () => setState(() => _selectedTime = isSelected ? null : time) : null,
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
                          text: 'Подтвердить перенос',
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

  // Генерация всех возможных временных слотов (8:00 - 20:00)
  List<TimeOfDay> _generateAllTimes() {
    final times = <TimeOfDay>[];
    for (int hour = 8; hour <= 20; hour++) {
      times.add(TimeOfDay(hour: hour, minute: 0));
      if (hour < 20) {
        times.add(TimeOfDay(hour: hour, minute: 30));
      }
    }
    return times;
  }

  List<DateTime> _getDatesWithAvailableTimes() {
    final dates = <DateTime>{};
    final today = DateTime.now();
    
    // Добавляем даты на 21 день вперед
    for (int i = 0; i <= 21; i++) {
      final date = today.add(Duration(days: i));
      // Проверяем, есть ли свободное время на эту дату
      final freeSlots = MockDataService.getEmployeeFreeTimeSlots(date);
      final trainingDuration = widget.training.endTime.difference(widget.training.startTime);
      
      // Если есть хотя бы один достаточно длинный свободный слот
      final hasAvailableTime = freeSlots.any((slot) =>
          slot.endTime.difference(slot.startTime) >= trainingDuration);
      
      if (hasAvailableTime) {
        dates.add(date);
      }
    }
    
    return dates.toList()..sort();
  }
}