import '../../models/user_model.dart';
import './locker_data.dart';

final User currentUser = User(
  id: 'user_001',
  firstName: 'Александр',
  lastName: 'Морозов',
  email: 'alex.morozov@email.com',
  phone: '+7 (999) 123-45-67',
  birthDate: DateTime(1990, 5, 15),
  photoUrl: null,
  preferences: ['теннис', 'силовые тренировки', 'йога'],
  membership: Membership(
    id: 'mem_001',
    type: 'All-inclusive',
    startDate: DateTime(2025, 9, 1),
    endDate: DateTime(2025, 9, 30),
    remainingVisits: 0, // unlimited
    price: 25000,
    includedServices: ['тренажерный зал', 'групповые занятия', 'теннис'],
    autoRenew: true,
  ),
  balance: 1500,
  lockers: [
    lockers[3], // Добавляем арендованный шкафчик для тестирования
  ],
);