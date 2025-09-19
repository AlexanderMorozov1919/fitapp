import '../models/booking_model.dart';
import '../models/trainer_model.dart';
import '../models/user_model.dart';
import '../models/payment_model.dart';
import '../models/chat_model.dart';
import '../models/notification_model.dart';

// Импорт данных из отдельных файлов
import './mock_data/user_data.dart' as user_data;
import './mock_data/trainer_data.dart' as trainer_data;
import './mock_data/tennis_court_data.dart' as court_data;
import './mock_data/group_class_data.dart' as class_data;
import './mock_data/booking_data.dart' as booking_data;
import './mock_data/membership_type_data.dart' as membership_data;
import './mock_data/locker_data.dart' as locker_data;
import './mock_data/chat_data.dart' as chat_data;
import './mock_data/notification_data.dart' as notification_data;
import './mock_data/employee_training_data.dart' as employee_training_data;
import './mock_data/client_data.dart' as client_data;

class MockDataService {
  static User currentUser = user_data.currentUser;
  static final List<Trainer> trainers = trainer_data.trainers;
  static final List<TennisCourt> tennisCourts = court_data.tennisCourts;
  static final List<GroupClass> groupClasses = class_data.groupClasses;
  static final List<Booking> userBookings = booking_data.userBookings;
  static final List<Booking> employeeTrainings = employee_training_data.employeeTrainings;
  static final List<MembershipType> membershipTypes = membership_data.membershipTypes;
  static final List<Locker> lockers = locker_data.lockers;
  static Chat userChat = chat_data.mockChat;
  static List<AppNotification> notifications = notification_data.mockNotifications;
  static final List<User> clients = client_data.clients;
  
  // Чаты сотрудника с разными контактами
  static final Map<String, Chat> _employeeChats = {};

  // Метод для обновления данных пользователя
  static void updateUserMembership(Membership newMembership) {
    currentUser = User(
      id: currentUser.id,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      email: currentUser.email,
      phone: currentUser.phone,
      photoUrl: currentUser.photoUrl,
      birthDate: currentUser.birthDate,
      preferences: currentUser.preferences,
      membership: newMembership,
      bookings: currentUser.bookings,
      lockers: currentUser.lockers,
      balance: currentUser.balance,
    );
  }

  // Метод для обновления количества участников в групповом занятии
  static void updateGroupClassParticipants(String classId, int newParticipantsCount) {
    final classIndex = groupClasses.indexWhere((c) => c.id == classId);
    if (classIndex != -1) {
      final groupClass = groupClasses[classIndex];
      // Создаем новый объект с обновленным количеством участников
      final updatedClass = GroupClass(
        id: groupClass.id,
        name: groupClass.name,
        description: groupClass.description,
        type: groupClass.type,
        level: groupClass.level,
        trainerId: groupClass.trainerId,
        trainerName: groupClass.trainerName,
        maxParticipants: groupClass.maxParticipants,
        currentParticipants: newParticipantsCount,
        startTime: groupClass.startTime,
        endTime: groupClass.endTime,
        location: groupClass.location,
        price: groupClass.price,
        requiresMembership: groupClass.requiresMembership,
      );
      groupClasses[classIndex] = updatedClass;
    }
  
  }

  // Метод для добавления сообщения в чат
  static void addMessageToChat(ChatMessage message) {
    final currentMessages = userChat.messages;
    userChat = Chat(
      id: userChat.id,
      userId: userChat.userId,
      adminId: userChat.adminId,
      adminName: userChat.adminName,
      adminAvatar: userChat.adminAvatar,
      createdAt: userChat.createdAt,
      updatedAt: DateTime.now(),
      messages: [...currentMessages, message],
      isActive: userChat.isActive,
      unreadCount: message.isAdminMessage ? userChat.unreadCount + 1 : userChat.unreadCount,
    );
  }

  // Метод для обновления состояния прочтения сообщений
  static void markMessagesAsRead() {
    userChat = Chat(
      id: userChat.id,
      userId: userChat.userId,
      adminId: userChat.adminId,
      adminName: userChat.adminName,
      adminAvatar: userChat.adminAvatar,
      createdAt: userChat.createdAt,
      updatedAt: DateTime.now(),
      messages: userChat.messages,
      isActive: userChat.isActive,
      unreadCount: 0,
    );
  }

  // Метод для получения доступных теннисных кортов
  static List<TennisCourt> getAvailableTennisCourts(DateTime date) {
    return tennisCourts.where((court) => court.isAvailable).toList();
  }

  // Метод для получения групповых занятий на определенную дату
  static List<GroupClass> getGroupClassesByDate(DateTime date) {
    return groupClasses.where((classItem) =>
      classItem.startTime.year == date.year &&
      classItem.startTime.month == date.month &&
      classItem.startTime.day == date.day
    ).toList();
  }

  // Метод для получения бронирований пользователя на определенную дату
  static List<Booking> getUserBookingsByDate(DateTime date) {
    return userBookings.where((booking) =>
      booking.startTime.year == date.year &&
      booking.startTime.month == date.month &&
      booking.startTime.day == date.day &&
      booking.status != BookingStatus.cancelled
    ).toList();
  }

  // Метод для получения доступных шкафчиков
  static List<Locker> getAvailableLockers() {
    return lockers.where((locker) => locker.isAvailable).toList();
  }

  // Метод для обновления баланса пользователя
  static void updateUserBalance(double amount) {
    currentUser = User(
      id: currentUser.id,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      email: currentUser.email,
      phone: currentUser.phone,
      photoUrl: currentUser.photoUrl,
      birthDate: currentUser.birthDate,
      preferences: currentUser.preferences,
      membership: currentUser.membership,
      bookings: currentUser.bookings,
      lockers: currentUser.lockers,
      balance: currentUser.balance + amount,
      bankCards: currentUser.bankCards,
    );
  }

  // Метод для добавления новой банковской карты
  static void addBankCard(BankCard card) {
    final updatedCards = [...currentUser.bankCards, card];
    currentUser = User(
      id: currentUser.id,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      email: currentUser.email,
      phone: currentUser.phone,
      photoUrl: currentUser.photoUrl,
      birthDate: currentUser.birthDate,
      preferences: currentUser.preferences,
      membership: currentUser.membership,
      bookings: currentUser.bookings,
      lockers: currentUser.lockers,
      balance: currentUser.balance,
      bankCards: updatedCards,
    );
  }

  // Метод для получения предстоящих бронирований
  static List<Booking> getUpcomingBookings() {
    return userBookings.where((booking) =>
      booking.status == BookingStatus.confirmed &&
      booking.startTime.isAfter(DateTime.now())
    ).toList();
  }

  // Метод для получения истории бронирований
  static List<Booking> getBookingHistory() {
    return userBookings.where((booking) =>
      booking.status == BookingStatus.completed ||
      booking.status == BookingStatus.cancelled
    ).toList();
  }

  // Метод для получения непрочитанных уведомлений
  static List<AppNotification> getUnreadNotifications() {
    return notifications.where((notification) => !notification.isRead).toList();
  }

  // Метод для получения уведомлений по типу
  static List<AppNotification> getNotificationsByType(NotificationType type) {
    return notifications.where((notification) => notification.type == type).toList();
  }

  // Метод для пометки уведомления как прочитанного
  static void markNotificationAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final notification = notifications[index];
      notifications[index] = notification.copyWith(isRead: true);
    }
  }

  // Метод для пометки всех уведомлений как прочитанных
  static void markAllNotificationsAsRead() {
    notifications = notifications.map((notification) =>
      notification.copyWith(isRead: true)
    ).toList();
  }

  // Метод для добавления нового уведомления
  static void addNotification(AppNotification notification) {
    notifications = [notification, ...notifications];
  }

  // Метод для получения уведомлений на определенную дату
  static List<AppNotification> getNotificationsByDate(DateTime date) {
    return notifications.where((notification) =>
      notification.timestamp.year == date.year &&
      notification.timestamp.month == date.month &&
      notification.timestamp.day == date.day
    ).toList();
  }

  // Метод для получения предстоящих уведомлений (на 7 дней вперед)
  static List<AppNotification> getUpcomingNotifications() {
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    return notifications.where((notification) =>
      notification.timestamp.isAfter(now) &&
      notification.timestamp.isBefore(weekFromNow)
    ).toList();
  }

  // Метод для удаления уведомления
  static void removeNotification(String notificationId) {
    notifications = notifications.where((n) => n.id != notificationId).toList();
  }

  // Метод для получения свободного времени сотрудника на определенную дату
  static List<FreeTimeSlot> getEmployeeFreeTimeSlots(DateTime date) {
    final trainings = employeeTrainings.where((training) =>
      training.startTime.year == date.year &&
      training.startTime.month == date.month &&
      training.startTime.day == date.day &&
      training.status != BookingStatus.cancelled
    ).toList();

    // Сортируем тренировки по времени начала
    trainings.sort((a, b) => a.startTime.compareTo(b.startTime));

    final freeSlots = <FreeTimeSlot>[];
    final workStart = DateTime(date.year, date.month, date.day, 8, 0); // 8:00
    final workEnd = DateTime(date.year, date.month, date.day, 22, 0); // 22:00

    // Проверяем время до первой тренировки
    if (trainings.isNotEmpty) {
      final firstTraining = trainings.first;
      if (firstTraining.startTime.difference(workStart).inMinutes >= 30) {
        freeSlots.add(FreeTimeSlot(
          startTime: workStart,
          endTime: firstTraining.startTime,
        ));
      }
    } else {
      // Если нет тренировок, весь день свободен
      freeSlots.add(FreeTimeSlot(
        startTime: workStart,
        endTime: workEnd,
      ));
      return freeSlots;
    }

    // Проверяем время между тренировками
    for (int i = 0; i < trainings.length - 1; i++) {
      final currentTraining = trainings[i];
      final nextTraining = trainings[i + 1];
      
      final gap = nextTraining.startTime.difference(currentTraining.endTime);
      if (gap.inMinutes >= 30) {
        freeSlots.add(FreeTimeSlot(
          startTime: currentTraining.endTime,
          endTime: nextTraining.startTime,
        ));
      }
    }

    // Проверяем время после последней тренировки
    final lastTraining = trainings.last;
    if (workEnd.difference(lastTraining.endTime).inMinutes >= 30) {
      freeSlots.add(FreeTimeSlot(
        startTime: lastTraining.endTime,
        endTime: workEnd,
      ));
    }

    return freeSlots.where((slot) => slot.isLongEnoughForTraining).toList();
  }

  // Метод для добавления новой тренировки сотрудника
  static void addEmployeeTraining(Booking training) {
    employeeTrainings.add(training);
    // Обновляем список, чтобы триггерить перерисовку
    employeeTrainings.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  // Метод для получения или создания чата сотрудника
  static Chat getOrCreateEmployeeChat(String contactId, String contactName, String? contactAvatar) {
    if (_employeeChats.containsKey(contactId)) {
      return _employeeChats[contactId]!;
    }
    
    // Создаем новый чат
    final newChat = Chat(
      id: 'employee_chat_$contactId',
      userId: contactId,
      adminId: 'employee_igor',
      adminName: 'Игорь Виноградов',
      adminAvatar: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: _getInitialEmployeeChatMessages(contactName),
      isActive: true,
      unreadCount: 0,
    );
    
    _employeeChats[contactId] = newChat;
    return newChat;
  }

  // Метод для получения чата сотрудника
  static Chat getEmployeeChat(String contactId) {
    return _employeeChats[contactId] ?? getOrCreateEmployeeChat(contactId, 'Контакт', null);
  }

  // Метод для добавления сообщения в чат сотрудника
  static void addMessageToEmployeeChat(String contactId, ChatMessage message) {
    final chat = getEmployeeChat(contactId);
    final currentMessages = chat.messages;
    
    _employeeChats[contactId] = Chat(
      id: chat.id,
      userId: chat.userId,
      adminId: chat.adminId,
      adminName: chat.adminName,
      adminAvatar: chat.adminAvatar,
      createdAt: chat.createdAt,
      updatedAt: DateTime.now(),
      messages: [...currentMessages, message],
      isActive: chat.isActive,
      unreadCount: message.isUserMessage ? chat.unreadCount + 1 : chat.unreadCount,
    );
  }

  // Начальные сообщения для чата сотрудника
  static List<ChatMessage> _getInitialEmployeeChatMessages(String contactName) {
    return [
      ChatMessage(
        id: 'msg_initial_1',
        chatId: 'employee_chat',
        type: MessageType.system,
        sender: MessageSender.system,
        content: 'Чат с $contactName начат',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: 'msg_initial_2',
        chatId: 'employee_chat',
        type: MessageType.text,
        sender: MessageSender.admin,
        content: 'Здравствуйте! Чем могу помочь?',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        isRead: true,
        senderName: 'Игорь Виноградов',
      ),
    ];
  }

  // Метод для получения всех чатов сотрудника
  static List<Chat> getEmployeeChats() {
    return _employeeChats.values.toList();
  }

  // Метод для получения непрочитанных сообщений в чатах сотрудника
  static int getEmployeeUnreadMessagesCount() {
    return _employeeChats.values.fold(0, (sum, chat) => sum + chat.unreadCount);
  }
}