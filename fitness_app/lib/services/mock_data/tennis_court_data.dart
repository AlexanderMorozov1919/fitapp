import '../../models/booking_model.dart';

final List<TennisCourt> tennisCourts = [
  TennisCourt(
    id: 'court_001',
    number: 'Корт 1',
    surfaceType: 'Хард',
    isIndoor: true,
    isAvailable: true,
    pricePerHour: 1500,
  ),
  TennisCourt(
    id: 'court_002',
    number: 'Корт 2',
    surfaceType: 'Грунт',
    isIndoor: false,
    isAvailable: true,
    pricePerHour: 1200,
  ),
  TennisCourt(
    id: 'court_003',
    number: 'Корт 3',
    surfaceType: 'Хард',
    isIndoor: true,
    isAvailable: false,
    pricePerHour: 1500,
  ),
];