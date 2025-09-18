class HomeUtils {
  static String formatDate(DateTime date) {
    return '${date.day}.${date.month}';
  }

  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateFull(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static String formatDateShort(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (isSameDay(date, today)) return 'Сегодня';
    if (isSameDay(date, tomorrow)) return 'Завтра';
    
    return '${date.day}.${date.month}';
  }
}