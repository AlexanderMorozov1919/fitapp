import 'package:flutter/material.dart';
import 'package:fitness_app/models/booking_model.dart';
import 'package:fitness_app/models/trainer_model.dart';
import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/screens/tennis_selection_screen.dart';
import 'package:fitness_app/screens/tennis_time_selection_screen.dart';
import 'package:fitness_app/screens/tennis_confirmation_screen.dart';
import 'package:fitness_app/screens/class_selection_screen.dart';
import 'package:fitness_app/screens/class_confirmation_screen.dart';
import 'package:fitness_app/screens/membership_screen.dart';
import 'package:fitness_app/screens/trainers_screen.dart';
import 'package:fitness_app/screens/schedule_screen.dart';
import 'package:fitness_app/screens/profile_screen.dart';
import 'package:fitness_app/screens/bookings_screen.dart';
import 'package:fitness_app/screens/payment_screen.dart';
import 'package:fitness_app/screens/locker_screen.dart';
import 'package:fitness_app/screens/booking_detail_screen.dart';
import 'package:fitness_app/screens/cancel_booking_screen.dart';
import 'package:fitness_app/screens/reschedule_booking_screen.dart';
import 'package:fitness_app/screens/class_detail_screen.dart';
import 'package:fitness_app/screens/membership_detail_screen.dart';
import 'package:fitness_app/widgets/bottom_navigation.dart';
import 'package:fitness_app/widgets/phone_frame.dart';

void main() {
  runApp(const FitnessApp());
}

// Расширенный InheritedWidget для передачи функций навигации
class NavigationService extends InheritedWidget {
  final VoidCallback onBack;
  final Function(String, [dynamic]) navigateTo;

  const NavigationService({
    super.key,
    required this.onBack,
    required this.navigateTo,
    required super.child,
  });

  static NavigationService? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationService>();
  }

  @override
  bool updateShouldNotify(NavigationService oldWidget) {
    return oldWidget.onBack != onBack || oldWidget.navigateTo != navigateTo;
  }
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фитнес Трекер',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SimplePhoneBorder(
        child: MainNavigation(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  // Дополнительные экраны для быстрого доступа
  final Map<String, Widget Function(dynamic)> _quickAccessScreens = {
    'tennis': (_) => const TennisSelectionScreen(),
    'tennis_time_selection': (data) => TennisTimeSelectionScreen(selectedCourt: data),
    'tennis_confirmation': (data) => TennisConfirmationScreen(bookingData: data),
    'class_selection': (data) {
      if (data is GroupClass) {
        return ClassSelectionScreen(preselectedClass: data);
      } else {
        return const ClassSelectionScreen();
      }
    },
    'class_confirmation': (data) => ClassConfirmationScreen(selectedClass: data),
    'trainers': (_) => const TrainersScreen(),
    'membership': (_) => const MembershipScreen(),
    'payment': (data) {
      if (data is Map<String, dynamic>) {
        return PaymentScreen(bookingData: data);
      } else if (data is Booking) {
        // Конвертируем Booking в Map для обратной совместимости
        return PaymentScreen(bookingData: {
          'booking': data,
          'amount': data.price,
          'description': 'Оплата бронирования: ${data.title}',
        });
      }
      return PaymentScreen(bookingData: null);
    },
    'locker': (_) => const LockerScreen(),
    'bookings': (_) => const BookingsScreen(),
    'schedule': (_) => const ScheduleScreen(),
    'booking_detail': (data) => BookingDetailScreen(booking: data),
    'cancel_booking': (data) => CancelBookingScreen(booking: data),
    'reschedule_booking': (data) => RescheduleBookingScreen(booking: data),
    'class_detail': (data) => ClassDetailScreen(groupClass: data),
    'membership_detail': (data) => MembershipDetailScreen(membershipData: data),
  };

  List<Map<String, dynamic>> _navigationStack = [];
  
  String? get _currentQuickAccessScreen => _navigationStack.isNotEmpty
      ? _navigationStack.last['screen']
      : null;
      
  dynamic get _quickAccessData => _navigationStack.isNotEmpty
      ? _navigationStack.last['data']
      : null;

  static Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$title - Раздел в разработке',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onQuickAccessNavigate: _navigateToQuickAccess),
      const ScheduleScreen(),
      const BookingsScreen(),
      const ProfileScreen(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _navigationStack.clear(); // Сбрасываем стек при переключении табов
    });
  }

  void _navigateToQuickAccess(String screenKey, [dynamic data]) {
    setState(() {
      _navigationStack.add({
        'screen': screenKey,
        'data': data,
      });
    });
  }

  void _navigateBack() {
    setState(() {
      if (_navigationStack.isNotEmpty) {
        _navigationStack.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;

    if (_currentQuickAccessScreen != null) {
      // Показываем экран быстрого доступа с оберткой для навигации назад
      currentBody = NavigationService(
        onBack: _navigateBack,
        navigateTo: _navigateToQuickAccess,
        child: _quickAccessScreens[_currentQuickAccessScreen]!(_quickAccessData),
      );
    } else {
      // Показываем основной экран навигации
      currentBody = _screens[_currentIndex];
    }

    return Scaffold(
      body: currentBody,
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
