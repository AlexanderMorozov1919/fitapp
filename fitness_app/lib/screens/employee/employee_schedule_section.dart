import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../screens/clietnt/calendar_filter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';

class EmployeeScheduleSection extends StatefulWidget {
  final List<Booking> allTrainings;
  final Function(Booking) onTrainingTap;

  const EmployeeScheduleSection({
    super.key,
    required this.allTrainings,
    required this.onTrainingTap,
  });

  @override
  State<EmployeeScheduleSection> createState() => _EmployeeScheduleSectionState();
}

class _EmployeeScheduleSectionState extends State<EmployeeScheduleSection> {
  late DateTime _selectedDate;
  late List<Booking> _filteredTrainings;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateFilteredTrainings();
  }

  void _updateFilteredTrainings() {
    _filteredTrainings = widget.allTrainings.where((training) {
      return training.startTime.year == _selectedDate.year &&
             training.startTime.month == _selectedDate.month &&
             training.startTime.day == _selectedDate.day;
    }).toList();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _updateFilteredTrainings();
    });
  }

  List<DateTime> _getDatesWithTrainings() {
    final dates = <DateTime>[];
    for (final training in widget.allTrainings) {
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

  @override
  Widget build(BuildContext context) {
    final datesWithTrainings = _getDatesWithTrainings();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Фильтр календаря
        CalendarFilter(
          selectedDate: _selectedDate,
          onDateSelected: _onDateSelected,
          datesWithBookings: datesWithTrainings,
        ),
        const SizedBox(height: 16),
        
        // Список тренировок
        if (_filteredTrainings.isNotEmpty) ...[
          ..._filteredTrainings.map((training) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildTrainingItem(training),
              )).toList(),

        ] else ...[
          _buildEmptyState(_selectedDate),
        ],
      ],
    );
  }

  Widget _buildTrainingItem(Booking training) {
    return StatefulBuilder(
      builder: (context, setState) {
        var isHovered = false;
        
        return GestureDetector(
          onTap: () => widget.onTrainingTap(training),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
              decoration: BoxDecoration(
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: isHovered ? AppColors.shadowLg : AppColors.shadowMd,
              ),
              child: AppCard(
                padding: AppStyles.paddingLg,
                backgroundColor: isHovered ? AppColors.primary.withOpacity(0.05) : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Основная информация
                    Row(
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
                                '${DateFormatters.formatDate(training.startTime)} • ${DateFormatters.formatTimeRussian(training.startTime)}',
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
                              if (training.description != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  training.description!,
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(DateTime date) {
    final today = DateTime.now();
    
    String message;
    if (date.isBefore(DateTime(today.year, today.month, today.day))) {
      message = 'На выбранную дату нет тренировок';
    } else {
      message = 'На выбранную дату нет запланированных тренировок';
    }

    return EmptyState(
      icon: Icons.fitness_center,
      title: message,
      subtitle: 'Попробуйте выбрать другую дату',
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