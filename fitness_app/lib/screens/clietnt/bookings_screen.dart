import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import 'booking_detail_screen.dart';

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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildBookingItem(filteredBookings[index]),
                      );
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

  Widget _buildBookingItem(Booking booking) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _navigateToBookingDetail(booking),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: AppStyles.paddingLg,
          decoration: AppStyles.elevatedCardDecoration.copyWith(
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и время с индикатором кликабельности
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
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
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: AppStyles.borderRadiusLg,
                  ),
                  child: Text(
                    '${DateFormatters.formatTime(booking.startTime)}-${DateFormatters.formatTime(booking.endTime)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Информация о бронировании
            Text(
              _getBookingDetails(booking),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 8),
            
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
            
            // Детали и статус
            Row(
              children: [
                // Дата
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatters.formatDate(booking.startTime),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Статус
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: AppStyles.borderRadiusSm,
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
            
            // Цена и действия
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Цена
                if (booking.price > 0)
                  Text(
                    '${booking.price.toInt()} ₽',
                    style: AppTextStyles.price.copyWith(
                      fontSize: 18,
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
            
            // Дополнительная информация
            if (booking.courtNumber != null ||
                booking.trainerId != null ||
                booking.className != null ||
                booking.lockerNumber != null) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 12),
              
              if (booking.courtNumber != null)
                _buildDetailItem('Корт:', booking.courtNumber!),
              if (booking.trainerId != null)
                _buildDetailItem('Тренер:', _getTrainerName(booking.trainerId!)),
              if (booking.className != null)
                _buildDetailItem('Занятие:', booking.className!),
              if (booking.lockerNumber != null)
                _buildDetailItem('Шкафчик:', booking.lockerNumber!),
            ],
          ],
        ),
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

  String _getBookingDetails(Booking booking) {
    final details = <String>[];
    
    switch (booking.type) {
      case BookingType.tennisCourt:
        details.add('Теннисный корт');
        break;
      case BookingType.groupClass:
        details.add('Групповое занятие');
        break;
      case BookingType.personalTraining:
        details.add('Персональная тренировка');
        break;
      case BookingType.locker:
        details.add('Аренда шкафчика');
        break;
    }
    
    if (booking.trainerId != null) {
      details.add(_getTrainerName(booking.trainerId!));
    }
    
    return details.join(' • ');
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
        // Обновляем статус бронирования
        final updatedBooking = Booking(
          id: booking.id,
          userId: booking.userId,
          type: booking.type,
          startTime: booking.startTime,
          endTime: booking.endTime,
          title: booking.title,
          description: booking.description,
          status: BookingStatus.cancelled,
          price: booking.price,
          courtNumber: booking.courtNumber,
          trainerId: booking.trainerId,
          className: booking.className,
          lockerNumber: booking.lockerNumber,
          createdAt: booking.createdAt,
          clientName: booking.clientName,
          products: booking.products,
        );
        
        // Обновляем бронирование в списке
        final index = MockDataService.userBookings.indexWhere((b) => b.id == booking.id);
        if (index != -1) {
          MockDataService.userBookings[index] = updatedBooking;
          setState(() {}); // Обновляем UI
        }
        
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

  void _navigateToBookingDetail(Booking booking) {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('booking_detail', booking);
    } else {
      // Альтернативная навигация для случаев, когда NavigationService недоступен
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookingDetailScreen(booking: booking),
        ),
      );
    }
  }

  IconData _getBookingIcon(Booking booking) {
    switch (booking.type) {
      case BookingType.tennisCourt:
        return Icons.sports_tennis;
      case BookingType.groupClass:
        return Icons.group;
      case BookingType.personalTraining:
        return Icons.person;
      case BookingType.locker:
        return Icons.lock;
      default:
        return Icons.calendar_today;
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.awaitingPayment:
        return AppColors.warning;
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
      case BookingStatus.awaitingPayment:
        return 'Ожидает оплаты';
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