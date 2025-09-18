import '../models/booking_model.dart';
import '../models/trainer_model.dart';
import '../models/user_model.dart';
import '../models/payment_model.dart';

// Импорт данных из отдельных файлов
import './mock_data/user_data.dart' as user_data;
import './mock_data/trainer_data.dart' as trainer_data;
import './mock_data/tennis_court_data.dart' as court_data;
import './mock_data/group_class_data.dart' as class_data;
import './mock_data/booking_data.dart' as booking_data;
import './mock_data/membership_type_data.dart' as membership_data;
import './mock_data/locker_data.dart' as locker_data;

class MockDataService {
  static User currentUser = user_data.currentUser;
  static final List<Trainer> trainers = trainer_data.trainers;
  static final List<TennisCourt> tennisCourts = court_data.tennisCourts;
  static final List<GroupClass> groupClasses = class_data.groupClasses;
  static final List<Booking> userBookings = booking_data.userBookings;
  static final List<MembershipType> membershipTypes = membership_data.membershipTypes;
  static final List<Locker> lockers = locker_data.lockers;

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
}