import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import 'calendar_filter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';

class HomeBookingsSection extends StatefulWidget {
  final List<Booking> allBookings;
  final Function(Booking) onCancelBooking;
  final Function(Booking) onRescheduleBooking;
  final Function(Booking) onBookingTap;

  const HomeBookingsSection({
    super.key,
    required this.allBookings,
    required this.onCancelBooking,
    required this.onRescheduleBooking,
    required this.onBookingTap,
  });

  @override
  State<HomeBookingsSection> createState() => _HomeBookingsSectionState();
}

class _HomeBookingsSectionState extends State<HomeBookingsSection> {
  late DateTime _selectedDate;
  late List<Booking> _filteredBookings;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateFilteredBookings();
  }

  void _updateFilteredBookings() {
    _filteredBookings = widget.allBookings.where((booking) {
      return booking.startTime.year == _selectedDate.year &&
             booking.startTime.month == _selectedDate.month &&
             booking.startTime.day == _selectedDate.day;
    }).toList();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _updateFilteredBookings();
    });
  }

  List<DateTime> _getDatesWithBookings() {
    final dates = <DateTime>[];
    for (final booking in widget.allBookings) {
      final date = DateTime(
        booking.startTime.year,
        booking.startTime.month,
        booking.startTime.day,
      );
      if (!dates.any((d) => d.isAtSameMomentAs(date))) {
        dates.add(date);
      }
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final datesWithBookings = _getDatesWithBookings();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Фильтр календаря
        CalendarFilter(
          selectedDate: _selectedDate,
          onDateSelected: _onDateSelected,
          datesWithBookings: datesWithBookings,
        ),
        const SizedBox(height: 16),
        
        // Список бронирований
        if (_filteredBookings.isNotEmpty) ...[
          ..._filteredBookings.map((booking) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildBookingItem(booking),
              )).toList(),

        ] else ...[
          _buildEmptyState(_selectedDate),
        ],
      ],
    );
  }

  Widget _buildBookingItem(Booking booking) {
    return StatefulBuilder(
      builder: (context, setState) {
        var isHovered = false;
        
        return GestureDetector(
          onTap: () => widget.onBookingTap(booking),
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
                        // Иконка типа бронирования
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getStatusColor(booking.status).withOpacity(0.1),
                            borderRadius: AppStyles.borderRadiusLg,
                          ),
                          child: Icon(
                            _getBookingIcon(booking),
                            size: 20,
                            color: _getStatusColor(booking.status),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Детали бронирования
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.title,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${DateFormatters.formatDate(booking.startTime)} • ${DateFormatters.formatTime(booking.startTime)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (booking.description != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  booking.description!,
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
                          text: _getStatusText(booking.status),
                          color: _getStatusColor(booking.status),
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
      message = 'На выбранную дату нет бронирований';
    } else {
      message = 'На выбранную дату нет запланированных бронирований';
    }

    return EmptyState(
      icon: Icons.calendar_today,
      title: message,
      subtitle: 'Попробуйте выбрать другую дату',
    );
  }

  IconData _getBookingIcon(Booking booking) {
    switch (booking.type) {
      case BookingType.tennisCourt:
        return Icons.sports_tennis;
      case BookingType.groupClass:
        return Icons.group;
      case BookingType.personalTraining:
        return Icons.person;
      default:
        return Icons.calendar_today;
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