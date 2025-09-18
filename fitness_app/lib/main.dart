import 'package:flutter/material.dart';
import 'package:fitness_app/models/booking_model.dart';
import 'package:fitness_app/models/trainer_model.dart';
import 'package:fitness_app/screens/clietnt/home_screen.dart';
import 'package:fitness_app/screens/clietnt/tennis_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/tennis_time_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/tennis_confirmation_screen.dart';
import 'package:fitness_app/screens/clietnt/class_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/class_confirmation_screen.dart';
import 'package:fitness_app/screens/clietnt/membership_screen.dart';
import 'package:fitness_app/screens/clietnt/trainers_screen.dart' hide TrainerDetailScreen;
import 'package:fitness_app/screens/clietnt/trainer_detail_screen.dart';
import 'package:fitness_app/screens/clietnt/trainer_service_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/trainer_time_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/trainer_confirmation_screen.dart';
import 'package:fitness_app/screens/clietnt/schedule_screen.dart';
import 'package:fitness_app/screens/clietnt/schedule_confirmation_screen.dart';
import 'package:fitness_app/screens/clietnt/profile_screen.dart';
import 'package:fitness_app/screens/clietnt/chat_screen.dart';
import 'package:fitness_app/screens/clietnt/bookings_screen.dart';
import 'package:fitness_app/screens/clietnt/payment_screen.dart';
import 'package:fitness_app/screens/clietnt/payment_success_screen.dart';
import 'package:fitness_app/screens/clietnt/locker_screen.dart';
import 'package:fitness_app/screens/clietnt/booking_detail_screen.dart';
import 'package:fitness_app/screens/clietnt/cancel_booking_screen.dart';
import 'package:fitness_app/screens/clietnt/reschedule_booking_screen.dart';
import 'package:fitness_app/screens/clietnt/class_detail_screen.dart';
import 'package:fitness_app/screens/clietnt/membership_detail_screen.dart';
import 'package:fitness_app/screens/clietnt/user_type_selection_screen.dart';
import 'package:fitness_app/theme/app_colors.dart';
import 'package:fitness_app/widgets/bottom_navigation.dart';
import 'package:fitness_app/widgets/phone_frame.dart';

void main() {
  runApp(const UserTypeSelectionWrapper());
}

class UserTypeSelectionWrapper extends StatefulWidget {
  const UserTypeSelectionWrapper({super.key});

  @override
  State<UserTypeSelectionWrapper> createState() => _UserTypeSelectionWrapperState();
}

class _UserTypeSelectionWrapperState extends State<UserTypeSelectionWrapper> {
  UserType? _selectedUserType;

  void _handleUserTypeSelected(UserType userType) {
    setState(() {
      _selectedUserType = userType;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedUserType == null) {
      return MaterialApp(
        title: 'Фитнес Трекер',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: SimplePhoneBorder(
          child: UserTypeSelectionScreen(
            onUserTypeSelected: _handleUserTypeSelected,
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    } else if (_selectedUserType == UserType.client) {
      return const FitnessApp();
    } else {
      // Заглушка для сотрудника
      return MaterialApp(
        title: 'Фитнес Трекер - Сотрудник',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: SimplePhoneBorder(
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work, size: 64, color: AppColors.success),
                  const SizedBox(height: 16),
                  Text(
                    'Панель сотрудника',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Раздел в разработке',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }
  }
}

// Расширенный InheritedWidget для передачи функций навигации
class NavigationService extends InheritedWidget {
  final VoidCallback onBack;
  final Function(String, [dynamic]) navigateTo;
  final VoidCallback navigateToHome;

  const NavigationService({
    super.key,
    required this.onBack,
    required this.navigateTo,
    required this.navigateToHome,
    required super.child,
  });

  static NavigationService? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationService>();
  }

  @override
  bool updateShouldNotify(NavigationService oldWidget) {
    return oldWidget.onBack != onBack ||
           oldWidget.navigateTo != navigateTo ||
           oldWidget.navigateToHome != navigateToHome;
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
    'trainer_detail': (data) => TrainerDetailScreen(trainer: data),
    'trainer_service_selection': (data) => TrainerServiceSelectionScreen(trainer: data),
    'trainer_time_selection': (data) => TrainerTimeSelectionScreen(selectionData: data),
    'trainer_confirmation': (data) => TrainerConfirmationScreen(bookingData: data),
    'schedule_confirmation': (data) => ScheduleConfirmationScreen(groupClass: data),
    'payment_success': (data) {
      if (data is Map<String, dynamic>) {
        return PaymentSuccessScreen(
          amount: data['amount'],
          paymentMethod: data['paymentMethod'],
          description: data['description'],
        );
      }
      return const PaymentSuccessScreen(
        amount: 0,
        paymentMethod: 'Неизвестно',
      );
    },
    'chat': (_) => const ChatScreen(),
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

  void _navigateToHome() {
    setState(() {
      _navigationStack.clear(); // Полностью очищаем стек навигации
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
        navigateToHome: _navigateToHome,
        child: _quickAccessScreens[_currentQuickAccessScreen]!(_quickAccessData),
      );
    } else {
      // Показываем основной экран навигации с оберткой для навигации
      currentBody = NavigationService(
        onBack: () {
          // Для основных экранов просто переключаем на главную вкладку
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
          }
        },
        navigateTo: _navigateToQuickAccess,
        navigateToHome: _navigateToHome,
        child: _screens[_currentIndex],
      );
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
