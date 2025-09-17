import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/booking_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';

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
          // Фильтры - горизонтальный скролл
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
                    child: FilterChipWidget(
                      label: filter,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
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
    return AppCard(
      padding: AppStyles.paddingLg,
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
              StatusBadge(
                text: booking.statusText,
                color: booking.statusColor,
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
                DateFormatters.formatDateDisplay(booking.startTime),
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
                '${DateFormatters.formatTime(booking.startTime)}-${DateFormatters.formatTime(booking.endTime)}',
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
            _buildDetailItem('Стоимость:', DateFormatters.formatPrice(booking.price)),
          ],
          
          const SizedBox(height: 16),
          
          // Действия
          if (booking.status == BookingStatus.confirmed && booking.canCancel)
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Отменить',
                    onPressed: () => _cancelBooking(booking),
                    color: AppColors.error,
                  ),
                ),
                if (booking.type == BookingType.tennisCourt ||
                    booking.type == BookingType.personalTraining) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Изменить',
                      onPressed: () => _modifyBooking(booking),
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
    return EmptyState(
      icon: Icons.calendar_today,
      title: _getEmptyStateMessage(),
      subtitle: _getEmptyStateSubtitle(),
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
    showConfirmDialog(
      context: context,
      title: 'Отмена бронирования',
      content: 'Вы уверены, что хотите отменить это бронирование?',
      confirmText: 'Да, отменить',
      confirmColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        _showCancellationSuccess();
      }
    });
  }

  void _modifyBooking(Booking booking) {
    showSuccessSnackBar(context, 'Функционал изменения бронирования в разработке');
  }

  void _showCancellationSuccess() {
    showSuccessSnackBar(context, 'Бронирование успешно отменено');
  }

  String _getTrainerName(String trainerId) {
    final trainer = MockDataService.trainers
        .firstWhere((t) => t.id == trainerId, orElse: () => MockDataService.trainers.first);
    return trainer.fullName;
  }
}