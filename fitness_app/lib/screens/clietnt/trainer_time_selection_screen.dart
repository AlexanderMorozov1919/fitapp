import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import 'calendar_filter.dart';
import 'booking_confirmation_models.dart';

class TrainerTimeSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> selectionData;

  const TrainerTimeSelectionScreen({super.key, required this.selectionData});

  @override
  State<TrainerTimeSelectionScreen> createState() => _TrainerTimeSelectionScreenState();
}

class _TrainerTimeSelectionScreenState extends State<TrainerTimeSelectionScreen> {
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

  Trainer get _trainer => widget.selectionData['trainer'] as Trainer;
  String get _serviceName => widget.selectionData['serviceName'] as String;
  double get _price => widget.selectionData['price'] as double;

  bool get _canProceed => _selectedTime != null;

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
          // Информация о тренере и услуге
          Container(
            padding: AppStyles.paddingLg,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _trainer.photoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            _trainer.photoUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 20,
                          color: AppColors.textTertiary,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _trainer.fullName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$_serviceName • ${_price.toInt()} ₽/час',
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
                _selectedTime = null;
              });
            },
            datesWithBookings: _getDatesWithAvailableTrainers(),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Выбор времени
                  Text(
                    'Выберите время тренировки:',
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableTimes.map((time) {
        final isSelected = time == _selectedTime;
        final isAvailable = _isTimeAvailable(time);

        return TimeSlotChip(
          time: time,
          isSelected: isSelected,
          isOccupied: !isAvailable,
          onTap: isAvailable
              ? () {
                  setState(() {
                    _selectedTime = !isSelected ? time : null;
                  });
                }
              : null,
        );
      }).toList(),
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
            '${_price.toInt()} ₽',
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
    final selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    
    // Проверяем, что время не в прошлом
    if (selectedDateTime.isBefore(DateTime.now())) {
      showErrorSnackBar(context, 'Нельзя забронировать тренировку на прошедшее время');
      return;
    }

    final config = BookingConfirmationConfig(
      type: ConfirmationBookingType.personalTraining,
      title: 'Подтверждение персональной тренировки',
      serviceName: _serviceName,
      price: _price,
      date: _selectedDate,
      time: _selectedTime,
      trainer: _trainer,
    );

    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('booking_confirmation', config);
  }

  bool _isTimeAvailable(TimeOfDay time) {
    final selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      time.hour,
      time.minute,
    );

    // Время считается недоступным, если оно в прошлом или уже занято у тренера
    final isPastTime = selectedDateTime.isBefore(DateTime.now());
    final isAvailable = _trainer.isTimeAvailable(selectedDateTime);
    
    return !isPastTime && isAvailable;
  }

  List<DateTime> _getDatesWithAvailableTrainers() {
    final today = DateTime.now();
    final endDate = today.add(const Duration(days: 21));
    
    // Получаем доступные даты из расписания тренера и фильтруем прошедшие
    final availableDates = _trainer.getAvailableDates(today, endDate);
    return availableDates.where((date) =>
        !date.isBefore(DateTime(today.year, today.month, today.day))
    ).toList();
  }
}