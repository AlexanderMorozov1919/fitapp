import './booking_model.dart';
import './payment_model.dart';

enum UserType {
  client,
  employee,
}

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
  final List<BankCard> bankCards;
  final UserType userType;
  final EmployeeInfo? employeeInfo;

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
    this.bankCards = const [],
    this.userType = UserType.client,
    this.employeeInfo,
  });

  String get fullName => '$firstName $lastName';
  
  bool get isEmployee => userType == UserType.employee;
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

class EmployeeInfo {
  final String employeeId;
  final String position;
  final String specialization;
  final DateTime hireDate;
  final double salary;
  final Map<String, dynamic> kpiMetrics;

  EmployeeInfo({
    required this.employeeId,
    required this.position,
    required this.specialization,
    required this.hireDate,
    required this.salary,
    this.kpiMetrics = const {},
  });

  int get experienceInMonths {
    final now = DateTime.now();
    return (now.year - hireDate.year) * 12 + now.month - hireDate.month;
  }

  String get experienceFormatted {
    final months = experienceInMonths;
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    
    if (years == 0) {
      return '$remainingMonths месяцев';
    } else if (remainingMonths == 0) {
      return '$years ${_getYearWord(years)}';
    } else {
      return '$years ${_getYearWord(years)} $remainingMonths месяцев';
    }
  }

  String _getYearWord(int years) {
    if (years % 10 == 1 && years % 100 != 11) {
      return 'год';
    } else if (years % 10 >= 2 && years % 10 <= 4 && (years % 100 < 10 || years % 100 >= 20)) {
      return 'года';
    } else {
      return 'лет';
    }
  }
}