import '../../models/booking_model.dart';

final List<Locker> lockers = [
  Locker(
    id: 'locker_001',
    number: 'A-101',
    size: 'Стандартный',
    isAvailable: true,
    pricePerDay: 100,
  ),
  Locker(
    id: 'locker_002',
    number: 'A-102',
    size: 'Стандартный',
    isAvailable: true,
    pricePerDay: 100,
  ),
  Locker(
    id: 'locker_003',
    number: 'A-103',
    size: 'Большой',
    isAvailable: true,
    pricePerDay: 150,
  ),
  Locker(
    id: 'locker_004',
    number: 'A-104',
    size: 'Стандартный',
    isAvailable: false,
    pricePerDay: 100,
    rentalEndDate: DateTime(2025, 9, 20),
  ),
  Locker(
    id: 'locker_005',
    number: 'B-201',
    size: 'Большой',
    isAvailable: true,
    pricePerDay: 150,
  ),
];