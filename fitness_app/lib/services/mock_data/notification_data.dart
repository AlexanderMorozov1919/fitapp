import '../../models/notification_model.dart';

final List<AppNotification> mockNotifications = [
  // Уведомления на сегодня (22 сентября)
  AppNotification(
    id: 'notif_001',
    title: 'Напоминание о тренировке',
    message: 'Завтра в 9:00 у вас тренировка по теннису на корте 2',
    type: NotificationType.reminder,
    timestamp: DateTime(2025, 9, 22, 20, 0),
    isRead: true,
    relatedId: 'booking_003',
  ),
  AppNotification(
    id: 'notif_002',
    title: 'Новое групповое занятие',
    message: 'Добавлено новое занятие: Утренняя йога в 8:00',
    type: NotificationType.info,
    timestamp: DateTime(2025, 9, 22, 9, 15),
    isRead: false,
    relatedId: 'class_001',
  ),

  // Уведомления на 23 сентября
  AppNotification(
    id: 'notif_003',
    title: 'Тренер подтвердил занятие',
    message: 'Мария Иванова подтвердила ваше занятие по теннису на 16:00',
    type: NotificationType.booking,
    timestamp: DateTime(2025, 9, 23, 10, 30),
    isRead: false,
    relatedId: 'booking_003',
  ),
  AppNotification(
    id: 'notif_004',
    title: 'Скидка на массаж',
    message: 'Специальное предложение: скидка 15% на все массажные услуги до конца недели',
    type: NotificationType.promo,
    timestamp: DateTime(2025, 9, 23, 12, 0),
    isRead: false,
  ),

  // Уведомления на 24 сентября
  AppNotification(
    id: 'notif_005',
    title: 'Напоминание о стретчинге',
    message: 'Через 2 часа начинается занятие по стретчингу в зале 2',
    type: NotificationType.reminder,
    timestamp: DateTime(2025, 9, 24, 7, 0),
    isRead: false,
    relatedId: 'class_009',
  ),
  AppNotification(
    id: 'notif_006',
    title: 'Баланс пополнен',
    message: 'На ваш счет зачислено 5000 руб. Текущий баланс: 8250 руб.',
    type: NotificationType.payment,
    timestamp: DateTime(2025, 9, 24, 14, 30),
    isRead: false,
  ),

  // Уведомления на 25 сентября
  AppNotification(
    id: 'notif_007',
    title: 'Изменение расписания',
    message: 'Занятие по йоге для продвинутых перенесено на 11:00',
    type: NotificationType.info,
    timestamp: DateTime(2025, 9, 25, 8, 45),
    isRead: false,
    relatedId: 'class_011',
  ),
  AppNotification(
    id: 'notif_008',
    title: 'Напоминание о аренде шкафчика',
    message: 'Аренда шкафчика A-104 заканчивается завтра',
    type: NotificationType.reminder,
    timestamp: DateTime(2025, 9, 25, 18, 0),
    isRead: false,
    relatedId: 'locker_004',
  ),

  // Уведомления на 26 сентября
  AppNotification(
    id: 'notif_009',
    title: 'Новый тренер',
    message: 'В нашем клубе начал работать новый тренер по боксу - Алексей Смирнов',
    type: NotificationType.info,
    timestamp: DateTime(2025, 9, 26, 10, 0),
    isRead: false,
    relatedId: 'trainer_005',
  ),
  AppNotification(
    id: 'notif_010',
    title: 'Оплата прошла успешно',
    message: 'Оплата занятия "Пилатес реформатор" выполнена успешно',
    type: NotificationType.payment,
    timestamp: DateTime(2025, 9, 26, 16, 20),
    isRead: false,
    relatedId: 'booking_013',
  ),

  // Уведомления на 27 сентября
  AppNotification(
    id: 'notif_011',
    title: 'Отмена занятия',
    message: 'Занятие по тай-чи на 9:30 отменено по техническим причинам',
    type: NotificationType.info,
    timestamp: DateTime(2025, 9, 27, 7, 15),
    isRead: false,
    relatedId: 'class_015',
  ),
  AppNotification(
    id: 'notif_012',
    title: 'Специальное предложение',
    message: 'Только сегодня: скидка 20% на все персональные тренировки',
    type: NotificationType.promo,
    timestamp: DateTime(2025, 9, 27, 9, 0),
    isRead: false,
  ),

  // Уведомления на 28 сентября
  AppNotification(
    id: 'notif_013',
    title: 'Напоминание о массаже',
    message: 'Через 3 часа у вас запланирован спортивный массаж',
    type: NotificationType.reminder,
    timestamp: DateTime(2025, 9, 28, 16, 0),
    isRead: false,
    relatedId: 'booking_014',
  ),
  AppNotification(
    id: 'notif_014',
    title: 'Обновление приложения',
    message: 'Доступно новое обновление приложения с улучшенным интерфейсом',
    type: NotificationType.system,
    timestamp: DateTime(2025, 9, 28, 11, 30),
    isRead: false,
  ),

  // Уведомления на 29 сентября
  AppNotification(
    id: 'notif_015',
    title: 'Теннисный турнир',
    message: 'Напоминаем о турнире по теннису сегодня в 15:00. Не забудьте ракетку!',
    type: NotificationType.reminder,
    timestamp: DateTime(2025, 9, 29, 10, 0),
    isRead: false,
    relatedId: 'class_020',
  ),
  AppNotification(
    id: 'notif_016',
    title: 'Продление абонемента',
    message: 'Ваш абонемент заканчивается через 5 дней. Хотите продлить?',
    type: NotificationType.info,
    timestamp: DateTime(2025, 9, 29, 14, 0),
    isRead: false,
    relatedId: 'mem_001',
  ),
];