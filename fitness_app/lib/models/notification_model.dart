import 'package:flutter/material.dart';

enum NotificationType {
  reminder,
  info,
  promo,
  booking,
  payment,
  system,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? relatedId; // ID связанного объекта (бронирование, платеж и т.д.)
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.relatedId,
    this.data,
  });

  Color get typeColor {
    switch (type) {
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.promo:
        return Colors.green;
      case NotificationType.booking:
        return Colors.purple;
      case NotificationType.payment:
        return Colors.teal;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  IconData get typeIcon {
    switch (type) {
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.info:
        return Icons.info;
      case NotificationType.promo:
        return Icons.local_offer;
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.system:
        return Icons.settings;
    }
  }

  String get typeText {
    switch (type) {
      case NotificationType.reminder:
        return 'Напоминание';
      case NotificationType.info:
        return 'Информация';
      case NotificationType.promo:
        return 'Акция';
      case NotificationType.booking:
        return 'Бронирование';
      case NotificationType.payment:
        return 'Платеж';
      case NotificationType.system:
        return 'Системное';
    }
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? relatedId,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      data: data ?? this.data,
    );
  }
}