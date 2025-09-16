import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/widgets/app_container.dart';

class RenewSubscriptionScreen extends StatefulWidget {
  const RenewSubscriptionScreen({super.key});

  @override
  State<RenewSubscriptionScreen> createState() => _RenewSubscriptionScreenState();
}

class _RenewSubscriptionScreenState extends State<RenewSubscriptionScreen> {
  int _currentStep = 0;
  String? _selectedPeriod;
  String? _selectedPaymentMethod;

  final List<Map<String, dynamic>> _periodOptions = [
    {
      'name': '1 месяц',
      'price': '12 990 ₽',
      'description': 'Ежемесячно',
      'savings': null,
    },
    {
      'name': '3 месяца',
      'price': '34 990 ₽',
      'description': 'Экономия 10%',
      'savings': '3 900 ₽',
    },
    {
      'name': '6 месяцев',
      'price': '64 990 ₽',
      'description': 'Экономия 15%',
      'savings': '11 400 ₽',
    },
    {
      'name': '12 месяцев',
      'price': '119 990 ₽',
      'description': 'Экономия 25%',
      'savings': '35 890 ₽',
    },
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
      if (_currentStep < 2) {
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

  void _selectPeriod(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
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
                  'Продление абонемента',
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
                  if (_currentStep == 0) _buildPeriodSelection(),
                  if (_currentStep == 1) _buildPaymentSelection(),
                  if (_currentStep == 2) _buildConfirmation(),
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
                _currentStep == 2 ? 'Завершить' : 'Далее',
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
          _buildStepCircle(1, 'Период'),
          _buildStepLine(),
          _buildStepCircle(2, 'Оплата'),
          _buildStepLine(),
          _buildStepCircle(3, 'Готово'),
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
              style: TextStyle(
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

  Widget _buildPeriodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                'Продление абонемента',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'All-inclusive Премиум',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'Выберите период продления',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1.2,
          children: _periodOptions.map((option) {
            final isSelected = _selectedPeriod == option['name'];
            return GestureDetector(
              onTap: () => _selectPeriod(option['name']),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppTheme.primary : AppTheme.dark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      option['price'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                    if (option['description'] != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        option['description'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentSelection() {
    final selectedPeriod = _periodOptions.firstWhere(
      (opt) => opt['name'] == _selectedPeriod,
      orElse: () => _periodOptions[1],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                'Оплата продления',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'All-inclusive Премиум',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

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
              _buildSummaryItem('Абонемент', 'All-inclusive Премиум'),
              _buildSummaryItem('Период', selectedPeriod['name']),
              _buildSummaryItem('Стоимость', selectedPeriod['price']),
              if (selectedPeriod['savings'] != null)
                _buildSummaryItem('Скидка', '-${selectedPeriod['savings']} (10%)'),
              const Divider(height: 30),
              _buildSummaryItem('Итого', selectedPeriod['price'], isTotal: true),
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
                      ? AppTheme.primary.withOpacity(0.1)
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
          'Абонемент продлен!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Ваш абонемент успешно продлен. Новое окончание срока действия: 15.07.2024',
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
              _buildConfirmationItem('Абонемент', 'All-inclusive Премиум'),
              _buildConfirmationItem('Период', '3 месяца'),
              _buildConfirmationItem('Стоимость', '34 990 ₽'),
              _buildConfirmationItem('Новое окончание', '15.07.2024'),
              _buildConfirmationItem('Номер транзакции', '#SUB-20240310-001'),
            ],
          ),
        ),
      ],
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

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedPeriod != null;
      case 1:
        return _selectedPaymentMethod != null;
      case 2:
        return true;
      default:
        return false;
    }
  }
}