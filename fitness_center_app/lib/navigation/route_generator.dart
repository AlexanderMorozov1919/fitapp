import 'package:flutter/material.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/screens/home_screen.dart';
import 'package:fitness_center_app/screens/renew_subscription_screen.dart';
import 'package:fitness_center_app/screens/book_service_screen.dart';
import 'package:fitness_center_app/screens/parking_screen.dart';
import 'package:fitness_center_app/screens/parking_history_screen.dart';
import 'package:fitness_center_app/screens/profile_screen.dart';
import 'package:fitness_center_app/screens/booking_detail_screen.dart';
import 'package:fitness_center_app/screens/trainers_screen.dart';
import 'package:fitness_center_app/screens/trainer_profile_screen.dart';
import 'package:fitness_center_app/screens/trainer_booking_screen.dart';
import 'package:fitness_center_app/screens/subscriptions_screen.dart';
import 'package:fitness_center_app/screens/locker_screen.dart';
import 'package:fitness_center_app/screens/settings_screen.dart';
import 'package:fitness_center_app/screens/chat_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.renewSubscription:
        return MaterialPageRoute(builder: (_) => const RenewSubscriptionScreen());
      case AppRoutes.bookService:
        return MaterialPageRoute(builder: (_) => const BookServiceScreen());
      case AppRoutes.parking:
        return MaterialPageRoute(builder: (_) => const ParkingScreen());
      case AppRoutes.parkingHistory:
        return MaterialPageRoute(builder: (_) => const ParkingHistoryScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.bookingDetail:
        final booking = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: booking));
      case AppRoutes.trainers:
        return MaterialPageRoute(builder: (_) => const TrainersScreen());
      case AppRoutes.trainerProfile:
        final trainer = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => TrainerProfileScreen(trainer: trainer));
      case AppRoutes.trainerBooking:
        final trainer = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => TrainerBookingScreen(trainer: trainer));
      case AppRoutes.subscriptions:
        return MaterialPageRoute(builder: (_) => const SubscriptionsScreen());
      case AppRoutes.locker:
        return MaterialPageRoute(builder: (_) => const LockerScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}