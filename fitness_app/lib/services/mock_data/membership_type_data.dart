import '../../models/payment_model.dart';

final List<MembershipType> membershipTypes = [
  MembershipType(
    id: 'type_001',
    name: 'Тренажерный зал',
    description: 'Доступ только в тренажерный зал',
    price: 8000,
    durationDays: 30,
    maxVisits: 12,
    includesGym: true,
  ),
  MembershipType(
    id: 'type_002',
    name: 'Групповые занятия',
    description: 'Неограниченный доступ к групповым занятиям',
    price: 12000,
    durationDays: 30,
    includesGroupClasses: true,
  ),
  MembershipType(
    id: 'type_003',
    name: 'All-inclusive',
    description: 'Полный доступ ко всем услугам клуба',
    price: 25000,
    durationDays: 30,
    includesTennis: true,
    includesGym: true,
    includesGroupClasses: true,
    tennisCourtDiscount: 0.2,
    personalTrainingDiscount: 0.15,
  ),
  MembershipType(
    id: 'type_004',
    name: 'Теннис',
    description: 'Доступ к теннисным кортам + 4 часа в месяц',
    price: 15000,
    durationDays: 30,
    includesTennis: true,
    maxVisits: 4,
  ),
];