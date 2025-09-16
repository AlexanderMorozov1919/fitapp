import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/widgets/app_container.dart';

class BookingDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? booking;

  const BookingDetailScreen({super.key, this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  final Map<String, dynamic> _bookingDetails = {
    'id': 'TC-20240310-1400',
    'service': 'Теннис',
    'trainer': 'Иван Петров',
    'date': '10 марта 2024',
    'time': '14:00 - 15:00',
    'duration': '1 час',
    'court': 'Корт 3 (Хард покрытие)',
    'price': 1200,
    'status': 'confirmed',
    'paymentMethod': 'Банковская карта',
    'createdAt': '2024-03-09 18:30',
    'notes': 'Принести собственную ракетку. Тренер встретит у входа за 10 минут до начала.',
  };

  void _cancelBooking() {
    // Здесь будет логика отмены бронирования
    setState(() {
      _bookingDetails['status'] = 'cancelled';
    });
  }

  void _rescheduleBooking() {
    // Здесь будет логика переноса бронирования
    // Перенос бронирования
  }

  void _contactSupport() {
    // Здесь будет логика связи с поддержкой
    // Связь с поддержкой
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Подтверждено';
      case 'cancelled':
        return 'Отменено';
      case 'completed':
        return 'Завершено';
      case 'pending':
        return 'Ожидание';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppTheme.success;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return AppTheme.primary;
      case 'pending':
        return Colors.orange;
      default:
        return AppTheme.gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        children: [
          // Header with back button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => AppNavigator.pop(),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Детали бронирования',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(_bookingDetails['status']),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(_bookingDetails['status']),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Booking details card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Информация о бронировании',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildDetailItem('Номер бронирования', _bookingDetails['id']),
                        _buildDetailItem('Услуга', _bookingDetails['service']),
                        _buildDetailItem('Тренер', _bookingDetails['trainer']),
                        _buildDetailItem('Дата', _bookingDetails['date']),
                        _buildDetailItem('Время', _bookingDetails['time']),
                        _buildDetailItem('Продолжительность', _bookingDetails['duration']),
                        _buildDetailItem('Место', _bookingDetails['court']),
                        _buildDetailItem('Стоимость', '${_bookingDetails['price']} ₽'),
                        _buildDetailItem('Способ оплаты', _bookingDetails['paymentMethod']),
                        _buildDetailItem('Создано', _bookingDetails['createdAt']),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Additional notes
                  if (_bookingDetails['notes'] != null && _bookingDetails['notes'].isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.light,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Дополнительная информация',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _bookingDetails['notes'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.gray,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Action buttons
                  if (_bookingDetails['status'] == 'confirmed')
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _rescheduleBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(16),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Перенести бронирование',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _cancelBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(16),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Отменить бронирование',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  // Support contact
                  Center(
                    child: TextButton(
                      onPressed: _contactSupport,
                      child: const Text(
                        'Связаться с поддержкой',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.gray,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}