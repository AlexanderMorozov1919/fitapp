import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/booking_model.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String _selectedFilter = 'Все';

  final List<String> _filters = ['Все', 'Предстоящие', 'Завершенные', 'Отмененные'];

  @override
  Widget build(BuildContext context) {
    final filteredBookings = _filterBookings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои записи'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Фильтры
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor: Colors.blue,
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Список бронирований
          Expanded(
            child: filteredBookings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      return _buildBookingCard(filteredBookings[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Booking> _filterBookings() {
    return MockDataService.userBookings.where((booking) {
      switch (_selectedFilter) {
        case 'Предстоящие':
          return booking.isUpcoming;
        case 'Завершенные':
          return booking.status == BookingStatus.completed;
        case 'Отмененные':
          return booking.status == BookingStatus.cancelled;
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статус
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: booking.statusColor),
                  ),
                  child: Text(
                    booking.statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: booking.statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Детали бронирования
            if (booking.description != null)
              Text(
                booking.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

            const SizedBox(height: 12),

            // Время и дата
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(booking.startTime),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${_formatTime(booking.startTime)}-${_formatTime(booking.endTime)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Дополнительная информация в зависимости от типа бронирования
            if (booking.courtNumber != null)
              _buildDetailItem('Корт:', booking.courtNumber!),
            if (booking.trainerId != null)
              _buildDetailItem('Тренер:', _getTrainerName(booking.trainerId!)),
            if (booking.className != null)
              _buildDetailItem('Занятие:', booking.className!),
            if (booking.lockerNumber != null)
              _buildDetailItem('Шкафчик:', booking.lockerNumber!),

            if (booking.price > 0) ...[
              const SizedBox(height: 12),
              _buildDetailItem('Стоимость:', '${booking.price} руб.'),
            ],

            const SizedBox(height: 16),

            // Действия
            if (booking.status == BookingStatus.confirmed && booking.canCancel)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cancelBooking(booking),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Отменить'),
                    ),
                  ),
                  if (booking.type == BookingType.tennisCourt ||
                      booking.type == BookingType.personalTraining) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _modifyBooking(booking),
                        child: const Text('Изменить'),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateMessage(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateSubtitle(),
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

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'Предстоящие':
        return 'Нет предстоящих записей';
      case 'Завершенные':
        return 'Нет завершенных записей';
      case 'Отмененные':
        return 'Нет отмененных записей';
      default:
        return 'У вас пока нет записей';
    }
  }

  String _getEmptyStateSubtitle() {
    switch (_selectedFilter) {
      case 'Предстоящие':
        return 'Запишитесь на тренировку или забронируйте корт';
      case 'Завершенные':
        return 'Здесь будут отображаться ваши завершенные занятия';
      case 'Отмененные':
        return 'Здесь будут отображаться отмененные записи';
      default:
        return 'Начните планировать свои тренировки';
    }
  }

  void _cancelBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отмена бронирования'),
        content: const Text('Вы уверены, что хотите отменить бронирование?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showCancellationSuccess();
            },
            child: const Text('Да', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _modifyBooking(Booking booking) {
    // TODO: Реализовать изменение бронирования
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функционал изменения бронирования в разработке'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showCancellationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Бронирование успешно отменено'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getTrainerName(String trainerId) {
    final trainer = MockDataService.trainers
        .firstWhere((t) => t.id == trainerId, orElse: () => MockDataService.trainers.first);
    return trainer.fullName;
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}