import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';

class RescheduleBookingModal extends StatefulWidget {
  final Booking booking;
  final Function(DateTime, TimeOfDay) onRescheduleConfirmed;

  const RescheduleBookingModal({
    super.key,
    required this.booking,
    required this.onRescheduleConfirmed,
  });

  @override
  State<RescheduleBookingModal> createState() => _RescheduleBookingModalState();
}

class _RescheduleBookingModalState extends State<RescheduleBookingModal> {
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
  void initState() {
    super.initState();
    _selectedDate = widget.booking.startTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.booking.startTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
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
            'Изменение времени',
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Выберите новую дату и время:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Выбор даты
          Text(
            'Дата:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppStyles.borderRadiusLg,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    DateFormatters.formatDate(_selectedDate),
                    style: AppTextStyles.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Выбор времени
          Text(
            'Время:',
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
              final isSelected = time == _selectedTime;
              
              return FilterChipWidget(
                label: _formatTime(time),
                isSelected: isSelected,
                onTap: () => setState(() => _selectedTime = isSelected ? null : time),
                selectedColor: AppColors.primary,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Назад',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Подтвердить изменение',
                  onPressed: _selectedTime != null
                      ? () {
                          final newDateTime = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          );
                          widget.onRescheduleConfirmed(_selectedDate, _selectedTime!);
                          Navigator.pop(context);
                        }
                      : () {},
                  isEnabled: _selectedTime != null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
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

  String _formatTime(TimeOfDay time) {
    final dateTime = DateTime(2024, 1, 1, time.hour, time.minute);
    return DateFormatters.formatTimeRussian(dateTime);
  }
}