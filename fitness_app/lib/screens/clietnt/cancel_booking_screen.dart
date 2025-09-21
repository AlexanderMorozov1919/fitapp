import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import '../../services/mock_data_service.dart';

class CancelBookingScreen extends StatefulWidget {
  final Booking booking;

  const CancelBookingScreen({super.key, required this.booking});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  String? _selectedReason;
  final List<String> _cancellationReasons = [
    'Изменились планы',
    'Неудобное время',
    'Нашел другую студию',
    'Проблемы со здоровьем',
    'Другая причина'
  ];

  void _confirmCancellation() {
    if (_selectedReason != null) {
      // Проверяем, что бронирование еще не прошло
      if (widget.booking.startTime.isBefore(DateTime.now())) {
        showErrorSnackBar(context, 'Нельзя отменить прошедшее бронирование');
        return;
      }
      
      // Обновляем статус бронирования через MockDataService
      // Для пользовательских бронирований используем метод для обновления статуса
      // Создаем обновленное бронирование с измененным статусом
      final updatedBooking = Booking(
        id: widget.booking.id,
        userId: widget.booking.userId,
        type: widget.booking.type,
        startTime: widget.booking.startTime,
        endTime: widget.booking.endTime,
        title: widget.booking.title,
        description: widget.booking.description,
        status: BookingStatus.cancelled,
        price: widget.booking.price,
        courtNumber: widget.booking.courtNumber,
        trainerId: widget.booking.trainerId,
        className: widget.booking.className,
        lockerNumber: widget.booking.lockerNumber,
        createdAt: widget.booking.createdAt,
        clientName: widget.booking.clientName,
        products: widget.booking.products,
      );
      
      // Обновляем бронирование в списке
      final index = MockDataService.userBookings.indexWhere((b) => b.id == widget.booking.id);
      if (index != -1) {
        MockDataService.userBookings[index] = updatedBooking;
      }
      
      showSuccessSnackBar(context, 'Бронирование отменено. Причина: $_selectedReason');
      final navigationService = NavigationService.of(context);
      navigationService?.navigateToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Отмена бронирования',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final navigationService = NavigationService.of(context);
            navigationService?.onBack();
          },
        ),
      ),
      body: Column(
        children: [
          // Информация о бронировании
          Container(
            padding: AppStyles.paddingLg,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppColors.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.booking.title,
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatters.formatDateDisplay(widget.booking.startTime),
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
                      '${DateFormatters.formatTime(widget.booking.startTime)}-${DateFormatters.formatTime(widget.booking.endTime)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Выбор причины
          Expanded(
            child: Padding(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите причину отмены:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Список причин отмены
                  Expanded(
                    child: ListView(
                      children: _cancellationReasons.map((reason) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppStyles.borderRadiusLg,
                            boxShadow: AppColors.shadowSm,
                          ),
                          child: RadioListTile<String>(
                            title: Text(
                              reason,
                              style: AppTextStyles.bodyMedium,
                            ),
                            value: reason,
                            groupValue: _selectedReason,
                            onChanged: (value) => setState(() => _selectedReason = value),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            tileColor: Colors.white,
                            activeColor: AppColors.primary,
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Кнопки действий
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Назад',
                          onPressed: () {
                            final navigationService = NavigationService.of(context);
                            navigationService?.onBack();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Подтвердить отмену',
                          onPressed: _confirmCancellation,
                          isEnabled: _selectedReason != null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}