import 'package:flutter/material.dart';

class Trainer {
  final String id;
  final String firstName;
  final String lastName;
  final String specialty;
  final String bio;
  final double rating;
  final int totalReviews;
  final List<String> certifications;
  final String? photoUrl;
  final List<String> availableSports;
  final Map<String, double> hourlyRates;
  final List<WorkSchedule> schedule;
  final List<Review> reviews;
  final List<DateTime> bookedSlots;

  Trainer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialty,
    required this.bio,
    this.rating = 0,
    this.totalReviews = 0,
    this.certifications = const [],
    this.photoUrl,
    this.availableSports = const [],
    this.hourlyRates = const {},
    this.schedule = const [],
    this.reviews = const [],
    this.bookedSlots = const [],
  });

  String get fullName => '$firstName $lastName';
  String get displayRating => rating.toStringAsFixed(1);
  bool get isAvailable => schedule.any((slot) => slot.isAvailable);

  // Проверяет, свободен ли тренер в указанное время
  bool isTimeAvailable(DateTime dateTime) {
    // Проверяем, что время не в прошлом
    if (dateTime.isBefore(DateTime.now())) {
      return false;
    }

    // Проверяем, что время не в заблокированных слотах
    for (final bookedSlot in bookedSlots) {
      if (_isSameTimeSlot(bookedSlot, dateTime)) {
        return false;
      }
    }

    // Проверяем рабочее расписание тренера
    final dayOfWeek = dateTime.weekday;
    final time = TimeOfDay.fromDateTime(dateTime);
    
    return schedule.any((workSlot) =>
        workSlot.date.weekday == dayOfWeek &&
        _isTimeInRange(time, workSlot.startTime, workSlot.endTime) &&
        workSlot.isAvailable);
  }

  // Получает список доступных дат в указанном диапазоне
  List<DateTime> getAvailableDates(DateTime startDate, DateTime endDate) {
    final availableDates = <DateTime>[];
    var currentDate = startDate;
    
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      if (isDateAvailable(currentDate)) {
        availableDates.add(currentDate);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return availableDates;
  }

  // Проверяет, есть ли свободные слоты на указанную дату
  bool isDateAvailable(DateTime date) {
    // Проверяем рабочее расписание на этот день недели
    final dayOfWeek = date.weekday;
    final hasWorkSchedule = schedule.any((slot) => slot.date.weekday == dayOfWeek && slot.isAvailable);
    
    if (!hasWorkSchedule) {
      return false;
    }

    // Проверяем, есть ли хотя бы один свободный слот на эту дату
    final workSlots = schedule.where((slot) => slot.date.weekday == dayOfWeek && slot.isAvailable);
    
    for (final workSlot in workSlots) {
      var currentTime = workSlot.startTime;
      while (_isTimeBefore(currentTime, workSlot.endTime)) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          currentTime.hour,
          currentTime.minute,
        );
        
        if (isTimeAvailable(dateTime)) {
          return true;
        }
        
        currentTime = _addMinutes(currentTime, 60);
      }
    }
    
    return false;
  }

  // Вспомогательные методы для работы со временем
  bool _isSameTimeSlot(DateTime slot1, DateTime slot2) {
    return slot1.year == slot2.year &&
        slot1.month == slot2.month &&
        slot1.day == slot2.day &&
        slot1.hour == slot2.hour;
  }

  bool _isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final totalMinutes = time.hour * 60 + time.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    
    return totalMinutes >= startMinutes && totalMinutes < endMinutes;
  }

  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    final minutes1 = time1.hour * 60 + time1.minute;
    final minutes2 = time2.hour * 60 + time2.minute;
    return minutes1 < minutes2;
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }
}

class WorkSchedule {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isAvailable;

  WorkSchedule({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  bool get isCurrent => date.isAtSameMomentAs(DateTime.now());
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String trainerId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.trainerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

class GroupClass {
  final String id;
  final String name;
  final String description;
  final String type;
  final String level;
  final String trainerId;
  final String trainerName;
  final int maxParticipants;
  final int currentParticipants;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final double price;
  final bool requiresMembership;

  GroupClass({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.level,
    required this.trainerId,
    required this.trainerName,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.price = 0,
    this.requiresMembership = false,
  });

  bool get isFull => currentParticipants >= maxParticipants;
  bool get isAvailable => !isFull && startTime.isAfter(DateTime.now());
  int get spotsLeft => maxParticipants - currentParticipants;
}