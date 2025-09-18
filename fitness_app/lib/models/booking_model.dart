import 'package:flutter/material.dart';

enum BookingStatus {
  confirmed,
  pending,
  cancelled,
  completed,
}

enum BookingType {
  tennisCourt,
  groupClass,
  personalTraining,
  locker,
}

class Booking {
  final String id;
  final String userId;
  final BookingType type;
  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String? description;
  final BookingStatus status;
  final double price;
  final String? courtNumber;
  final String? trainerId;
  final String? className;
  final String? lockerNumber;
  final DateTime createdAt;
  final String? clientName;

  Booking({
    required this.id,
    required this.userId,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.title,
    this.description,
    required this.status,
    this.price = 0,
    this.courtNumber,
    this.trainerId,
    this.className,
    this.lockerNumber,
    required this.createdAt,
    this.clientName,
  });

  bool get isUpcoming => status == BookingStatus.confirmed && 
                        startTime.isAfter(DateTime.now());
  bool get isActive => status == BookingStatus.confirmed && 
                     startTime.isBefore(DateTime.now()) && 
                     endTime.isAfter(DateTime.now());
  bool get canCancel => status == BookingStatus.confirmed && 
                      startTime.difference(DateTime.now()).inHours > 2;

  Color get statusColor {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  String get statusText {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Подтверждено';
      case BookingStatus.pending:
        return 'Ожидание';
      case BookingStatus.cancelled:
        return 'Отменено';
      case BookingStatus.completed:
        return 'Завершено';
    }
  }
}

class TennisCourt {
  final String id;
  final String number;
  final String surfaceType;
  final bool isIndoor;
  final bool isAvailable;
  final double pricePerHour;
  final List<DateTime> bookedSlots;

  var size;

  TennisCourt({
    required this.id,
    required this.number,
    required this.surfaceType,
    required this.isIndoor,
    required this.isAvailable,
    required this.pricePerHour,
    this.bookedSlots = const [],
  });
}

class Locker {
  final String id;
  final String number;
  final String size;
  final bool isAvailable;
  final double pricePerDay;
  final DateTime? rentalEndDate;

  Locker({
    required this.id,
    required this.number,
    required this.size,
    required this.isAvailable,
    required this.pricePerDay,
    this.rentalEndDate,
  });

  bool get isRented => rentalEndDate != null && 
                      rentalEndDate!.isAfter(DateTime.now());
}