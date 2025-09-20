// Комплексный тест различных сценариев бронирования
void main() {
  // Создаем тестовый корт с занятыми слотами (Корт 1, 22 сентября)
  final testCourt = _TestTennisCourt(
    bookedSlots: [
      DateTime(2025, 9, 22, 9, 0),  // 9:00-10:00 занято
      DateTime(2025, 9, 22, 10, 0), // 10:00-11:00 занято
      DateTime(2025, 9, 22, 11, 0), // 11:00-12:00 занято
      DateTime(2025, 9, 22, 18, 0), // 18:00-19:00 занято
      DateTime(2025, 9, 22, 19, 0), // 19:00-20:00 занято
      DateTime(2025, 9, 22, 20, 0), // 20:00-21:00 занято
    ],
  );

  print('=== Комплексное тестирование доступности времени ===\n');

  // Тест 1: Бронирование перед занятым временем
  _testScenario(
    testCourt,
    '8:00-9:00 (перед занятым 9:00-10:00)',
    DateTime(2025, 9, 22, 8, 0),
    1,
    true,
    'Должно быть доступно - заканчивается в начале занятого времени'
  );

  // Тест 2: Бронирование сразу после занятого времени
  _testScenario(
    testCourt,
    '12:00-13:00 (после занятого 11:00-12:00)',
    DateTime(2025, 9, 22, 12, 0),
    1,
    true,
    'Должно быть доступно - начинается после окончания занятого времени'
  );

  // Тест 3: Бронирование, пересекающее занятое время
  _testScenario(
    testCourt,
    '8:30-9:30 (пересекает занятое 9:00-10:00)',
    DateTime(2025, 9, 22, 8, 30),
    1,
    false,
    'Должно быть занято - пересекается с занятым временем'
  );

  // Тест 4: Бронирование внутри занятого времени
  _testScenario(
    testCourt,
    '9:30-10:30 (внутри занятого 9:00-11:00)',
    DateTime(2025, 9, 22, 9, 30),
    1,
    false,
    'Должно быть занято - полностью внутри занятого времени'
  );

  // Тест 5: Бронирование между занятыми временами
  _testScenario(
    testCourt,
    '17:00-18:00 (между свободным временем)',
    DateTime(2025, 9, 22, 17, 0),
    1,
    true,
    'Должно быть доступно - между занятыми временами'
  );

  // Тест 6: Длительное бронирование, заканчивающееся в начале занятого
  _testScenario(
    testCourt,
    '7:00-9:00 (2 часа, заканчивается в начале занятого)',
    DateTime(2025, 9, 22, 7, 0),
    2,
    true,
    'Должно быть доступно - заканчивается в начале занятого времени'
  );

  print('\n=== Тестирование завершено ===');
}

void _testScenario(_TestTennisCourt court, String description, 
                  DateTime startTime, int duration, bool expected, String reason) {
  final isAvailable = court.isTimeSlotAvailable(startTime, duration);
  final status = isAvailable ? 'Свободно' : 'Занято';
  final expectedStatus = expected ? 'Свободно' : 'Занято';
  final result = isAvailable == expected ? '✓' : '✗';
  
  print('$result $description: $status (Ожидалось: $expectedStatus)');
  if (isAvailable != expected) {
    print('   Причина: $reason');
  }
}

// Упрощенная версия TennisCourt для тестирования
class _TestTennisCourt {
  final List<DateTime> bookedSlots;

  _TestTennisCourt({required this.bookedSlots});

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
}