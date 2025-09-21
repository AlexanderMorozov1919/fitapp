import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/models/booking_model.dart';
import 'package:fitness_app/models/trainer_model.dart';
import 'package:fitness_app/models/user_model.dart';
import 'package:fitness_app/models/product_model.dart';
import 'package:fitness_app/services/mock_data_service.dart';
import 'package:fitness_app/screens/clietnt/home_screen.dart';
import 'package:fitness_app/screens/clietnt/booking_confirmation_screen.dart';
import 'package:fitness_app/models/booking_confirmation_models.dart';
import 'package:fitness_app/screens/clietnt/shop_screen.dart';
import 'package:fitness_app/screens/clietnt/purchase_history_screen.dart';
import 'package:fitness_app/screens/employee/home_screen.dart';
import 'package:fitness_app/screens/employee/schedule_screen.dart' as employee_schedule;
import 'package:fitness_app/screens/employee/kpi_screen.dart';
import 'package:fitness_app/screens/employee/training_detail_screen.dart';
import 'package:fitness_app/screens/employee/create_training_screen.dart';
import 'package:fitness_app/screens/employee/employee_schedule_screen.dart';
import 'package:fitness_app/screens/employee/add_client_screen.dart';
import 'package:fitness_app/screens/employee/clients_screen.dart';
import 'package:fitness_app/screens/employee/client_detail_screen.dart';
import 'package:fitness_app/screens/employee/employee_tennis_screen.dart';
import 'package:fitness_app/screens/employee/employee_tennis_time_selection_screen.dart';
import 'package:fitness_app/screens/employee/employee_tennis_booking_screen.dart';
import 'package:fitness_app/screens/employee/record_screen.dart';
import 'package:fitness_app/screens/employee/employee_combined_chat_screen.dart';
import 'package:fitness_app/screens/employee/select_client_screen.dart';
import 'package:fitness_app/screens/employee/cancel_training_screen.dart';
import 'package:fitness_app/screens/employee/edit_training_screen.dart';
import 'package:fitness_app/screens/employee/reschedule_training_screen.dart';
import 'package:fitness_app/screens/employee/kpi_detail_screen.dart';
import 'package:fitness_app/screens/employee/security_settings_screen.dart';
import 'package:fitness_app/screens/employee/help_support_screen.dart';
import 'package:fitness_app/screens/clietnt/payment_methods_screen.dart';
import 'package:fitness_app/screens/clietnt/security_settings_screen.dart';
import 'package:fitness_app/screens/clietnt/help_support_screen.dart';
import 'package:fitness_app/screens/clietnt/locker_detail_screen.dart';
import 'package:fitness_app/screens/clietnt/tennis_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/tennis_time_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/tennis_booking_screen.dart';
import 'package:fitness_app/screens/clietnt/class_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/membership_screen.dart';
import 'package:fitness_app/screens/clietnt/trainers_screen.dart';
import 'package:fitness_app/screens/clietnt/trainer_detail_screen.dart';
import 'package:fitness_app/screens/clietnt/trainer_service_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/trainer_time_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/schedule_screen.dart';
import 'package:fitness_app/screens/clietnt/profile_screen.dart';
import 'package:fitness_app/screens/clietnt/product_selection_screen.dart';
import 'package:fitness_app/screens/clietnt/product_detail_screen.dart';
import 'package:fitness_app/screens/employee/profile_screen.dart';
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
import 'package:fitness_app/screens/clietnt/story_view_screen.dart';
import 'package:fitness_app/services/story_service.dart';
import 'package:fitness_app/theme/app_colors.dart';
import 'package:fitness_app/widgets/bottom_navigation.dart';
import 'package:fitness_app/widgets/demo_disclaimer.dart';
import 'package:fitness_app/widgets/employee_bottom_navigation.dart';
import 'package:fitness_app/widgets/phone_frame.dart';
import 'package:fitness_app/widgets/notification_overlay.dart';

void main() {
  // Обновляем статусы прошедших бронирований при старте приложения
  MockDataService.updatePastBookingsStatus();
  runApp(const UserTypeSelectionWrapper());
}

// Утилитный класс для работы с определением устройства
class DeviceUtils {
  static bool isMobileDevice() {
    try {
      // Проверяем флаг isMobileDevice, установленный в JavaScript
      final dynamic result = js.context['isMobileDevice'];
      return result == true;
    } catch (e) {
      // В случае ошибки возвращаем false (не мобильное устройство)
      return false;
    }
  }
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
        title: 'Фитнес приложение',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: _buildDemoLayout(
          UserTypeSelectionScreen(
            onUserTypeSelected: _handleUserTypeSelected,
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    } else if (_selectedUserType == UserType.client) {
      return const FitnessApp();
    } else {
      return const EmployeeFitnessApp();
    }
  }

  Widget _buildDemoLayout(Widget content) {
    // Проверяем, является ли устройство мобильным
    final bool isMobile = DeviceUtils.isMobileDevice();
    
    if (isMobile) {
      // Для мобильных устройств возвращаем прямой контент без обертки
      return content;
    } else {
      // Для десктопов оборачиваем в SimplePhoneBorder и добавляем диклеймер
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            // Центрируем телефон по центру экрана
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SimplePhoneBorder(
                  child: content,
                ),
              ),
            ),
            // Размещаем дисклеймер слева от центра с равными отступами
            Positioned(
              left: 40,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: const DemoDisclaimer(),
              ),
            ),
          ],
        ),
      );
    }
  }

}

// Расширенный InheritedWidget для передачи функций навигации
class NavigationService extends InheritedWidget {
  final VoidCallback onBack;
  final Function(String, [dynamic]) navigateTo;
  final VoidCallback navigateToHome;
  final Function(String, [dynamic]) navigateToWithResult;
  final Function(String, [dynamic]) navigateToWithCallback;

  const NavigationService({
    super.key,
    required this.onBack,
    required this.navigateTo,
    required this.navigateToHome,
    required this.navigateToWithResult,
    required this.navigateToWithCallback,
    required super.child,
  });

  static NavigationService? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationService>();
  }

  @override
  bool updateShouldNotify(NavigationService oldWidget) {
    return oldWidget.onBack != onBack ||
           oldWidget.navigateTo != navigateTo ||
           oldWidget.navigateToHome != navigateToHome ||
           oldWidget.navigateToWithResult != navigateToWithResult ||
           oldWidget.navigateToWithCallback != navigateToWithCallback;
  }
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoryService(),
      child: MaterialApp(
        title: 'Фитнес приложение',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: _buildDemoLayout(
          const NotificationOverlayManager(
            child: MainNavigation(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Widget _buildDemoLayout(Widget content) {
    // Проверяем, является ли устройство мобильным
    final bool isMobile = DeviceUtils.isMobileDevice();
    
    if (isMobile) {
      // Для мобильных устройств возвращаем прямой контент без обертки
      return content;
    } else {
      // Для десктопов оборачиваем в SimplePhoneBorder и добавляем диклеймер
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            // Центрируем телефон по центру экрана
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SimplePhoneBorder(
                  child: content,
                ),
              ),
            ),
            // Размещаем дисклеймер слева от центра с равными отступами
            Positioned(
              left: 40,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: const DemoDisclaimer(),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class EmployeeFitnessApp extends StatelessWidget {
  const EmployeeFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoryService(),
      child: MaterialApp(
        title: 'Фитнес приложение - Сотрудник',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: _buildDemoLayout(
          const NotificationOverlayManager(
            child: EmployeeMainNavigation(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Widget _buildDemoLayout(Widget content) {
    // Проверяем, является ли устройство мобильным
    final bool isMobile = DeviceUtils.isMobileDevice();
    
    if (isMobile) {
      // Для мобильных устройств возвращаем прямой контент без обертки
      return content;
    } else {
      // Для десктопов оборачиваем в SimplePhoneBorder и добавляем диклеймер
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            // Центрируем телефон по центру экрана
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SimplePhoneBorder(
                  child: content,
                ),
              ),
            ),
            // Размещаем дисклеймер слева от центра с равными отступами
            Positioned(
              left: 40,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: const DemoDisclaimer(),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class EmployeeMainNavigation extends StatefulWidget {
  const EmployeeMainNavigation({super.key});

  @override
  State<EmployeeMainNavigation> createState() => _EmployeeMainNavigationState();
}

class _EmployeeMainNavigationState extends State<EmployeeMainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  // Дополнительные экраны для быстрого доступа
  final Map<String, Widget Function(dynamic)> _quickAccessScreens = {
    'employee_schedule': (_) => const employee_schedule.EmployeeScheduleScreen(),
    'employee_kpi': (_) => const EmployeeKpiScreen(),
    'clients': (_) => const ClientsScreen(),
    'client_detail': (data) => ClientDetailScreen(client: data),
    'chat': (_) => const EmployeeCombinedChatScreen(),
    'training_detail': (data) {
      if (data is Map<String, dynamic>) {
        return TrainingDetailScreen(
          training: data['training'],
          onTrainingUpdated: data['onTrainingUpdated'],
        );
      }
      return TrainingDetailScreen(training: data);
    },
    'create_training': (data) {
      if (data is Map<String, dynamic>) {
        return CreateTrainingScreen(
          freeTimeSlot: data['freeTimeSlot'],
          preselectedClient: data['preselectedClient'],
        );
      } else {
        return CreateTrainingScreen(
          freeTimeSlot: data,
        );
      }
    },
    'employee_schedule_calendar': (_) => EmployeeScheduleScreen(),
    'add_client': (_) => const AddClientScreen(),
    'employee_tennis': (_) => EmployeeTennisBookingScreen(),
    'record_screen': (data) {
      if (data is Map<String, dynamic>) {
        return RecordScreen(preselectedClient: data['preselectedClient']);
      } else {
        return const RecordScreen();
      }
    },
    'employee_combined_chat': (_) => const EmployeeCombinedChatScreen(),
    'employee_tennis_time_selection': (data) => EmployeeTennisTimeSelectionScreen(
          selectedCourt: data['court'],
          selectedClient: data['client'],
        ),
    'select_client': (data) => SelectClientScreen(
          onClientSelected: data?['onClientSelected'],
        ),
    'reschedule_training': (data) => RescheduleTrainingScreen(
          training: data['training'],
        ),
    'cancel_training': (data) => CancelTrainingScreen(
          training: data['training'],
        ),
    'edit_training': (data) => EditTrainingScreen(
          training: data['training'],
        ),
    'employee_chat': (data) => EmployeeCombinedChatScreen(),
    'kpi_detail': (_) => const KpiDetailScreen(),
    'security_settings': (_) => const SecuritySettingsScreen(),
    'help_support': (_) => const HelpSupportScreen(),
    'booking_confirmation': (data) {
      if (data is BookingConfirmationConfig) {
        return BookingConfirmationScreen(config: data);
      }
      return BookingConfirmationScreen(
        config: BookingConfirmationConfig(
          type: ConfirmationBookingType.personalTraining,
          title: 'Бронирование',
          serviceName: 'Услуга',
          price: 0,
          date: DateTime.now(),
          isEmployeeBooking: true, // Для сотрудника по умолчанию
        ),
      );
    },
    'shop': (data) {
      final isEmployee = data is Map ? data['isEmployee'] == true : false;
      return ShopScreen(isEmployee: isEmployee);
    },
    'purchase_history': (data) {
      final isEmployee = data is Map ? data['isEmployee'] == true : false;
      return PurchaseHistoryScreen(isEmployee: isEmployee);
    },
    'product_detail': (data) {
      if (data is Map<String, dynamic>) {
        return ProductDetailScreen(
          productId: data['productId'],
        );
      }
      return ProductDetailScreen(
        productId: data is Product ? data.id : data.toString(),
      );
    },
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
      EmployeeHomeScreen(onQuickAccessNavigate: _navigateToQuickAccess),
      const employee_schedule.EmployeeScheduleScreen(),
      const EmployeeKpiScreen(),
      const EmployeeProfileScreen(),
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

  void _navigateToWithResult(String screenKey, [dynamic data]) {
    setState(() {
      _navigationStack.add({
        'screen': screenKey,
        'data': data,
      });
    });
  }

  void _navigateToWithCallback(String screenKey, [dynamic data]) {
    setState(() {
      _navigationStack.add({
        'screen': screenKey,
        'data': data,
      });
    });
  }

  void _navigateBack() {
    if (_navigationStack.isNotEmpty) {
      setState(() {
        _navigationStack.removeLast();
      });
    }
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
        navigateToWithResult: _navigateToWithResult,
        navigateToWithCallback: _navigateToWithCallback,
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
        navigateToWithResult: _navigateToWithResult,
        navigateToWithCallback: _navigateToWithCallback,
        child: _screens[_currentIndex],
      );
    }

    return Scaffold(
      body: currentBody,
      bottomNavigationBar: EmployeeBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
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
    'tennis': (_) => const TennisBookingScreen(),
    'tennis_selection': (_) => const TennisSelectionScreen(),
    'tennis_time_selection': (data) => TennisTimeSelectionScreen(selectedCourt: data),
    'class_selection': (data) {
      if (data is GroupClass) {
        return ClassSelectionScreen(preselectedClass: data);
      } else {
        return const ClassSelectionScreen();
      }
    },
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
    'booking_confirmation': (data) {
      if (data is BookingConfirmationConfig) {
        return BookingConfirmationScreen(config: data);
      }
      return BookingConfirmationScreen(
        config: BookingConfirmationConfig(
          type: ConfirmationBookingType.personalTraining,
          title: 'Бронирование',
          serviceName: 'Услуга',
          price: 0,
          date: DateTime.now(),
        ),
      );
    },
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
    'story_view': (data) {
      if (data is Map<String, dynamic>) {
        return Builder(
          builder: (context) {
            return StoryViewScreen(
              initialStoryId: data['initialStoryId'],
              stories: data['stories'],
              onClose: () {
                // Простой вызов Navigator.pop - должен работать
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          },
        );
      }
      return const StoryViewScreen(
        initialStoryId: '',
        stories: [],
      );
    },
    'payment_methods': (_) => const PaymentMethodsScreen(),
    'security_settings': (_) => const ClientSecuritySettingsScreen(),
    'help_support': (_) => const ClientHelpSupportScreen(),
    'locker_detail': (data) {
      if (data is Map<String, dynamic>) {
        return LockerDetailScreen(
          locker: data['locker'],
          rentalDays: data['rentalDays'] ?? 1,
        );
      }
      return LockerDetailScreen(
        locker: Locker(
          id: 'default',
          number: '0',
          size: 'Small',
          isAvailable: true,
          pricePerDay: 100,
        ),
      );
    },
    'product_selection': (data) {
      if (data is Map<String, dynamic>) {
        return ProductSelectionScreen(
          bookingType: data['bookingType'],
          onProductsSelected: data['onProductsSelected'],
        );
      }
      return ProductSelectionScreen(
        bookingType: BookingType.groupClass,
        onProductsSelected: (_) {},
      );
    },
    'product_detail': (data) {
      if (data is Map<String, dynamic>) {
        return ProductDetailScreen(
          productId: data['productId'],
        );
      }
      return ProductDetailScreen(
        productId: data is Product ? data.id : data.toString(),
      );
    },
    'shop': (_) => const ShopScreen(),
    'purchase_history': (_) => const PurchaseHistoryScreen(),
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

  void _navigateToWithResult(String screenKey, [dynamic data]) {
    setState(() {
      _navigationStack.add({
        'screen': screenKey,
        'data': data,
      });
    });
  }

  void _navigateToWithCallback(String screenKey, [dynamic data]) {
    setState(() {
      _navigationStack.add({
        'screen': screenKey,
        'data': data,
      });
    });
  }

  void _navigateBack() {
    if (_navigationStack.isNotEmpty) {
      setState(() {
        _navigationStack.removeLast();
      });
    }
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
        navigateToWithResult: _navigateToWithResult,
        navigateToWithCallback: _navigateToWithCallback,
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
        navigateToWithResult: _navigateToWithResult,
        navigateToWithCallback: _navigateToWithCallback,
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
