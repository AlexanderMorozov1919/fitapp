import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import './custom_notification_service.dart';
import '../models/notification_model.dart';

class NotificationService {
  static void showSuccess(BuildContext context, String message) {
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'success_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Успешно',
        message: message,
        type: NotificationType.success,
        timestamp: DateTime.now(),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Ошибка',
        message: message,
        type: NotificationType.error,
        timestamp: DateTime.now(),
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'warning_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Предупреждение',
        message: message,
        type: NotificationType.info,
        timestamp: DateTime.now(),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'info_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Информация',
        message: message,
        type: NotificationType.info,
        timestamp: DateTime.now(),
      ),
    );
  }

  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Подтвердить',
    String cancelText = 'Отмена',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppTextStyles.headline5,
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: AppStyles.primaryButtonStyle,
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  static void showBookingNotification(String bookingType, String bookingName) {
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Бронирование создано',
        message: 'Вы забронировали $bookingType "$bookingName". Оплатите в течение 15 минут для подтверждения.',
        type: NotificationType.info,
        timestamp: DateTime.now(),
      ),
    );
  }

  static void showTrainingNotification(String trainingType, String trainerName) {
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'training_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Запись на тренировку',
        message: 'Вы записались на $trainingType у тренера $trainerName. Оплатите в течение 15 минут для подтверждения.',
        type: NotificationType.info,
        timestamp: DateTime.now(),
      ),
    );
  }

  static void showPaymentSuccessNotification(String itemName) {
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'payment_success_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Оплата подтверждена',
        message: 'Оплата за "$itemName" успешно подтверждена. Бронирование активно.',
        type: NotificationType.success,
        timestamp: DateTime.now(),
      ),
    );
  }

  static void showPaymentWarningNotification(String itemName) {
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'payment_warning_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Требуется оплата',
        message: 'Бронирование "$itemName" ожидает оплаты. Оплатите в течение 15 минут.',
        type: NotificationType.warning,
        timestamp: DateTime.now(),
      ),
    );
  }
}