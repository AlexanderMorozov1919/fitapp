import 'package:flutter/material.dart';

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
