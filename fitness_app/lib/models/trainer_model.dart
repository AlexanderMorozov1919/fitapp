import 'package:flutter/material.dart';

class Trainer {
  final String id;
  final String firstName;
  final String lastName;
  final String specialty;
  final String bio;
  final double rating;
  final int totalReviews;
  final List<String> certifications;
  final String? photoUrl;
  final List<String> availableSports;
  final Map<String, double> hourlyRates;
  final List<WorkSchedule> schedule;
  final List<Review> reviews;

  Trainer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialty,
    required this.bio,
    this.rating = 0,
    this.totalReviews = 0,
    this.certifications = const [],
    this.photoUrl,
    this.availableSports = const [],
    this.hourlyRates = const {},
    this.schedule = const [],
    this.reviews = const [],
  });

  String get fullName => '$firstName $lastName';
  String get displayRating => rating.toStringAsFixed(1);
  bool get isAvailable => schedule.any((slot) => slot.isAvailable);
}

class WorkSchedule {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isAvailable;

  WorkSchedule({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  bool get isCurrent => date.isAtSameMomentAs(DateTime.now());
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String trainerId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.trainerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

class GroupClass {
  final String id;
  final String name;
  final String description;
  final String type;
  final String level;
  final String trainerId;
  final String trainerName;
  final int maxParticipants;
  final int currentParticipants;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final double price;
  final bool requiresMembership;

  GroupClass({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.level,
    required this.trainerId,
    required this.trainerName,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.price = 0,
    this.requiresMembership = false,
  });

  bool get isFull => currentParticipants >= maxParticipants;
  bool get isAvailable => !isFull && startTime.isAfter(DateTime.now());
  int get spotsLeft => maxParticipants - currentParticipants;
}