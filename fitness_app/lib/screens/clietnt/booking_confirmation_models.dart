import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../models/booking_model.dart' as booking_models;
import '../../models/product_model.dart';

/// Типы бронирования для универсального экрана
enum ConfirmationBookingType {
  personalTraining,
  groupClass,
  tennisCourt,
  scheduleClass,
}

/// Конфигурация для отображения информации о бронировании
class BookingConfirmationConfig {
  final ConfirmationBookingType type;
  final String title;
  final String serviceName;
  final double price;
  final DateTime date;
  final TimeOfDay? time;
  final DateTime? startTime;
  final DateTime? endTime;
  final Trainer? trainer;
  final GroupClass? groupClass;
  final booking_models.TennisCourt? court;
  final String? location;
  final String? description;
  final bool isEmployeeBooking;

  BookingConfirmationConfig({
    required this.type,
    required this.title,
    required this.serviceName,
    required this.price,
    required this.date,
    this.time,
    this.startTime,
    this.endTime,
    this.trainer,
    this.groupClass,
    this.court,
    this.location,
    this.description,
    this.isEmployeeBooking = false,
  });

  /// Создает конфигурацию из данных бронирования
  factory BookingConfirmationConfig.fromMap(Map<String, dynamic> data) {
    final type = data['type'] as ConfirmationBookingType;
    
    switch (type) {
      case ConfirmationBookingType.personalTraining:
        return BookingConfirmationConfig(
          type: type,
          title: data['title'] ?? 'Персональная тренировка',
          serviceName: data['serviceName'] as String,
          price: data['price'] as double,
          date: data['date'] as DateTime,
          time: data['time'] as TimeOfDay,
          trainer: data['trainer'] as Trainer,
        );
      
      case ConfirmationBookingType.groupClass:
        final groupClass = data['groupClass'] as GroupClass;
        return BookingConfirmationConfig(
          type: type,
          title: 'Групповое занятие',
          serviceName: groupClass.name,
          price: groupClass.price,
          date: groupClass.startTime,
          startTime: groupClass.startTime,
          endTime: groupClass.endTime,
          groupClass: groupClass,
          location: groupClass.location,
          description: '${groupClass.type} • ${groupClass.level}',
        );
      
      case ConfirmationBookingType.tennisCourt:
        final court = data['court'] as booking_models.TennisCourt;
        return BookingConfirmationConfig(
          type: type,
          title: 'Теннисный корт',
          serviceName: court.number,
          price: data['totalPrice'] as double,
          date: data['date'] as DateTime,
          startTime: DateTime(
            data['date'].year,
            data['date'].month,
            data['date'].day,
            (data['startTime'] as TimeOfDay).hour,
            (data['startTime'] as TimeOfDay).minute,
          ),
          endTime: DateTime(
            data['date'].year,
            data['date'].month,
            data['date'].day,
            (data['endTime'] as TimeOfDay).hour,
            (data['endTime'] as TimeOfDay).minute,
          ),
          court: court,
          location: '${court.surfaceType} • ${court.isIndoor ? 'Крытый' : 'Открытый'}',
        );
      
      case ConfirmationBookingType.scheduleClass:
        final groupClass = data['groupClass'] as GroupClass;
        return BookingConfirmationConfig(
          type: type,
          title: 'Групповое занятие',
          serviceName: groupClass.name,
          price: groupClass.price,
          date: groupClass.startTime,
          startTime: groupClass.startTime,
          endTime: groupClass.endTime,
          groupClass: groupClass,
          location: groupClass.location,
          description: '${groupClass.type} • ${groupClass.level}',
        );
    }
  }
}

/// Вспомогательные методы для работы с типами бронирования
extension ConfirmationBookingTypeExtension on ConfirmationBookingType {
  booking_models.BookingType toBookingType() {
    switch (this) {
      case ConfirmationBookingType.personalTraining:
        return booking_models.BookingType.personalTraining;
      case ConfirmationBookingType.groupClass:
      case ConfirmationBookingType.scheduleClass:
        return booking_models.BookingType.groupClass;
      case ConfirmationBookingType.tennisCourt:
        return booking_models.BookingType.tennisCourt;
    }
  }

  String getButtonText(double price, {bool isEmployee = false}) {
    if (isEmployee) {
      return 'Подтвердить';
    }
    
    switch (this) {
      case ConfirmationBookingType.personalTraining:
      case ConfirmationBookingType.tennisCourt:
        return 'Подтвердить и оплатить';
      case ConfirmationBookingType.groupClass:
      case ConfirmationBookingType.scheduleClass:
        return price > 0 ? 'Подтвердить и оплатить' : 'Подтвердить запись';
    }
  }

  bool get shouldShowProductsSection {
    return this == ConfirmationBookingType.personalTraining ||
           this == ConfirmationBookingType.groupClass ||
           this == ConfirmationBookingType.scheduleClass ||
           this == ConfirmationBookingType.tennisCourt;
  }
}

/// Вспомогательные методы для работы с конфигурацией
extension BookingConfirmationConfigExtension on BookingConfirmationConfig {
  /// Создает объект Booking из конфигурации
  booking_models.Booking toBooking(List<CartItem> selectedProducts, String userId) {
    final id = '${type.toString().split('.').last}_${DateTime.now().millisecondsSinceEpoch}';
    final isEmployeeBooking = this.isEmployeeBooking;
    
    switch (type) {
      case ConfirmationBookingType.personalTraining:
        final startDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time!.hour,
          time!.minute,
        );
        final endDateTime = startDateTime.add(const Duration(hours: 1));

        return booking_models.Booking(
          id: id,
          userId: userId,
          type: booking_models.BookingType.personalTraining,
          startTime: startDateTime,
          endTime: endDateTime,
          title: '$serviceName с ${trainer!.fullName}',
          description: 'Персональная тренировка',
          status: isEmployeeBooking ? booking_models.BookingStatus.confirmed : booking_models.BookingStatus.awaitingPayment,
          price: price,
          trainerId: trainer!.id,
          createdAt: DateTime.now(),
          products: selectedProducts,
        );

      case ConfirmationBookingType.groupClass:
      case ConfirmationBookingType.scheduleClass:
        return booking_models.Booking(
          id: id,
          userId: userId,
          type: booking_models.BookingType.groupClass,
          startTime: startTime!,
          endTime: endTime!,
          title: groupClass!.name,
          description: '${groupClass!.type} • ${groupClass!.level}',
          status: isEmployeeBooking ? booking_models.BookingStatus.confirmed :
                  (price > 0 ? booking_models.BookingStatus.awaitingPayment : booking_models.BookingStatus.confirmed),
          price: price,
          className: groupClass!.name,
          createdAt: DateTime.now(),
          products: selectedProducts,
        );

      case ConfirmationBookingType.tennisCourt:
        return booking_models.Booking(
          id: id,
          userId: userId,
          type: booking_models.BookingType.tennisCourt,
          startTime: startTime!,
          endTime: endTime!,
          title: 'Теннисный корт ${court!.number}',
          description: '${court!.surfaceType} • ${court!.isIndoor ? 'Крытый' : 'Открытый'}',
          status: isEmployeeBooking ? booking_models.BookingStatus.confirmed : booking_models.BookingStatus.awaitingPayment,
          price: price,
          courtNumber: court!.number,
          createdAt: DateTime.now(),
          products: selectedProducts,
        );
    }
  }
}