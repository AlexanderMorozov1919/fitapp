import 'package:flutter/material.dart';
import 'package:fitness_center_app/screens/book_service_screen.dart';
import 'package:fitness_center_app/screens/booking_detail_screen.dart';
import 'package:fitness_center_app/screens/chat_screen.dart';
import 'package:fitness_center_app/screens/home_screen.dart';
import 'package:fitness_center_app/screens/locker_screen.dart';
import 'package:fitness_center_app/screens/parking_history_screen.dart';
import 'package:fitness_center_app/screens/parking_screen.dart';
import 'package:fitness_center_app/screens/profile_screen.dart';
import 'package:fitness_center_app/screens/renew_subscription_screen.dart';
import 'package:fitness_center_app/screens/settings_screen.dart';
import 'package:fitness_center_app/screens/subscriptions_screen.dart';
import 'package:fitness_center_app/screens/trainer_booking_screen.dart';
import 'package:fitness_center_app/screens/trainer_profile_screen.dart';
import 'package:fitness_center_app/screens/trainers_screen.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get state => navigatorKey.currentState!;

  static Future<T?> push<T>(Widget page) {
    return state.push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static Future<T?> pushReplacement<T>(Widget page) {
    return state.pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  static void pop<T>([T? result]) {
    state.pop(result);
  }

  static void popUntil(String routeName) {
    state.popUntil(ModalRoute.withName(routeName));
  }

  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return state.pushNamed(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return state.pushReplacementNamed(routeName, arguments: arguments);
  }
  // Specific navigation methods
  static void pushHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.home);
  }

  static void pushBookService(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.bookService);
  }

  static void pushBookingDetail(BuildContext context, {required Booking booking}) {
    Navigator.pushNamed(context, AppRoutes.bookingDetail, arguments: booking);
  }

  static void pushParking(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.parking);
  }

  static void pushParkingHistory(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.parkingHistory);
  }

  static void pushProfile(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.profile);
  }

  static void pushRenewSubscription(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.renewSubscription);
  }

  static void pushTrainers(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.trainers);
  }

  static void pushTrainerProfile(BuildContext context, {required Trainer trainer}) {
    Navigator.pushNamed(context, AppRoutes.trainerProfile, arguments: trainer);
  }

  static void pushTrainerBooking(BuildContext context, {required Trainer trainer}) {
    Navigator.pushNamed(context, AppRoutes.trainerBooking, arguments: trainer);
  }

  static void pushSubscriptions(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.subscriptions);
  }

  static void pushLocker(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.locker);
  }

  static void pushSettings(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.settings);
  }

  static void pushChat(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.chat);
  }
}

class AppRoutes {
  static const String home = '/';
  static const String renewSubscription = '/renew-subscription';
  static const String bookService = '/book-service';
  static const String parking = '/parking';
  static const String parkingHistory = '/parking-history';
  static const String profile = '/profile';
  static const String bookingDetail = '/booking-detail';
  static const String trainers = '/trainers';
  static const String trainerProfile = '/trainer-profile';
  static const String trainerBooking = '/trainer-booking';
  static const String subscriptions = '/subscriptions';
  static const String locker = '/locker';
  static const String settings = '/settings';
  static const String chat = '/chat';
}

class Booking {
  final String id;
  final String service;
  final String trainer;
  final String date;
  final String time;
  final String location;
  final String status;
  final double price;

  Booking({
    required this.id,
    required this.service,
    required this.trainer,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.price,
  });
}

class Trainer {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int experience;
  final String imageUrl;
  final String description;
  final List<String> specialties;
  final double pricePerHour;

  Trainer({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    required this.imageUrl,
    required this.description,
    required this.specialties,
    required this.pricePerHour,
  });
}
