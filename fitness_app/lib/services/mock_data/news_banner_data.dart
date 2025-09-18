import 'package:flutter/material.dart';
import '../../models/news_banner_model.dart';

class NewsBannerData {
  static final List<NewsBanner> banners = [
    NewsBanner(
      id: '1',
      title: 'ТЕННИСНЫЕ КОРТЫ СО СКИДКОЙ!',
      description: 'Бронируйте корты в утренние часы со скидкой 30%. Идеальное время для тренировок!',
      backgroundColor: const Color(0xFF0066CC),
      textColor: Colors.white,
      actionText: 'Забронировать',
      actionRoute: 'tennis',
    ),
    NewsBanner(
      id: '2',
      title: 'ПЕРСОНАЛЬНЫЕ ТРЕНИРОВКИ',
      description: 'Новые топ-тренеры в команде! Запишитесь на пробную тренировку бесплатно.',
      backgroundColor: const Color(0xFFFF6B35),
      textColor: Colors.white,
      actionText: 'Выбрать тренера',
      actionRoute: 'trainers',
    ),
    NewsBanner(
      id: '3',
      title: 'АКЦИЯ: ТЕННИС + ТРЕНЕР',
      description: 'При бронировании корта на 2 часа - персональная тренировка со скидкой 50%!',
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      actionText: 'Узнать подробности',
      actionRoute: 'tennis',
    ),
    NewsBanner(
      id: '4',
      title: 'МАСТЕР-КЛАСС ПО ТЕННИСУ',
      description: 'Приглашенный профессионал проведет мастер-класс в эту субботу. Регистрируйтесь!',
      backgroundColor: const Color(0xFF9C27B0),
      textColor: Colors.white,
      actionText: 'Записаться',
      actionRoute: 'class_selection',
    ),
    NewsBanner(
      id: '5',
      title: 'СКИДКА 25% НА АБОНЕМЕНТ ТЕННИС',
      description: 'Только для новых клиентов! Месячный абонемент на теннис со скидкой 25%.',
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      actionText: 'Приобрести',
      actionRoute: 'membership',
    ),
  ];
}