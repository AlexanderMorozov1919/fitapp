import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../screens/clietnt/calendar_filter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/free_time_card.dart';
import '../../utils/formatters.dart';
import '../../main.dart';

class EmployeeScheduleScreen extends StatefulWidget {
  const EmployeeScheduleScreen({super.key});

  @override
  State<EmployeeScheduleScreen> createState() => _EmployeeScheduleScreenState();
}

class _EmployeeScheduleScreenState extends State<EmployeeScheduleScreen> {
  late DateTime _selectedDate;
  late List<Booking> _filteredTrainings;
  late List<FreeTimeSlot> _freeTimeSlots;
  bool _showOnlyFreeTime = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateData();
  }

  void _updateData() {
    _filteredTrainings = MockDataService.employeeTrainings.where((training) {
      return training.startTime.year == _selectedDate.year &&
             training.startTime.month == _selectedDate.month &&
             training.startTime.day == _selectedDate.day;
    }).toList();

    _freeTimeSlots = _calculateFreeTimeSlots();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _updateData();
    });
  }

  List<FreeTimeSlot> _calculateFreeTimeSlots() {
    final slots = <FreeTimeSlot>[];
    final trainings = _filteredTrainings.toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

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

    for (final training in trainings) {
      if (training.startTime.isAfter(currentTime)) {
        final freeTime = training.startTime.difference(currentTime);
        if (freeTime.inMinutes >= 30) { // Минимальный слот 30 минут
          slots.add(FreeTimeSlot(
            startTime: currentTime,
            endTime: training.startTime,
          ));
        }
      }
      currentTime = training.endTime;
    }

    // Добавляем свободное время после последней тренировки
    if (currentTime.isBefore(endOfDay)) {
      final freeTime = endOfDay.difference(currentTime);
      if (freeTime.inMinutes >= 30) {
        slots.add(FreeTimeSlot(
          startTime: currentTime,
          endTime: endOfDay,
        ));
      }
    }

    return slots;
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
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('create_training', {
      'freeTimeSlot': freeTimeSlot,
      'onTrainingCreated': () {
        setState(() {
          _updateData();
        });
      }
    });
  }

  void _toggleFreeTimeFilter() {
    setState(() {
      _showOnlyFreeTime = !_showOnlyFreeTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final datesWithTrainings = _getDatesWithTrainings();
    final filteredTrainings = _showOnlyFreeTime ? [] : _filteredTrainings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Запись на тренировку',
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

          // Фильтр свободного времени
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Только свободное время:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _showOnlyFreeTime,
                  onChanged: (value) => _toggleFreeTimeFilter(),
                  activeColor: AppColors.primary,
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
                  // Запланированные тренировки (только если не включен фильтр свободного времени)
                  if (!_showOnlyFreeTime && filteredTrainings.isNotEmpty) ...[
                    Text(
                      'Запланированные тренировки',
                      style: AppTextStyles.headline6.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...filteredTrainings.map((training) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTrainingItem(training),
                        )).toList(),
                    const SizedBox(height: 24),
                  ],

                  // Свободное время
                  if (!_showOnlyFreeTime) ...[
                    Text(
                      'Свободное время',
                      style: AppTextStyles.headline6.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
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
                  ] else if (_freeTimeSlots.isNotEmpty) ...[
                    // Когда фильтр включен, показываем только свободное время без заголовка
                    ..._freeTimeSlots.map((slot) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FreeTimeCard(
                            freeTimeSlot: slot,
                            onTap: () => _onFreeTimeTap(slot),
                          ),
                        )).toList(),
                  ] else ...[
                    // Когда фильтр включен, но нет свободного времени
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

  Widget _buildTrainingItem(Booking training) {
    return AppCard(
      padding: AppStyles.paddingMd,
      child: Row(
        children: [
          // Иконка типа тренировки
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getStatusColor(training.status).withOpacity(0.1),
              borderRadius: AppStyles.borderRadiusLg,
            ),
            child: Icon(
              _getTrainingIcon(training),
              size: 20,
              color: _getStatusColor(training.status),
            ),
          ),
          const SizedBox(width: 12),
          
          // Детали тренировки
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  training.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${DateFormatters.formatTimeRangeRussian(training.startTime, training.endTime)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (training.clientName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Клиент: ${training.clientName!}',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          
          // Статус
          StatusBadge(
            text: _getStatusText(training.status),
            color: _getStatusColor(training.status),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.access_time,
      title: 'Нет свободного времени',
      subtitle: 'На выбранную дату все время занято',
    );
  }

  IconData _getTrainingIcon(Booking training) {
    switch (training.type) {
      case BookingType.tennisCourt:
        return Icons.sports_tennis;
      case BookingType.groupClass:
        return Icons.group;
      case BookingType.personalTraining:
        return Icons.person;
      default:
        return Icons.fitness_center;
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.completed:
        return AppColors.info;
      case BookingStatus.awaitingPayment:
        return Colors.orange;
    }
    return AppColors.textTertiary;
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Подтверждено';
      case BookingStatus.pending:
        return 'Ожидание';
      case BookingStatus.cancelled:
        return 'Отменено';
      case BookingStatus.completed:
        return 'Завершено';
      case BookingStatus.awaitingPayment:
        return 'Ожидает оплаты';
    }
    return 'Неизвестно';
  }
}