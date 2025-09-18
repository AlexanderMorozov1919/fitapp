import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../models/user_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../clietnt/calendar_filter.dart';

class EmployeeTennisTimeSelectionScreen extends StatefulWidget {
  final TennisCourt selectedCourt;
  final User selectedClient;

  const EmployeeTennisTimeSelectionScreen({
    super.key,
    required this.selectedCourt,
    required this.selectedClient,
  });

  @override
  State<EmployeeTennisTimeSelectionScreen> createState() => _EmployeeTennisTimeSelectionScreenState();
}

class _EmployeeTennisTimeSelectionScreenState extends State<EmployeeTennisTimeSelectionScreen> {
  DateTime _selectedDate = DateTime.now();
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
    if (_selectedStartTime == null || _selectedEndTime == null) {
      return 0;
    }
    
    final startHour = _selectedStartTime!.hour + _selectedStartTime!.minute / 60;
    final endHour = _selectedEndTime!.hour + _selectedEndTime!.minute / 60;
    final duration = endHour - startHour;
    
    return duration * widget.selectedCourt.pricePerHour;
  }

  bool get _canProceed => _selectedStartTime != null && _selectedEndTime != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Выбор времени',
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
          // Информация о выбранном корте и клиенте
          Container(
            padding: AppStyles.paddingLg,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                            widget.selectedCourt.number,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${widget.selectedCourt.surfaceType} • ${widget.selectedCourt.pricePerHour.toInt()} ₽/час',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Клиент: ${widget.selectedClient.fullName}',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
              });
            },
            datesWithBookings: _getDatesWithAvailableCourts(),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Выбор времени
                  Text(
                    'Выберите время:',
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTimeSelector(),
                  
                  // Итоговая стоимость
                  if (_canProceed) ...[
                    const SizedBox(height: 24),
                    _buildTotalPrice(),
                    const SizedBox(height: 16),
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
              child: _buildContinueButton(),
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
          children: _availableTimes.map((time) {
            final isSelected = time == _selectedStartTime;
            
            return TimeSlotChip(
              time: time,
              isSelected: isSelected,
              isOccupied: false,
              onTap: () {
                setState(() {
                  if (!isSelected) {
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
            children: _availableTimes.where((time) =>
                time.hour > _selectedStartTime!.hour).map((time) {
              final isSelected = time == _selectedEndTime;
              
              return TimeSlotChip(
                time: time,
                isSelected: isSelected,
                isOccupied: false,
                onTap: () {
                  setState(() {
                    _selectedEndTime = !isSelected ? time : null;
                  });
                },
              );
            }).toList(),
          ),
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
              final navigationService = NavigationService.of(context);
              navigationService?.onBack();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _canProceed
              ? PrimaryButton(
                  text: 'Подтвердить',
                  onPressed: _proceedToConfirmation,
                )
              : PrimaryButton(
                  text: 'Подтвердить',
                  onPressed: () {},
                  isEnabled: false,
                ),
        ),
      ],
    );
  }

  void _proceedToConfirmation() {
    final bookingData = {
      'court': widget.selectedCourt,
      'client': widget.selectedClient,
      'date': _selectedDate,
      'startTime': _selectedStartTime,
      'endTime': _selectedEndTime,
      'totalPrice': _totalPrice,
    };

    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('employee_tennis_confirmation', bookingData);
  }

  List<DateTime> _getDatesWithAvailableCourts() {
    final dates = <DateTime>{};
    final today = DateTime.now();
    
    for (int i = 0; i <= 21; i++) {
      final date = today.add(Duration(days: i));
      final hasAvailableCourts = MockDataService.tennisCourts.any((court) => court.isAvailable);
      if (hasAvailableCourts) {
        dates.add(date);
      }
    }
    
    return dates.toList()..sort();
  }
}