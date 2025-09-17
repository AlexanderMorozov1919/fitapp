import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import 'calendar_filter.dart';

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
        
        // Заголовок с выбранной датой
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            _getSectionTitle(_selectedDate),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Информация о бронировании
          Row(
            children: [
              Icon(
                _getBookingIcon(booking),
                size: 20,
                color: _getStatusColor(booking.status),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(booking.startTime)} • ${_formatTime(booking.startTime)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (booking.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        booking.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusText(booking.status),
                  style: TextStyle(
                    fontSize: 10,
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Кнопки действий
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton(
                'Отменить',
                Icons.cancel,
                Colors.red,
                () => widget.onCancelBooking(booking),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                'Перенести',
                Icons.calendar_today,
                Colors.blue,
                () => widget.onRescheduleBooking(booking),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
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