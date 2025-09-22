import '../../models/user_model.dart';
import '../../models/payment_model.dart';
import './locker_data.dart';
import './booking_data.dart';

final User currentUser = User(
  id: 'user_001',
  firstName: 'Александр',
  lastName: 'Морозов',
  email: 'alex.morozov@email.com',
  phone: '+7 (999) 123-45-67',
  birthDate: DateTime(1990, 5, 15),
  photoUrl: null,
  preferences: ['теннис', 'силовые тренировки', 'йога', 'плавание'],
  membership: Membership(
    id: 'mem_001',
    type: 'All-inclusive',
    startDate: DateTime(2025, 9, 22),
    endDate: DateTime(2025, 10, 22),
    remainingVisits: 0, // unlimited
    price: 25000,
    includedServices: ['тренажерный зал', 'групповые занятия', 'теннис', 'бассейн'],
    autoRenew: true,
  ),
  balance: 3250,
  bankCards: [
    BankCard(
      id: 'card_001',
      lastFourDigits: '1234',
      type: CardType.visa,
      holderName: 'ALEXANDER MOROZOV',
      expiryDate: DateTime(2026, 12, 31),
      isDefault: true,
    ),
    BankCard(
      id: 'card_002',
      lastFourDigits: '5678',
      type: CardType.mastercard,
      holderName: 'ALEXANDER MOROZOV',
      expiryDate: DateTime(2025, 6, 30),
      isDefault: false,
    ),
    BankCard(
      id: 'card_003',
      lastFourDigits: '9012',
      type: CardType.mir,
      holderName: 'ALEXANDER MOROZOV',
      expiryDate: DateTime(2024, 9, 30),
      isDefault: false,
    ),
  ],
  lockers: [
    lockers[3], // Арендованный шкафчик A-104
  ],
  bookings: userBookings,
);