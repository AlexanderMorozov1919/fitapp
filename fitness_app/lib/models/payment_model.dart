import 'package:flutter/material.dart';

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

enum PaymentMethod {
  creditCard,
  debitCard,
  applePay,
  googlePay,
  balance,
}

class Payment {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final PaymentStatus status;
  final PaymentMethod method;
  final DateTime createdAt;
  final String? bookingId;
  final String? membershipId;
  final String? transactionId;

  Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.status,
    required this.method,
    required this.createdAt,
    this.bookingId,
    this.membershipId,
    this.transactionId,
  });

  String get statusText {
    switch (status) {
      case PaymentStatus.pending:
        return 'Ожидание';
      case PaymentStatus.completed:
        return 'Завершено';
      case PaymentStatus.failed:
        return 'Ошибка';
      case PaymentStatus.refunded:
        return 'Возврат';
    }
  }

  Color get statusColor {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
        return Colors.blue;
    }
  }
}

class MembershipType {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationDays;
  final List<String> includedServices;
  final int maxVisits;
  final bool includesTennis;
  final bool includesGym;
  final bool includesGroupClasses;
  final double tennisCourtDiscount;
  final double personalTrainingDiscount;

  MembershipType({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    this.includedServices = const [],
    this.maxVisits = 0,
    this.includesTennis = false,
    this.includesGym = false,
    this.includesGroupClasses = false,
    this.tennisCourtDiscount = 0,
    this.personalTrainingDiscount = 0,
  });

  bool get isUnlimited => maxVisits == 0;
}

class GiftMembership {
  final String id;
  final String fromUserId;
  final String toUserName;
  final String toUserEmail;
  final String membershipTypeId;
  final String message;
  final DateTime purchaseDate;
  final DateTime activationDate;
  final bool isActivated;

  GiftMembership({
    required this.id,
    required this.fromUserId,
    required this.toUserName,
    required this.toUserEmail,
    required this.membershipTypeId,
    required this.message,
    required this.purchaseDate,
    required this.activationDate,
    this.isActivated = false,
  });
}

class ReferralProgram {
  final String referrerId;
  final String referredEmail;
  final DateTime referralDate;
  final bool isActivated;
  final DateTime? activationDate;
  final double bonusAmount;

  ReferralProgram({
    required this.referrerId,
    required this.referredEmail,
    required this.referralDate,
    this.isActivated = false,
    this.activationDate,
    this.bonusAmount = 0,
  });
}