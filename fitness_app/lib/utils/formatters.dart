import 'package:intl/intl.dart';

/// Утилиты для форматирования дат и времени

class DateFormatters {
  /// Форматирование даты в формате "день.месяц.год"
  static String formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  /// Форматирование времени в формате "часы:минуты" (24-часовой формат)
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Форматирование времени в 24-часовом формате (российский стандарт)
  static String formatTimeRussian(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Форматирование времени с текстовым описанием (24-часовой формат)
  static String formatTimeWithWords(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    
    if (minute == 0) {
      return '$hour:00';
    } else {
      return '$hour:${minute.toString().padLeft(2, '0')}';
    }
  }

  /// Форматирование временного интервала в 24-часовом формате
  static String formatTimeRangeRussian(DateTime start, DateTime end) {
    return '${formatTimeRussian(start)} - ${formatTimeRussian(end)}';
  }

  /// Форматирование времени для человека (утро/день/вечер) в 24-часовом формате
  static String formatTimeForHuman(DateTime time) {
    final hour = time.hour;
    final displayTime = formatTimeRussian(time);
    
    if (hour >= 5 && hour < 12) {
      return '$displayTime (утро)';
    } else if (hour >= 12 && hour < 18) {
      return '$displayTime (день)';
    } else if (hour >= 18 && hour < 23) {
      return '$displayTime (вечер)';
    } else {
      return '$displayTime (ночь)';
    }
  }

  /// Форматирование даты и времени
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  /// Форматирование даты для отображения (сегодня/завтра/дата)
  static String formatDateDisplay(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Сегодня';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Завтра';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Вчера';
    } else {
      return formatDate(date);
    }
  }

  /// Форматирование даты с названием месяца
  static String formatDateWithMonth(DateTime date) {
    final monthNames = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  /// Форматирование времени для длительности
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes мин';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours ч';
      } else {
        return '$hours ч $remainingMinutes мин';
      }
    }
  }

  /// Форматирование цены с валютой
  static String formatPrice(double price) {
    return '${price.toStringAsFixed(0)} ₽';
  }

  /// Форматирование цены с десятичными знаками
  static String formatPriceWithDecimals(double price) {
    return '${price.toStringAsFixed(2)} ₽';
  }

  /// Форматирование номера телефона
  static String formatPhoneNumber(String phone) {
    if (phone.length == 11 && phone.startsWith('7')) {
      return '+7 (${phone.substring(1, 4)}) ${phone.substring(4, 7)}-${phone.substring(7, 9)}-${phone.substring(9)}';
    }
    return phone;
  }

  /// Форматирование имени пользователя
  static String formatUserName(String firstName, String lastName) {
    return '$firstName $lastName';
  }

  /// Форматирование короткого имени
  static String formatShortName(String firstName, String lastName) {
    return '$firstName ${lastName[0]}.';
  }

  /// Форматирование количества (1 посещение, 2 посещения, 5 посещений)
  static String formatCount(int count, String singular, String plural, String genitivePlural) {
    if (count % 10 == 1 && count % 100 != 11) {
      return '$count $singular';
    } else if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return '$count $plural';
    } else {
      return '$count $genitivePlural';
    }
  }

  /// Форматирование дней (1 день, 2 дня, 5 дней)
  static String formatDays(int days) {
    return formatCount(days, 'день', 'дня', 'дней');
  }

  /// Форматирование посещений (1 посещение, 2 посещения, 5 посещений)
  static String formatVisits(int visits) {
    return formatCount(visits, 'посещение', 'посещения', 'посещений');
  }

  /// Форматирование отзывов (1 отзыв, 2 отзыва, 5 отзывов)
  static String formatReviews(int reviews) {
    return formatCount(reviews, 'отзыв', 'отзыва', 'отзывов');
  }

  /// Форматирование рейтинга с одной десятичной цифрой
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Форматирование процентов
  static String formatPercentage(double percentage) {
    return '${(percentage * 100).toStringAsFixed(0)}%';
  }

  /// Форматирование размера файла
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Форматирование даты для API (ISO 8601)
  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Форматирование времени для API
  static String formatTimeForApi(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }

  /// Форматирование даты и времени для API
  static String formatDateTimeForApi(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
  }

  /// Парсинг даты из API
  static DateTime? parseDateFromApi(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Получение дня недели на русском
  static String getWeekdayName(DateTime date) {
    final weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return weekdays[date.weekday - 1];
  }

  /// Получение названия месяца на русском
  static String getMonthName(DateTime date) {
    final months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[date.month - 1];
  }
}