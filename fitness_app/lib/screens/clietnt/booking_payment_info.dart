import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';

class BookingPaymentInfo extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onPayDifference;
  final bool showPayButton;

  const BookingPaymentInfo({
    super.key,
    required this.booking,
    this.onPayDifference,
    this.showPayButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasPaymentDifference = booking.priceDifference != 0;
    
    if (!hasPaymentDifference) {
      return const SizedBox();
    }

    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: booking.priceDifference > 0 
            ? AppColors.warning.withOpacity(0.1)
            : AppColors.success.withOpacity(0.1),
        borderRadius: AppStyles.borderRadiusLg,
        border: Border.all(
          color: booking.priceDifference > 0 
              ? AppColors.warning.withOpacity(0.3)
              : AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                booking.priceDifference > 0 ? Icons.warning : Icons.attach_money,
                size: 20,
                color: booking.priceDifference > 0 ? AppColors.warning : AppColors.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.priceDifference > 0 
                    ? 'Требуется доплата'
                    : 'Ожидается возврат',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: booking.priceDifference > 0 ? AppColors.warning : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            booking.priceDifference > 0
              ? 'Необходимо доплатить ${booking.priceDifference.abs().toInt()} ₽ за изменение времени бронирования'
              : 'Вам будет возвращено ${booking.priceDifference.abs().toInt()} ₽ администратором',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (showPayButton && booking.priceDifference > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Оплатить разницу',
                onPressed: onPayDifference ?? () {},
              ),
            ),
          ],
        ],
      ),
    );
  }
}