
import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/widgets/app_container.dart';

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  int _currentStep = 0;
  String? _selectedService;
  String? _selectedTime;
  String? _selectedPaymentMethod;

  final List<Map<String, dynamic>> _services = [
    {
      'name': 'Теннис',
      'icon': Icons.sports_tennis,
      'description': 'Индивидуальные и групповые занятия',
      'basePrice': 1200,
      'peakSurcharge': 240,
    },
    {
      'name': 'Групповая тренировка',
      'icon': Icons.group,
      'description': 'Разнообразные направления',
      'basePrice': 0,
      'peakSurcharge': 0,
    },
    {
      'name': 'Персональная тренировка',
      'icon': Icons.fitness_center,
      'description': 'Индивидуальный подход',
      'basePrice': 2500,
      'peakSurcharge': 0,
    },
  ];

  final List<String> _timeSlots = [
    '09:00', '10:00', '11:00', '12:00', '13:00', '14:00',
    '15:00', '16:00', '17:00', '18:00', '19:00', '20:00'
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'icon': Icons.credit_card,
      'name': 'Банковская карта',
      'type': 'card',
    },
    {
      'icon': Icons.apple,
      'name': 'Apple Pay',
      'type': 'apple_pay',
    },
    {
      'icon': Icons.card_giftcard,
      'name': 'Бонусные баллы (500)',
      'type': 'points',
    },
  ];

  void _nextStep() {
    setState(() {
      if (_currentStep < 3) {
        _currentStep++;
      } else {
        _completeBooking();
      }
    });
  }

  void _completeBooking() {
    // Здесь будет логика завершения бронирования
    AppNavigator.pop();
  }

  void _selectService(String service) {
    setState(() {
      _selectedService = service;
    });
  }

  void _selectTime(String time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Map<String, dynamic>? get _selectedServiceData {
    return _services.firstWhere(
      (s) => s['name'] == _selectedService,
      orElse: () => _services[0],
    );
  }

  int get _totalPrice {
    final service = _selectedServiceData;
    if (service == null) return 0;
    
    final basePrice = service['basePrice'] as int;
    final peakSurcharge = service['peakSurcharge'] as int;
    return basePrice + peakSurcharge;
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        children: [
          // Header with back button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => AppNavigator.pop(),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Запись на услугу',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Step indicator
          _buildStepIndicator(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_currentStep == 0) _buildServiceSelection(),
                  if (_currentStep == 1) _buildTimeSelection(),
                  if (_currentStep == 2) _buildPaymentSelection(),
                  if (_currentStep == 3) _buildConfirmation(),
                ],
              ),
            ),
          ),

          // Next button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _canProceed() ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                _currentStep == 3 ? 'Завершить' : 'Далее',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepCircle(1, 'Услуга'),
          _buildStepLine(),
          _buildStepCircle(2, 'Время'),
          _buildStepLine(),
          _buildStepCircle(3, 'Оплата'),
          _buildStepLine(),
          _buildStepCircle(4, 'Готово'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int stepNumber, String label) {
    final isActive = stepNumber - 1 == _currentStep;
    final isCompleted = stepNumber - 1 < _currentStep;

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppTheme.success
                : isActive
                    ? AppTheme.primary
                    : AppTheme.border,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? AppTheme.primary : AppTheme.gray,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: AppTheme.border,
        margin: const EdgeInsets.symmetric(horizontal: 5),
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                'Запись на услугу',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Выберите услугу для записи',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        
        Column(
          children: _services.map((service) {
            final isSelected = _selectedService == service['name'];
            return GestureDetector(
              onTap: () => _selectService(service['name']),
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withAlpha(25)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      service['icon'],
                      color: AppTheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppTheme.primary : AppTheme.dark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      service['basePrice'] == 0 
                          ? '0 ₽ (входит в абонемент)'
                          : 'от ${service['basePrice']} ₽/час',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              const Text(
                'Выбор времени',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _selectedService != null ? _selectedService! : 'Теннис',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        const Center(
          child: Text(
            '10 марта 2024',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.gray,
            ),
          ),
        ),
        const SizedBox(height: 20),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.5,
          children: _timeSlots.map((time) {
            final isSelected = _selectedTime == time;
            final isBooked = time == '11:00'; // Пример забронированного времени
            
            return GestureDetector(
              onTap: isBooked ? null : () => _selectTime(time),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isBooked
                      ? AppTheme.gray.withAlpha(76)
                      : isSelected
                          ? AppTheme.primary
                          : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isBooked
                        ? AppTheme.gray
                        : isSelected
                            ? AppTheme.primary
                            : AppTheme.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isBooked
                          ? Colors.white
                          : isSelected
                              ? Colors.white
                              : AppTheme.dark,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentSelection() {
    final service = _selectedServiceData;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                'Оплата услуги',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Теннис',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Center(
          child: Text(
            '${_selectedTime ?? '14:00'} - ${_getNextHour(_selectedTime ?? '14:00')}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        
        const Center(
          child: Text(
            '10 марта 2024',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.gray,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Order summary
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.light,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const Text(
                'Детали заказа',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildSummaryItem('Услуга', _selectedService ?? 'Теннис'),
              _buildSummaryItem('Дата и время', '10 марта 2024, ${_selectedTime ?? '14:00'}-${_getNextHour(_selectedTime ?? '14:00')}'),
              _buildSummaryItem('Стоимость', '${service?['basePrice'] ?? 1200} ₽'),
              if (service != null && service['peakSurcharge'] != null && service['peakSurcharge'] > 0)
                _buildSummaryItem('Пиковое время (+20%)', '+${service['peakSurcharge']} ₽'),
              const Divider(height: 30),
              _buildSummaryItem('Итого', '$_totalPrice ₽', isTotal: true),
            ],
          ),
        ),

        const SizedBox(height: 30),
        const Text(
          'Способ оплаты',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),

        Column(
          children: _paymentMethods.map((method) {
            final isSelected = _selectedPaymentMethod == method['type'];
            return GestureDetector(
              onTap: () => _selectPaymentMethod(method['type']),
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withAlpha(25)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      method['icon'],
                      color: AppTheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      method['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppTheme.primary : AppTheme.dark,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfirmation() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          size: 80,
          color: AppTheme.success,
        ),
        const SizedBox(height: 20),
        const Text(
          'Запись подтверждена!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Ваша запись успешно оформлена. Напоминание придет за 1 час до начала.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.light,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildConfirmationItem('Услуга', _selectedService ?? 'Теннис'),
              _buildConfirmationItem('Дата и время', '10 марта 2024, ${_selectedTime ?? '14:00'}-${_getNextHour(_selectedTime ?? '14:00')}'),
              _buildConfirmationItem('Место', 'Корт 3 (Хард покрытие)'),
              _buildConfirmationItem('Стоимость', '$_totalPrice ₽'),
              _buildConfirmationItem('Номер бронирования', '#TC-20240310-1400'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.gray,
              fontWeight: isTotal ? FontWeight.normal : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppTheme.primary : AppTheme.dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.gray,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getNextHour(String time) {
    final hour = int.parse(time.split(':')[0]);
    final nextHour = (hour + 1).toString().padLeft(2, '0');
    return '$nextHour:00';
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedService != null;
      case 1:
        return _selectedTime != null;
      case 2:
        return _selectedPaymentMethod != null;
      case 3:
        return true;
      default:
        return false;
    }
  }
}