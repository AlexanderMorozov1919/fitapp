import 'package:flutter/material.dart';
import 'product_model.dart';

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
  final List<CartItem> products;
  final double priceDifference;

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
    this.products = const [],
    this.priceDifference = 0,
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

  double get totalPrice {
    final productsPrice = products.fold(0.0, (sum, item) => sum + item.totalPrice);
    return price + productsPrice;
  }

  String get formattedTotalPrice => '${totalPrice.toInt()} ₽';

  bool get hasProducts => products.isNotEmpty;

  int get totalProductsQuantity {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get hasPaymentDifference => priceDifference != 0;
  bool get requiresAdditionalPayment => priceDifference > 0;
  bool get requiresRefund => priceDifference < 0;
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
    
    double multiplier;
    
    if (hour >= 6 && hour < 10) {
      multiplier = morningPriceMultiplier;
    } else if (hour >= 10 && hour < 17) {
      multiplier = dayPriceMultiplier;
    } else if (hour >= 17 && hour < 23) {
      multiplier = eveningPriceMultiplier;
    } else {
      multiplier = dayPriceMultiplier; // Ночное время по дневному тарифу
    }
    
    // Для выходных используем только выходной множитель, не умножаем на дневной
    if (isWeekend) {
      multiplier = weekendPriceMultiplier;
    }
    
    return (basePricePerHour * multiplier).roundToDouble();
  }

  String getPriceDescription(DateTime time) {
    final price = getPriceForTime(time);
    final hour = time.hour;
    final isWeekend = time.weekday == DateTime.saturday || time.weekday == DateTime.sunday;
    
    if (isWeekend) {
      return '$price ₽/час (выходной тариф)';
    }
    
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
    
    return '$price ₽/час ($timeOfDay тариф, будний день)';
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
    
    final isWeekend = startTime.weekday == DateTime.saturday ||
                     startTime.weekday == DateTime.sunday;
    
    // Если это выходной день, все часы по одному тарифу
    if (isWeekend) {
      return '$totalHours ч (выходной тариф)';
    }
    
    final tariffs = <String, int>{};
    
    // Собираем информацию о тарифах для каждого часа
    for (int i = 0; i < totalHours; i++) {
      final hourTime = startTime.add(Duration(hours: i));
      final hour = hourTime.hour;
      
      String tariffName;
      if (hour >= 6 && hour < 10) {
        tariffName = 'утренний';
      } else if (hour >= 10 && hour < 17) {
        tariffName = 'дневной';
      } else if (hour >= 17 && hour < 23) {
        tariffName = 'вечерний';
      } else {
        tariffName = 'ночной';
      }
      
      tariffs[tariffName] = (tariffs[tariffName] ?? 0) + 1;
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
      // Бронирование доступно, если оно начинается точно в конце занятого слота
      // или заканчивается точно в начале занятого слота
      if (startTime.isBefore(bookedEnd) && endTime.isAfter(bookedSlot)) {
        // Разрешаем бронирование, если оно начинается сразу после окончания занятого времени
        if (startTime.isAtSameMomentAs(bookedEnd)) {
          continue;
        }
        // Разрешаем бронирование, если оно заканчивается прямо перед началом занятого времени
        if (endTime.isAtSameMomentAs(bookedSlot)) {
          continue;
        }
        return false;
      }
    }
    
    return true;
  }

  void bookTimeSlot(DateTime startTime, int durationHours) {
    // Добавляем все часы бронирования в занятые слоты
    for (int i = 0; i < durationHours; i++) {
      final slotTime = startTime.add(Duration(hours: i));
      // Проверяем, нет ли уже этого времени в списке
      if (!bookedSlots.any((slot) => slot.isAtSameMomentAs(slotTime))) {
        bookedSlots.add(slotTime);
      }
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