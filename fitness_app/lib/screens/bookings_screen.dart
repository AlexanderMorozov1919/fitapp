import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/booking_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Мои записи',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Фильтры - горизонтальный скролл как в расписании
          Container(
            padding: AppStyles.paddingLg,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppColors.shadowSm,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.background,
                          borderRadius: AppStyles.borderRadiusFull,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: AppTextStyles.caption.copyWith(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Список бронирований
          // Список бронирований
          Expanded(
            child: filteredBookings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: AppStyles.paddingLg,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: AppStyles.paddingLg,
      decoration: AppStyles.elevatedCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок и статус
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.title,
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: booking.statusColor.withOpacity(0.1),
                  borderRadius: AppStyles.borderRadiusSm,
                ),
                child: Text(
                  booking.statusText,
                  style: AppTextStyles.overline.copyWith(
                    color: booking.statusColor,
                    fontWeight: FontWeight.bold,
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
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          
          const SizedBox(height: 12),
          
          // Время и дата
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(booking.startTime),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                '${_formatTime(booking.startTime)}-${_formatTime(booking.endTime)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
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
            _buildDetailItem('Стоимость:', '${booking.price} ₽'),
          ],
          
          const SizedBox(height: 16),
          
          // Действия
          if (booking.status == BookingStatus.confirmed && booking.canCancel)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _cancelBooking(booking),
                    style: AppStyles.secondaryButtonStyle.copyWith(
                      foregroundColor: MaterialStateProperty.all(AppColors.error),
                      side: MaterialStateProperty.all(BorderSide(color: AppColors.error)),
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
                      style: AppStyles.primaryButtonStyle,
                      child: const Text('Изменить'),
                    ),
                  ),
                ],
              ],
            ),
        ],
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
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppStyles.paddingLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyStateMessage(),
              style: AppTextStyles.headline5.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptyStateSubtitle(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        title: Text(
          'Отмена бронирования',
          style: AppTextStyles.headline5,
        ),
        content: Text(
          'Вы уверены, что хотите отменить бронирование?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Нет',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showCancellationSuccess();
            },
            child: Text(
              'Да, отменить',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _modifyBooking(Booking booking) {
    // TODO: Реализовать изменение бронирования
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Функционал изменения бронирования в разработке',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.borderRadiusLg,
        ),
      ),
    );
  }

  void _showCancellationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Бронирование успешно отменено',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.borderRadiusLg,
        ),
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