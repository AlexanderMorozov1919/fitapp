// Простой тест без зависимостей Flutter
void main() {
  // Создаем тестовый корт с занятыми слотами
  final testCourt = _TestTennisCourt(
    bookedSlots: [
      DateTime(2025, 9, 22, 9, 0),  // 9:00 занято
      DateTime(2025, 9, 22, 10, 0), // 10:00 занято
      DateTime(2025, 9, 22, 11, 0), // 11:00 занято
    ],
  );

  print('Тестирование доступности времени для бронирования 8:00-9:00');
  
  final startTime = DateTime(2025, 9, 22, 8, 0);
  final isAvailable = testCourt.isTimeSlotAvailable(startTime, 1);
  
  print('Время 8:00-9:00: ${isAvailable ? "Свободно" : "Занято"}');
  print('Ожидалось: Свободно (бронирование заканчивается в начале занятого времени)');
  
  if (isAvailable) {
    print('✓ Тест пройден успешно!');
  } else {
    print('✗ Тест не пройден! Нужно исправить логику проверки');
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