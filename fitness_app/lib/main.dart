import 'package:flutter/material.dart';
import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/screens/tennis_booking_screen.dart';
import 'package:fitness_app/screens/membership_screen.dart';
import 'package:fitness_app/screens/trainers_screen.dart';
import 'package:fitness_app/screens/schedule_screen.dart';
import 'package:fitness_app/screens/profile_screen.dart';
import 'package:fitness_app/screens/bookings_screen.dart';
import 'package:fitness_app/screens/payment_screen.dart';
import 'package:fitness_app/screens/locker_screen.dart';
import 'package:fitness_app/widgets/bottom_navigation.dart';
import 'package:fitness_app/widgets/phone_frame.dart';

void main() {
  runApp(const FitnessApp());
}

// Простой InheritedWidget для передачи функции навигации назад
class NavigationService extends InheritedWidget {
  final VoidCallback onBack;

  const NavigationService({
    super.key,
    required this.onBack,
    required super.child,
  });

  static NavigationService? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationService>();
  }

  @override
  bool updateShouldNotify(NavigationService oldWidget) {
    return oldWidget.onBack != onBack;
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
  final Map<String, Widget> _quickAccessScreens = {
    'tennis': const TennisBookingScreen(),
    'trainers': const TrainersScreen(),
    'membership': const MembershipScreen(),
    'payment': const PaymentScreen(),
    'locker': const LockerScreen(),
  };

  String? _currentQuickAccessScreen;

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
      _currentQuickAccessScreen = null; // Сбрасываем быстрый доступ при переключении табов
    });
  }

  void _navigateToQuickAccess(String screenKey) {
    setState(() {
      _currentQuickAccessScreen = screenKey;
    });
  }

  void _navigateBack() {
    setState(() {
      _currentQuickAccessScreen = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;

    if (_currentQuickAccessScreen != null) {
      // Показываем экран быстрого доступа с оберткой для навигации назад
      currentBody = NavigationService(
        onBack: _navigateBack,
        child: _quickAccessScreens[_currentQuickAccessScreen]!,
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
