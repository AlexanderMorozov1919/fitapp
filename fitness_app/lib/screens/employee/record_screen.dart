import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../models/user_model.dart';
import '../../screens/clietnt/calendar_filter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/free_time_card.dart';
import '../../utils/formatters.dart';
import '../../main.dart';

class RecordScreen extends StatefulWidget {
  final User? preselectedClient;

  const RecordScreen({super.key, this.preselectedClient});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late DateTime _selectedDate;
  late List<FreeTimeSlot> _freeTimeSlots;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateData();
  }

  void _updateData() {
    final filteredTrainings = MockDataService.employeeTrainings.where((training) {
      return training.startTime.year == _selectedDate.year &&
             training.startTime.month == _selectedDate.month &&
             training.startTime.day == _selectedDate.day;
    }).toList();

    _freeTimeSlots = _calculateFreeTimeSlots(filteredTrainings);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _updateData();
    });
  }

  List<FreeTimeSlot> _calculateFreeTimeSlots(List<Booking> trainings) {
    final slots = <FreeTimeSlot>[];
    trainings.sort((a, b) => a.startTime.compareTo(b.startTime));

    DateTime currentTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      8,
      0,
    ); // Начало рабочего дня в 8:00

    final endOfDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      22,
      0,
    ); // Конец рабочего дня в 22:00

    final now = DateTime.now();

    // Округляем текущее время до ближайших 30 минут в большую сторону
    DateTime roundedNow = _roundToNext30Minutes(now);

    for (final training in trainings) {
      if (training.startTime.isAfter(currentTime)) {
        final freeTime = training.startTime.difference(currentTime);
        if (freeTime.inMinutes >= 30) { // Минимальный слот 30 минут
          DateTime slotStartTime = currentTime;
          DateTime slotEndTime = training.startTime;
          
          // Если слот начинается в прошлом, сдвигаем начало на округленное текущее время
          if (slotStartTime.isBefore(roundedNow)) {
            slotStartTime = roundedNow;
          }
          
          // Проверяем, что после сдвига слот все еще имеет достаточную длительность
          if (slotEndTime.difference(slotStartTime).inMinutes >= 30) {
            final slot = FreeTimeSlot(
              startTime: slotStartTime,
              endTime: slotEndTime,
            );
            slots.add(slot);
          }
        }
      }
      currentTime = training.endTime;
    }

    // Добавляем свободное время после последней тренировки
    if (currentTime.isBefore(endOfDay)) {
      final freeTime = endOfDay.difference(currentTime);
      if (freeTime.inMinutes >= 30) {
        DateTime slotStartTime = currentTime;
        DateTime slotEndTime = endOfDay;
        
        // Если слот начинается в прошлом, сдвигаем начало на округленное текущее время
        if (slotStartTime.isBefore(roundedNow)) {
          slotStartTime = roundedNow;
        }
        
        // Проверяем, что после сдвига слот все еще имеет достаточную длительность
        if (slotEndTime.difference(slotStartTime).inMinutes >= 30) {
          final slot = FreeTimeSlot(
            startTime: slotStartTime,
            endTime: slotEndTime,
          );
          slots.add(slot);
        }
      }
    }

    return slots;
  }

  DateTime _roundToNext30Minutes(DateTime dateTime) {
    int minutes = dateTime.minute;
    int roundedMinutes = ((minutes + 29) ~/ 30) * 30;
    
    if (roundedMinutes == 60) {
      return DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour + 1,
        0,
      );
    } else {
      return DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        roundedMinutes,
      );
    }
  }

  List<DateTime> _getDatesWithTrainings() {
    final dates = <DateTime>[];
    for (final training in MockDataService.employeeTrainings) {
      final date = DateTime(
        training.startTime.year,
        training.startTime.month,
        training.startTime.day,
      );
      if (!dates.any((d) => d.isAtSameMomentAs(date))) {
        dates.add(date);
      }
    }
    return dates;
  }

  void _onFreeTimeTap(FreeTimeSlot freeTimeSlot) {
    final now = DateTime.now();
    
    // Проверяем, что слот не прошел (начало слота должно быть в будущем)
    if (freeTimeSlot.startTime.isBefore(now)) {
      showErrorSnackBar(context, 'Это время уже прошло. Выберите другое свободное время.');
      return;
    }
    
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('create_training', {
      'freeTimeSlot': freeTimeSlot,
      'preselectedClient': widget.preselectedClient,
    });
  }

  @override
  Widget build(BuildContext context) {
    final datesWithTrainings = _getDatesWithTrainings();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Запись клиента',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final navigationService = NavigationService.of(context);
            if (navigationService != null) {
              navigationService.onBack();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Фильтр календаря
          CalendarFilter(
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelected,
            datesWithBookings: datesWithTrainings,
          ),

          // Заголовок свободного времени
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Свободное время для записи:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_freeTimeSlots.isNotEmpty) ...[
                    ..._freeTimeSlots.map((slot) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FreeTimeCard(
                            freeTimeSlot: slot,
                            onTap: () => _onFreeTimeTap(slot),
                          ),
                        )).toList(),
                  ] else ...[
                    _buildEmptyState(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.access_time,
      title: 'Нет свободного времени',
      subtitle: 'На выбранную дату все время занято. Выберите другую дату.',
    );
  }
}