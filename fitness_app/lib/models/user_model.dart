import './booking_model.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? photoUrl;
  final DateTime birthDate;
  final List<String> preferences;
  final Membership? membership;
  final List<Booking> bookings;
  final List<Locker> lockers;
  final double balance;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.birthDate,
    this.preferences = const [],
    this.membership,
    this.bookings = const [],
    this.lockers = const [],
    this.balance = 0,
  });

  String get fullName => '$firstName $lastName';
}

class Membership {
  final String id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final int remainingVisits;
  final double price;
  final List<String> includedServices;
  final bool autoRenew;

  Membership({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.remainingVisits,
    required this.price,
    this.includedServices = const [],
    this.autoRenew = false,
  });

  bool get isActive => DateTime.now().isBefore(endDate);
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
}