import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';

class CancelBookingModal extends StatefulWidget {
  final Booking booking;
  final Function(String) onCancelConfirmed;

  const CancelBookingModal({
    super.key,
    required this.booking,
    required this.onCancelConfirmed,
  });

  @override
  State<CancelBookingModal> createState() => _CancelBookingModalState();
}

class _CancelBookingModalState extends State<CancelBookingModal> {
  String? _selectedReason;
  final List<String> _cancellationReasons = [
    'Изменились планы',
    'Неудобное время',
    'Нашел другую студию',
    'Проблемы со здоровьем',
    'Другая причина'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Отмена бронирования',
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Выберите причину отмены:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Список причин отмены
          ..._cancellationReasons.map((reason) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RadioListTile<String>(
              title: Text(
                reason,
                style: AppTextStyles.bodyMedium,
              ),
              value: reason,
              groupValue: _selectedReason,
              onChanged: (value) => setState(() => _selectedReason = value),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          )).toList(),
          
          const SizedBox(height: 20),
          
          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Назад',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Подтвердить отмену',
                  onPressed: () {
                    widget.onCancelConfirmed(_selectedReason!);
                    Navigator.pop(context);
                  },
                  isEnabled: _selectedReason != null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}