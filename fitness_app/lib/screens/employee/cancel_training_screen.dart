import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import '../../services/mock_data_service.dart';

class CancelTrainingScreen extends StatefulWidget {
  final Booking training;

  const CancelTrainingScreen({super.key, required this.training});

  @override
  State<CancelTrainingScreen> createState() => _CancelTrainingScreenState();
}

class _CancelTrainingScreenState extends State<CancelTrainingScreen> {
  String? _selectedReason;
  final List<String> _cancellationReasons = [
    'Клиент отменил',
    'Неудобное время для клиента',
    'Проблемы со здоровьем клиента',
    'Технические проблемы',
    'Перенос на другое время',
    'Другая причина'
  ];

  void _confirmCancellation() {
    if (_selectedReason != null) {
      // Обновляем статус тренировки через MockDataService
      MockDataService.updateEmployeeTrainingStatus(
        widget.training.id,
        BookingStatus.cancelled,
        cancellationReason: _selectedReason
      );
      
      showSuccessSnackBar(context, 'Тренировка отменена. Причина: $_selectedReason');
      final navigationService = NavigationService.of(context);
      navigationService?.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Отмена тренировки',
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
          // Информация о тренировке
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
                  widget.training.title,
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
                      DateFormatters.formatDateDisplay(widget.training.startTime),
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
                      '${DateFormatters.formatTime(widget.training.startTime)}-${DateFormatters.formatTime(widget.training.endTime)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                if (widget.training.clientName != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Клиент: ${widget.training.clientName}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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