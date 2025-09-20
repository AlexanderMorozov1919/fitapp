import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../models/notification_model.dart';
import '../../services/mock_data_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import 'calendar_filter.dart';

class TennisRescheduleScreen extends StatefulWidget {
  final Booking booking;

  const TennisRescheduleScreen({super.key, required this.booking});

  @override
  State<TennisRescheduleScreen> createState() => _TennisRescheduleScreenState();
}

class _TennisRescheduleScreenState extends State<TennisRescheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  bool _isProcessing = false;

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

  TennisCourt? _court;
  double _originalPrice = 0;
  double _newPrice = 0;
  double _priceDifference = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.booking.startTime;
    _selectedStartTime = TimeOfDay.fromDateTime(widget.booking.startTime);
    _selectedEndTime = TimeOfDay.fromDateTime(widget.booking.endTime);
    
    // Находим корт по номеру из бронирования
    _court = MockDataService.tennisCourts.firstWhere(
      (court) => court.number == widget.booking.courtNumber,
      orElse: () => MockDataService.tennisCourts.first,
    );
    
    _originalPrice = widget.booking.price;
    _calculateNewPrice();
  }

  List<TimeOfDay> get _occupiedTimes {
    if (_court == null) return [];
    
    final occupied = <TimeOfDay>[];
    final selectedDate = _selectedDate;
    
    // Получаем реальные занятые слоты для выбранной даты
    for (final bookedSlot in _court!.bookedSlots) {
      if (bookedSlot.year == selectedDate.year &&
          bookedSlot.month == selectedDate.month &&
          bookedSlot.day == selectedDate.day) {
        occupied.add(TimeOfDay.fromDateTime(bookedSlot));
      }
    }
    
    return occupied;
  }

  List<TimeOfDay> get _availableTimes {
    return _allTimes.where((time) => !_isTimeOccupied(time)).toList();
  }

  bool _isTimeOccupied(TimeOfDay time) {
    return _occupiedTimes.any((occupiedTime) =>
        occupiedTime.hour == time.hour && occupiedTime.minute == time.minute);
  }

  bool _isTimeRangeAvailable(TimeOfDay startTime, int durationHours) {
    if (_court == null) return false;
    
    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    
    return _court!.isTimeSlotAvailable(startDateTime, durationHours);
  }

  void _calculateNewPrice() {
    if (_selectedStartTime == null || _selectedEndTime == null || _court == null) {
      _newPrice = 0;
      _priceDifference = 0;
      return;
    }
    
    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedStartTime!.hour,
      _selectedStartTime!.minute,
    );
    
    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedEndTime!.hour,
      _selectedEndTime!.minute,
    );
    
    _newPrice = _court!.calculateTotalPrice(startDateTime, endDateTime);
    _priceDifference = _newPrice - _originalPrice;
  }

  bool get _canProceed => _selectedStartTime != null && _selectedEndTime != null;

  Future<void> _confirmReschedule() async {
    if (_selectedStartTime == null || _selectedEndTime == null || _court == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Создаем новое время начала и окончания бронирования
      final newStartTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedStartTime!.hour,
        _selectedStartTime!.minute,
      );
      
      final newEndTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedEndTime!.hour,
        _selectedEndTime!.minute,
      );

      // Обновляем бронирование через MockDataService с учетом разницы стоимости
      MockDataService.updateUserBookingTime(
        widget.booking.id,
        newStartTime,
        newEndTime,
        priceDifference: _priceDifference,
      );

      // Показываем уведомление о переносе сразу после нажатия кнопки
      if (_priceDifference < 0) {
        showSuccessSnackBar(context,
          'Время бронирования изменено. Будет возвращено ${(-_priceDifference).toInt()} ₽ администратором');
      } else {
        showSuccessSnackBar(context,
          'Время бронирования изменено на ${DateFormatters.formatDate(_selectedDate)} ${_selectedStartTime!.format(context)}');
      }
      
      // Добавляем системное уведомление о переносе
      final notification = AppNotification(
        id: 'reschedule_${DateTime.now().millisecondsSinceEpoch}',
        type: NotificationType.booking,
        title: 'Время бронирования перенесено',
        message: 'Бронирование "${widget.booking.title}" перенесено на ${DateFormatters.formatDate(_selectedDate)} ${_selectedStartTime!.format(context)}',
        timestamp: DateTime.now(),
        isRead: false,
        relatedId: widget.booking.id,
      );
      MockDataService.addNotification(notification);

      final navigationService = NavigationService.of(context);
      
      // Если требуется доплата, переходим на экран оплаты
      if (_priceDifference > 0) {
        // Получаем обновленное бронирование
        final updatedBooking = MockDataService.userBookings.firstWhere(
          (b) => b.id == widget.booking.id,
          orElse: () => widget.booking,
        );
        
        // Ждем немного, чтобы уведомление успело показаться
        await Future.delayed(const Duration(milliseconds: 500));
        
        navigationService?.navigateTo('payment', {
          'booking': updatedBooking,
          'amount': _priceDifference,
          'description': 'Доплата за перенос времени бронирования',
          'isDifferencePayment': true,
        });
      } else {
        // Ждем немного, чтобы уведомление успело показаться
        await Future.delayed(const Duration(milliseconds: 500));
        
        navigationService?.navigateToHome();
      }
    } catch (e) {
      // В случае ошибки показываем сообщение
      showSuccessSnackBar(context, 'Ошибка при переносе времени: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Изменение времени корта',
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
            color: Colors.white,
            child: Row(
              children: [
                Icon(
                  Icons.sports_tennis,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.booking.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_court?.surfaceType} • ${_court != null ? (_court!.isIndoor ? 'Крытый' : 'Открытый') : 'Неизвестно'}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Календарный фильтр
          CalendarFilter(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _selectedStartTime = null;
                _selectedEndTime = null;
                _calculateNewPrice();
              });
            },
            datesWithBookings: _getDatesWithAvailableTimes(),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Информация о текущем бронировании
                  Container(
                    padding: AppStyles.paddingMd,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: AppStyles.borderRadiusMd,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 8),
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
                        const SizedBox(width: 8),
                        Text(
                          '${DateFormatters.formatTime(widget.booking.startTime)}-${DateFormatters.formatTime(widget.booking.endTime)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Выберите новое время:',
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Выбор времени
                  _buildTimeSelector(),

                  // Информация о стоимости
                  if (_canProceed) ...[
                    const SizedBox(height: 24),
                    _buildPriceInfo(),
                  ],
                ],
              ),
            ),
          ),

          // Кнопки внизу экрана (фиксированные)
          if (_canProceed)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
              ),
              child: _buildActionButtons(),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Начальное время:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allTimes.map((time) {
            final isSelected = time == _selectedStartTime;
            final isOccupied = _isTimeOccupied(time);
            
            return TimeSlotChip(
              time: time,
              isSelected: isSelected,
              isOccupied: isOccupied,
              onTap: isOccupied ? null : () {
                setState(() {
                  if (!isSelected) {
                    _selectedStartTime = time;
                    _selectedEndTime = null;
                    _calculateNewPrice();
                  } else {
                    _selectedStartTime = null;
                    _selectedEndTime = null;
                    _calculateNewPrice();
                  }
                });
              },
            );
          }).toList(),
        ),
        
        if (_selectedStartTime != null) ...[
          const SizedBox(height: 16),
          Text(
            'Конечное время:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allTimes.where((time) =>
                time.hour > _selectedStartTime!.hour).map((time) {
              final isSelected = time == _selectedEndTime;
              final durationHours = time.hour - _selectedStartTime!.hour;
              final isTimeRangeAvailable = _isTimeRangeAvailable(_selectedStartTime!, durationHours);
              
              return TimeSlotChip(
                time: time,
                isSelected: isSelected,
                isOccupied: !isTimeRangeAvailable,
                onTap: !isTimeRangeAvailable ? null : () {
                  setState(() {
                    _selectedEndTime = !isSelected ? time : null;
                    _calculateNewPrice();
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceInfo() {
    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: AppStyles.borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Новая стоимость:',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_newPrice.toInt()} ₽',
                style: AppTextStyles.price.copyWith(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (_priceDifference != 0) ...[
            const SizedBox(height: 8),
            Text(
              _priceDifference > 0 
                ? 'Требуется доплата: ${_priceDifference.toInt()} ₽'
                : 'Будет возвращено: ${(-_priceDifference).toInt()} ₽',
              style: AppTextStyles.caption.copyWith(
                color: _priceDifference > 0 ? AppColors.error : AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: 'Перенести время',
        onPressed: _canProceed ? _confirmReschedule : () {},
        isEnabled: _canProceed,
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