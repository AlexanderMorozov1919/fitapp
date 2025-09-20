import 'package:flutter/material.dart';
import 'package:fitness_app/models/notification_model.dart';
import 'package:fitness_app/widgets/notification_overlay.dart';

// Объявление класса для доступа к состоянию
typedef NotificationManager = void Function(AppNotification);

class CustomNotificationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static NotificationManager? _notificationManager;

  static void initialize(NotificationManager manager) {
    _notificationManager = manager;
  }

  static void _ensureInitialized() {
    if (_notificationManager == null) {
      throw Exception('CustomNotificationService not initialized. Call initialize() first.');
    }
  }

  static void showNotification(AppNotification notification) {
    _ensureInitialized();
    _notificationManager!(notification);
  }

  static void showWelcomeNotification() {
    final notification = AppNotification(
      id: 'welcome_notification_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Добро пожаловать! 🎉',
      message: 'Ваш фитнес-клуб рад приветствовать вас! Начните свое путешествие к здоровому образу жизни прямо сейчас.',
      type: NotificationType.info,
      timestamp: DateTime.now(),
      data: {
        'action': 'welcome',
        'priority': 'high'
      },
    );
    showNotification(notification);
  }

  static void showPromoNotification() {
    final notification = AppNotification(
      id: 'promo_notification_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Специальное предложение! 🔥',
      message: 'Получите скидку 20% на все групповые занятия при бронировании до конца недели!',
      type: NotificationType.promo,
      timestamp: DateTime.now(),
      data: {
        'action': 'promo',
        'discount': 20,
        'category': 'group_classes'
      },
    );
    showNotification(notification);
  }

  static void showReminderNotification(String className, DateTime time) {
    final notification = AppNotification(
      id: 'reminder_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Напоминание о занятии ⏰',
      message: 'Ваше занятие "$className" начнется через 30 минут в ${_formatTime(time)}',
      type: NotificationType.reminder,
      timestamp: DateTime.now(),
      data: {
        'action': 'reminder',
        'class_name': className,
        'start_time': time.toIso8601String()
      },
    );
    showNotification(notification);
  }

  static void showBookingConfirmation(String serviceName, DateTime date) {
    final notification = AppNotification(
      id: 'booking_confirm_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Бронирование подтверждено! ✅',
      message: 'Вы успешно забронировали "$serviceName" на ${_formatDate(date)}',
      type: NotificationType.booking,
      timestamp: DateTime.now(),
      data: {
        'action': 'booking_confirmation',
        'service': serviceName,
        'date': date.toIso8601String()
      },
    );
    showNotification(notification);
  }

  static void showPaymentSuccess(double amount, String method) {
    final notification = AppNotification(
      id: 'payment_success_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Оплата прошла успешно! 💳',
      message: 'Сумма ${amount.toStringAsFixed(2)}₽ оплачена через $method. Спасибо за покупку!',
      type: NotificationType.payment,
      timestamp: DateTime.now(),
      data: {
        'action': 'payment_success',
        'amount': amount,
        'method': method
      },
    );
    showNotification(notification);
  }

  static void showSystemMaintenance() {
    final notification = AppNotification(
      id: 'system_maintenance_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Технические работы 🛠️',
      message: 'Запланированы технические работы с 02:00 до 04:00. Приносим извинения за временные неудобства.',
      type: NotificationType.system,
      timestamp: DateTime.now(),
      data: {
        'action': 'maintenance',
        'start_time': '02:00',
        'end_time': '04:00'
      },
    );
    showNotification(notification);
  }

  // Вспомогательные методы для форматирования
  static String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String _formatDate(DateTime date) {
    final months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Метод для очистки ссылки
  static void dispose() {
    _notificationManager = null;
  }
}