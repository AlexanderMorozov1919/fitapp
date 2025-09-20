import 'package:flutter/material.dart';

enum BookingStatus {
  confirmed,
  pending,
  cancelled,
  completed,
  awaitingPayment,
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
      case BookingStatus.awaitingPayment:
        return Colors.amber;
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
      case BookingStatus.awaitingPayment:
        return 'Ожидает оплаты';
    }
  }
}

class TennisCourt {
  final String id;
  final String number;
  final String surfaceType;
  final bool isIndoor;
  final bool isAvailable;
  final double basePricePerHour;
  final double morningPriceMultiplier;
  final double dayPriceMultiplier;
  final double eveningPriceMultiplier;
  final double weekendPriceMultiplier;
  final List<DateTime> bookedSlots;

  TennisCourt({
    required this.id,
    required this.number,
    required this.surfaceType,
    required this.isIndoor,
    required this.isAvailable,
    required this.basePricePerHour,
    this.morningPriceMultiplier = 0.8,
    this.dayPriceMultiplier = 1.0,
    this.eveningPriceMultiplier = 1.2,
    this.weekendPriceMultiplier = 1.5,
    this.bookedSlots = const [],
  });

  double getPriceForTime(DateTime time) {
    final hour = time.hour;
    final isWeekend = time.weekday == DateTime.saturday || time.weekday == DateTime.sunday;
    
    double multiplier = dayPriceMultiplier;
    
    if (hour >= 6 && hour < 10) {
      multiplier = morningPriceMultiplier;
    } else if (hour >= 10 && hour < 17) {
      multiplier = dayPriceMultiplier;
    } else if (hour >= 17 && hour < 23) {
      multiplier = eveningPriceMultiplier;
    }
    
    if (isWeekend) {
      multiplier *= weekendPriceMultiplier;
    }
    
    return (basePricePerHour * multiplier).roundToDouble();
  }

  String getPriceDescription(DateTime time) {
    final price = getPriceForTime(time);
    final hour = time.hour;
    
    String timeOfDay;
    if (hour >= 6 && hour < 10) {
      timeOfDay = 'утренний';
    } else if (hour >= 10 && hour < 17) {
      timeOfDay = 'дневной';
    } else if (hour >= 17 && hour < 23) {
      timeOfDay = 'вечерний';
    } else {
      timeOfDay = 'ночной';
    }
    
    final isWeekend = time.weekday == DateTime.saturday || time.weekday == DateTime.sunday;
    final dayType = isWeekend ? 'выходной' : 'будний';
    
    return '$price ₽/час ($timeOfDay тариф, $dayType день)';
  }

  double calculateTotalPrice(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    final totalHours = duration.inHours.toDouble();
    
    if (totalHours <= 0) return 0;
    
    double totalPrice = 0;
    DateTime currentTime = startTime;
    
    // Рассчитываем стоимость для каждого часа отдельно
    for (int i = 0; i < totalHours; i++) {
      final hourTime = currentTime.add(Duration(hours: i));
      totalPrice += getPriceForTime(hourTime);
    }
    
    return totalPrice;
  }

  String getMultiTariffDescription(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    final totalHours = duration.inHours;
    
    if (totalHours <= 0) return '';
    
    final tariffs = <String, int>{};
    
    // Собираем информацию о тарифах для каждого часа
    for (int i = 0; i < totalHours; i++) {
      final hourTime = startTime.add(Duration(hours: i));
      final tariffDesc = getPriceDescription(hourTime);
      
      // Извлекаем название тарифа из описания
      final tariffMatch = RegExp(r'\((.*?) тариф').firstMatch(tariffDesc);
      if (tariffMatch != null) {
        final tariffName = tariffMatch.group(1)!;
        tariffs[tariffName] = (tariffs[tariffName] ?? 0) + 1;
      }
    }
    
    // Формируем описание с количеством часов по каждому тарифу
    if (tariffs.length == 1) {
      final tariffName = tariffs.keys.first;
      final hours = tariffs.values.first;
      return '$hours ч ($tariffName тариф)';
    } else {
      final parts = tariffs.entries.map((e) => '${e.value}ч (${e.key})').join(' + ');
      return parts;
    }
  }

  bool isTimeSlotAvailable(DateTime startTime, int durationHours) {
    final endTime = startTime.add(Duration(hours: durationHours));
    
    // Проверяем, не пересекается ли запрашиваемое время с занятыми слотами
    for (final bookedSlot in bookedSlots) {
      final bookedEnd = bookedSlot.add(const Duration(hours: 1));
      
      // Если запрашиваемое время пересекается с занятым слотом
      if (startTime.isBefore(bookedEnd) && endTime.isAfter(bookedSlot)) {
        return false;
      }
    }
    
    return true;
  }

  void bookTimeSlot(DateTime startTime, int durationHours) {
    // Добавляем все часы бронирования в занятые слоты
    for (int i = 0; i < durationHours; i++) {
      final slotTime = startTime.add(Duration(hours: i));
      bookedSlots.add(slotTime);
    }
  }

  void releaseTimeSlot(DateTime startTime, int durationHours) {
    // Удаляем все часы бронирования из занятых слотов
    for (int i = 0; i < durationHours; i++) {
      final slotTime = startTime.add(Duration(hours: i));
      bookedSlots.removeWhere((slot) => slot.isAtSameMomentAs(slotTime));
    }
  }
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

class FreeTimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;

  FreeTimeSlot({
    required this.startTime,
    required this.endTime,
  }) : duration = endTime.difference(startTime);

  String get formattedTime {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  bool get isLongEnoughForTraining => duration.inMinutes >= 30;
}