import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import 'calendar_filter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HomeBookingsSection extends StatefulWidget {
  final List<Booking> allBookings;
  final Function(Booking) onCancelBooking;
  final Function(Booking) onRescheduleBooking;

  const HomeBookingsSection({
    super.key,
    required this.allBookings,
    required this.onCancelBooking,
    required this.onRescheduleBooking,
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
          ..._filteredBookings.map((booking) => _buildBookingItemWithActions(booking, context)).toList(),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {
                // Навигация к экрану всех записей
              },
              child: const Text(
                'Все записи →',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ] else ...[
          _buildEmptyState(_selectedDate),
        ],
      ],
    );
  }

  String _getSectionTitle(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Мои бронирования сегодня';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Мои бронирования завтра';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Мои бронирования вчера';
    } else {
      return 'Мои бронирования ${date.day}.${date.month}';
    }
  }

  Widget _buildEmptyState(DateTime date) {
    final today = DateTime.now();
    
    String message;
    if (date.isBefore(DateTime(today.year, today.month, today.day))) {
      message = 'На выбранную дату нет бронирований';
    } else {
      message = 'На выбранную дату нет запланированных бронирований';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItemWithActions(Booking booking, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                  borderRadius: BorderRadius.circular(12),
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
                      '${_formatDate(booking.startTime)} • ${_formatTime(booking.startTime)}',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusText(booking.status),
                  style: AppTextStyles.overline.copyWith(
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Кнопки действий (только иконки)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Кнопка отмены
              _buildIconButton(
                Icons.close,
                Colors.red,
                () => widget.onCancelBooking(booking),
                tooltip: 'Отменить',
              ),
              const SizedBox(width: 8),
              
              // Кнопка переноса
              _buildIconButton(
                Icons.calendar_today,
                Colors.blue,
                () => widget.onRescheduleBooking(booking),
                tooltip: 'Перенести',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed, {String? tooltip}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
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
        return Colors.green;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
    return Colors.grey;
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
    }
    return 'Неизвестно';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}