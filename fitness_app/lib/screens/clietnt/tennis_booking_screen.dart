
import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import 'calendar_filter.dart';
import 'booking_confirmation_models.dart';

class TennisBookingScreen extends StatefulWidget {
  const TennisBookingScreen({super.key});

  @override
  State<TennisBookingScreen> createState() => _TennisBookingScreenState();
}

class _TennisBookingScreenState extends State<TennisBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TennisCourt? _selectedCourt;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

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

  double get _totalPrice {
    if (_selectedCourt == null || _selectedStartTime == null || _selectedEndTime == null) {
      return 0;
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
    
    return _selectedCourt!.calculateTotalPrice(startDateTime, endDateTime);
  }

  bool get _canProceed => _selectedCourt != null && _selectedStartTime != null && _selectedEndTime != null;

  // Получаем список кортов, доступных на выбранную дату
  List<TennisCourt> get _availableCourtsOnSelectedDate {
    return MockDataService.tennisCourts.where((court) {
      if (!court.isAvailable) return false;
      
      // Проверяем, есть ли хотя бы один свободный слот на выбранную дату
      return _availableTimes.any((time) {
        final dateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          time.hour,
          time.minute,
        );
        
        final isPastTime = dateTime.isBefore(DateTime.now());
        final isAvailable = court.isTimeSlotAvailable(dateTime, 1);
        
        return !isPastTime && isAvailable;
      });
    }).toList();
  }

  // Получаем доступные временные слоты для конкретного корта
  List<TimeOfDay> _getAvailableTimeSlotsForCourt(TennisCourt court) {
    return _availableTimes.where((time) {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        time.hour,
        time.minute,
      );
      
      final isPastTime = dateTime.isBefore(DateTime.now());
      final isAvailable = court.isTimeSlotAvailable(dateTime, 1);
      
      return !isPastTime && isAvailable;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final availableCourts = _availableCourtsOnSelectedDate;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Бронирование теннисного корта',
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
          // Календарный фильтр
          CalendarFilter(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _selectedCourt = null;
                _selectedStartTime = null;
                _selectedEndTime = null;
              });
            },
            datesWithBookings: _getDatesWithAvailableCourts(),
          ),
          
          Expanded(
            child: Column(
              children: [
                // Итоговая стоимость (фиксированная вверху)
                if (_canProceed) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.border.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: _buildTotalPrice(),
                  ),
                ],
                
                // Список кортов с прокруткой
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppStyles.paddingLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (availableCourts.isEmpty) ...[
                          _buildNoAvailableCourts(),
                        ] else ...[
                          // Выбор корта
                          Text(
                            'Доступные корты на ${DateFormatters.formatDateWithMonth(_selectedDate)}:',
                            style: AppTextStyles.headline6.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildCourtSelector(availableCourts),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Кнопки внизу экрана (фиксированные)
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
            child: _buildContinueButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAvailableCourts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_tennis,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'На выбранную дату нет доступных кортов',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Пожалуйста, выберите другую дату',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCourtSelector(List<TennisCourt> availableCourts) {
    return Column(
      children: availableCourts.map((court) {
        final isSelected = court == _selectedCourt;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: isSelected
                ? Border.all(color: Color(0xFF4F8DFF), width: 2.5)
                : Border.all(color: Colors.grey.shade200, width: 1.5),
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE8F2FF),
                      Color(0xFFF0F7FF),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
          ),
          child: Column(
            children: [
              // Заголовок корта
              ListTile(
                leading: Icon(
                  Icons.sports_tennis,
                  color: AppColors.success,
                  size: 24,
                ),
                title: Text(
                  court.number,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  '${court.surfaceType} • ${court.isIndoor ? 'Крытый' : 'Открытый'} • от ${court.basePricePerHour.toInt()} ₽/час',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isSelected ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCourt = null;
                      } else {
                        _selectedCourt = court;
                      }
                      _selectedStartTime = null;
                      _selectedEndTime = null;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedCourt = null;
                    } else {
                      _selectedCourt = court;
                    }
                    _selectedStartTime = null;
                    _selectedEndTime = null;
                  });
                },
              ),
              
              // Доступное время для этого корта (всегда показываем)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _buildAvailableTimesForCourt(court),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAvailableTimesForCourt(TennisCourt court) {
    final availableSlots = _getAvailableTimeSlotsForCourt(court);
    final isCourtSelected = court == _selectedCourt;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Доступное время:',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (isCourtSelected) ...[
              Text(
                'Выбран',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        
        if (availableSlots.isEmpty) ...[
          Text(
            'На выбранную дату нет свободного времени',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ] else ...[
          // Выбор начального времени
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Начальное время:',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableSlots.map((time) {
                  final isSelected = isCourtSelected && time == _selectedStartTime;
                  
                  return TimeSlotChip(
                    time: time,
                    isSelected: isSelected,
                    isOccupied: false,
                    onTap: () {
                      setState(() {
                        if (!isSelected) {
                          _selectedCourt = court;
                          _selectedStartTime = time;
                          _selectedEndTime = null;
                        } else {
                          _selectedStartTime = null;
                          _selectedEndTime = null;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          
          // Выбор конечного времени (только если выбрано начальное время для этого корта)
          if (isCourtSelected && _selectedStartTime != null) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Конечное время:',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableSlots.where((time) =>
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
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }


  Widget _buildTotalPrice() {
    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: AppStyles.borderRadiusLg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Итоговая стоимость:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '${_totalPrice.toStringAsFixed(0)} ₽',
            style: AppTextStyles.price.copyWith(
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            text: 'Назад',
            onPressed: () {
              if (_selectedCourt != null) {
                setState(() {
                  _selectedCourt = null;
                  _selectedStartTime = null;
                  _selectedEndTime = null;
                });
              } else {
                final navigationService = NavigationService.of(context);
                navigationService?.onBack();
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _canProceed
              ? PrimaryButton(
                  text: 'Продолжить',
                  onPressed: _proceedToConfirmation,
                )
              : PrimaryButton(
                  text: 'Продолжить',
                  onPressed: () {},
                  isEnabled: false,
                ),
        ),
      ],
    );
  }

  void _proceedToConfirmation() {
    final startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedStartTime!.hour,
      _selectedStartTime!.minute,
    );
    
    // Проверяем, что время не в прошлом
    if (startTime.isBefore(DateTime.now())) {
      showErrorSnackBar(context, 'Нельзя забронировать корт на прошедшее время');
      return;
    }

    final config = BookingConfirmationConfig(
      type: ConfirmationBookingType.tennisCourt,
      title: 'Подтверждение бронирования корта',
      serviceName: _selectedCourt!.number,
      price: _totalPrice,
      date: _selectedDate,
      startTime: startTime,
      endTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedEndTime!.hour,
        _selectedEndTime!.minute,
      ),
      court: _selectedCourt!,
      location: '${_selectedCourt!.surfaceType} • ${_selectedCourt!.isIndoor ? 'Крытый' : 'Открытый'}',
    );

    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('booking_confirmation', config);
  }

  List<DateTime> _getDatesWithAvailableCourts() {
    final dates = <DateTime>{};
    final today = DateTime.now();
    
    for (int i = 0; i <= 21; i++) {
      final date = today.add(Duration(days: i));
      // Исключаем прошедшие даты
      if (date.isBefore(DateTime(today.year, today.month, today.day))) {
        continue;
      }
      
      final hasAvailableCourts = MockDataService.tennisCourts.any((court) => court.isAvailable);
      if (hasAvailableCourts) {
        dates.add(date);
      }
    }
    
    return dates.toList()..sort();
  }

  bool _isTimeRangeAvailable(TimeOfDay startTime, int durationHours) {
    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    
    // Время считается недоступным, если оно в прошлом или уже забронировано
    final isPastTime = startDateTime.isBefore(DateTime.now());
    final isAvailable = _selectedCourt!.isTimeSlotAvailable(startDateTime, durationHours);
    return !isPastTime && isAvailable;
  }
}
   