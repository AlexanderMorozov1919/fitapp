import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/status_bar.dart';
import 'package:fitness_app/widgets/navigation_bar.dart' as custom;
import 'package:fitness_app/widgets/booking_modal.dart';
import 'package:fitness_app/widgets/trainer_modal.dart';
import 'package:fitness_app/screens/home_page.dart';
import 'package:fitness_app/screens/schedule_page.dart';
import 'package:fitness_app/screens/trainers_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePage = 'home';
  String notificationMessage = '';
  bool showNotification = false;
  String searchQuery = '';
  dynamic selectedTrainer;
  dynamic selectedEvent;
  List<dynamic> cartItems = [];
  Map<String, String> bookingForm = {
    'name': '',
    'email': '',
    'phone': '',
    'eventId': ''
  };
  bool showBookingModal = false;
  bool showTrainerModal = false;

  // Данные для приложения
  final List<Map<String, dynamic>> trainers = [
    {'id': 1, 'name': 'Иван Петров', 'specialty': 'Персональный тренер', 'rating': 4.9, 'avatar': 'И'},
    {'id': 2, 'name': 'Мария Сидорова', 'specialty': 'Инструктор йоги', 'rating': 4.8, 'avatar': 'М'},
    {'id': 3, 'name': 'Алексей Козлов', 'specialty': 'Фитнес-тренер', 'rating': 4.7, 'avatar': 'А'},
    {'id': 4, 'name': 'Елена Волкова', 'specialty': 'Инструктор пилатеса', 'rating': 4.9, 'avatar': 'Е'},
    {'id': 5, 'name': 'Дмитрий Смирнов', 'specialty': 'Силовой тренер', 'rating': 4.6, 'avatar': 'Д'},
    {'id': 6, 'name': 'Анна Кузнецова', 'specialty': 'Инструктор Zumba', 'rating': 4.8, 'avatar': 'А'},
  ];

  final List<Map<String, dynamic>> events = [
    {'id': 1, 'title': 'Йога для начинающих', 'time': '10:00 - 11:00', 'location': 'Зал 1', 'trainer': 'Иван Петров', 'color': 'blue'},
    {'id': 2, 'title': 'Аэробика', 'time': '11:30 - 13:00', 'location': 'Зал 2', 'trainer': 'Мария Сидорова', 'color': 'green'},
    {'id': 3, 'title': 'Кардио тренировка', 'time': '14:00 - 15:00', 'location': 'Зал 3', 'trainer': 'Алексей Козлов', 'color': 'orange'},
    {'id': 4, 'title': 'Пилатес', 'time': '15:30 - 16:30', 'location': 'Зал 1', 'trainer': 'Елена Волкова', 'color': 'purple'},
    {'id': 5, 'title': 'Силовая тренировка', 'time': '18:00 - 19:30', 'location': 'Зал 2', 'trainer': 'Дмитрий Смирнов', 'color': 'red'},
    {'id': 6, 'title': 'Zumba', 'time': '20:00 - 21:00', 'location': 'Зал 3', 'trainer': 'Анна Кузнецова', 'color': 'teal'},
  ];

  final List<Map<String, dynamic>> products = [
    {'id': 1, 'name': 'Футболка FitnessPro', 'price': 1500, 'category': 'Одежда'},
    {'id': 2, 'name': 'Спортивный напиток', 'price': 350, 'category': 'Питание'},
    {'id': 3, 'name': 'Спортивная сумка', 'price': 2500, 'category': 'Аксессуары'},
  ];

  // Показ уведомления
  void showNotificationMessage(String message) {
    setState(() {
      notificationMessage = message;
      showNotification = true;
    });
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showNotification = false;
          notificationMessage = '';
        });
      }
    });
  }

  // Добавить в корзину
  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
    showNotificationMessage('${product['name']} добавлен в корзину');
  }

  // Открыть форму бронирования
  void openBookingForm(String eventId) {
    setState(() {
      bookingForm = {
        'name': '',
        'email': '',
        'phone': '',
        'eventId': eventId
      };
      showBookingModal = true;
    });
  }

  // Закрыть форму бронирования
  void closeBookingModal() {
    setState(() {
      showBookingModal = false;
    });
  }

  // Отправить форму бронирования
  void submitBookingForm() {
    if (bookingForm['name']!.isNotEmpty && 
        bookingForm['email']!.isNotEmpty && 
        bookingForm['phone']!.isNotEmpty) {
      showNotificationMessage('Вы успешно записались на занятие!');
      setState(() {
        showBookingModal = false;
      });
    } else {
      showNotificationMessage('Пожалуйста, заполните все поля');
    }
  }

  // Открыть профиль тренера
  void openTrainerProfile(Map<String, dynamic> trainer) {
    setState(() {
      selectedTrainer = trainer;
      showTrainerModal = true;
    });
  }

  // Закрыть профиль тренера
  void closeTrainerModal() {
    setState(() {
      showTrainerModal = false;
      selectedTrainer = null;
    });
  }

  // Главная страница
  Widget buildHomePage() {
    return HomePage(
      events: events,
      openBookingForm: openBookingForm,
      showNotificationMessage: () => showNotificationMessage('Напоминание установлено!'),
      onPageChanged: (page) => setState(() => activePage = page),
    );
  }

  // Страница расписания
  Widget buildSchedulePage() {
    return SchedulePage(
      events: events,
      openBookingForm: openBookingForm,
      showNotificationMessage: () => showNotificationMessage('Фильтрация по интересам в разработке'),
    );
  }

  // Страница тренеров
  Widget buildTrainersPage() {
    return TrainersPage(
      trainers: trainers,
      searchQuery: searchQuery,
      onSearchChanged: (value) => setState(() => searchQuery = value),
      openTrainerProfile: openTrainerProfile,
      showNotificationMessage: () => showNotificationMessage('Расширенный поиск в разработке'),
    );
  }

  // Рендер активной страницы
  Widget buildCurrentPage() {
    switch (activePage) {
      case 'home':
        return buildHomePage();
      case 'schedule':
        return buildSchedulePage();
      case 'trainers':
        return buildTrainersPage();
      case 'progress':
        return buildProgressPage();
      case 'shop':
        return buildShopPage();
      case 'profile':
        return buildProfilePage();
      default:
        return buildHomePage();
    }
  }

  // Заглушки для остальных страниц
  Widget buildProgressPage() {
    return Center(child: Text('Страница прогресса'));
  }

  Widget buildShopPage() {
    return Center(child: Text('Страница магазина'));
  }

  Widget buildProfilePage() {
    return Center(child: Text('Страница профиля'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: buildCurrentPage(),
              ),
              custom.NavigationBar(
                activePage: activePage,
                onPageChanged: (page) => setState(() => activePage = page),
              ),
            ],
          ),
          
          // Уведомление
          if (showNotification)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: const Border(left: BorderSide(color: Colors.green, width: 4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      notificationMessage,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          
          // Модальные окна
          if (showBookingModal)
            BookingModal(
              formData: bookingForm,
              onFormChanged: (field, value) => setState(() => bookingForm[field] = value),
              onClose: closeBookingModal,
              onSubmit: submitBookingForm,
            ),
          
          if (showTrainerModal && selectedTrainer != null)
            TrainerModal(
              trainer: selectedTrainer!,
              onClose: closeTrainerModal,
            ),
        ],
      ),
    );
  }
}