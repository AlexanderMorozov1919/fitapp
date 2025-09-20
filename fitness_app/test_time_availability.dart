import 'package:flutter/material.dart';
import './lib/services/mock_data/tennis_court_data.dart';

void main() {
  // Тестируем логику проверки доступности времени
  final court = tennisCourts[1]; // Корт 2 (Грунт)
  
  print('Тестирование корта: ${court.number}');
  print('Занятые слоты на 22 сентября:');
  
  // Фильтруем занятые слоты для 22 сентября
  final bookedSlots22 = court.bookedSlots.where((slot) => 
      slot.year == 2025 && slot.month == 9 && slot.day == 22).toList();
  
  for (final slot in bookedSlots22) {
    print('  ${slot.hour}:00');
  }
  
  print('\nПроверка доступности времени:');
  
  // Проверяем доступность разных времен
  final testTimes = [7, 8, 9, 10, 16, 17, 18, 19];
  
  for (final hour in testTimes) {
    final testTime = DateTime(2025, 9, 22, hour, 0);
    final isAvailable = court.isTimeSlotAvailable(testTime, 1);
    print('  ${hour}:00 - ${isAvailable ? 'Свободно' : 'Занято'}');
  }
  
  print('\nПроверка доступности интервалов:');
  
  // Проверяем доступность интервалов
  final testIntervals = [
    {'start': 7, 'duration': 1, 'expected': true},   // 7:00-8:00 - свободно
    {'start': 8, 'duration': 1, 'expected': false},  // 8:00-9:00 - занято (8:00 занято)
    {'start': 9, 'duration': 1, 'expected': false},  // 9:00-10:00 - занято (9:00 занято)
    {'start': 10, 'duration': 1, 'expected': true},  // 10:00-11:00 - свободно
    {'start': 16, 'duration': 1, 'expected': true},  // 16:00-17:00 - свободно
    {'start': 17, 'duration': 1, 'expected': false}, // 17:00-18:00 - занято (17:00 занято)
    {'start': 18, 'duration': 1, 'expected': false}, // 18:00-19:00 - занято (18:00 занято)
    {'start': 19, 'duration': 1, 'expected': true},  // 19:00-20:00 - свободно
  ];
  
  for (final interval in testIntervals) {
    final start = interval['start'] as int;
    final duration = interval['duration'] as int;
    final startTime = DateTime(2025, 9, 22, start, 0);
    final isAvailable = court.isTimeSlotAvailable(startTime, duration);
    final status = isAvailable ? 'Свободно' : 'Занято';
    final expected = interval['expected'] as bool ? '✓' : '✗';
    
    print('  $start:00-${start + duration}:00: $status $expected');
  }
}