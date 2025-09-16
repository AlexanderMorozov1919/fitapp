import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/payment_model.dart';
import '../models/user_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double _amount = 0;
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'method': PaymentMethod.creditCard,
      'name': 'Кредитная карта',
      'icon': Icons.credit_card,
    },
    {
      'method': PaymentMethod.debitCard,
      'name': 'Дебетовая карта',
      'icon': Icons.credit_card,
    },
    {
      'method': PaymentMethod.applePay,
      'name': 'Apple Pay',
      'icon': Icons.phone_iphone,
    },
    {
      'method': PaymentMethod.googlePay,
      'name': 'Google Pay',
      'icon': Icons.phone_android,
    },
    {
      'method': PaymentMethod.balance,
      'name': 'Баланс счета',
      'icon': Icons.account_balance_wallet,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Пополнение счета'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Текущий баланс
            _buildBalanceCard(user),
            const SizedBox(height: 24),

            // Сумма пополнения
            const Text(
              'Сумма пополнения:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildAmountSelector(),
            const SizedBox(height: 24),

            // Способ оплаты
            const Text(
              'Способ оплаты:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethods(),
            const SizedBox(height: 24),

            // Форма оплаты
            if (_selectedMethod == PaymentMethod.creditCard ||
                _selectedMethod == PaymentMethod.debitCard)
              _buildCardForm(),

            // Кнопка оплаты
            const SizedBox(height: 32),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Текущий баланс:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                'Доступно для оплаты услуг',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Text(
            '${user.balance} руб.',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSelector() {
    final amounts = [500, 1000, 2000, 5000, 10000];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amounts.map((amount) {
        final isSelected = _amount == amount;
        return FilterChip(
          label: Text('$amount руб.'),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _amount = selected ? amount.toDouble() : 0;
            });
          },
          selectedColor: Colors.blue,
          checkmarkColor: Colors.white,
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: _paymentMethods.map((method) {
        final isSelected = _selectedMethod == method['method'];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          child: ListTile(
            leading: Icon(method['icon'] as IconData,
                color: isSelected ? Colors.blue : Colors.grey),
            title: Text(method['name'] as String),
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              setState(() {
                _selectedMethod = method['method'] as PaymentMethod;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Номер карты',
            border: OutlineInputBorder(),
            hintText: '0000 0000 0000 0000',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите номер карты';
            }
            if (value.replaceAll(' ', '').length != 16) {
              return 'Номер карты должен содержать 16 цифр';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardHolderController,
          decoration: const InputDecoration(
            labelText: 'Имя владельца',
            border: OutlineInputBorder(),
            hintText: 'IVAN IVANOV',
          ),
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите имя владельца';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Срок действия',
                  border: OutlineInputBorder(),
                  hintText: 'MM/YY',
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите срок действия';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                  hintText: '123',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите CVV';
                  }
                  if (value.length != 3) {
                    return 'CVV должен содержать 3 цифры';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    final canPay = _amount > 0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canPay ? _processPayment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          canPay ? 'Оплатить $_amount руб.' : 'Выберите сумму',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _processPayment() {
    if (_selectedMethod == PaymentMethod.creditCard ||
        _selectedMethod == PaymentMethod.debitCard) {
      // TODO: Валидация данных карты
      if (_cardNumberController.text.isEmpty ||
          _cardHolderController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заполните все поля карты'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение оплаты'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Сумма: $_amount руб.'),
            Text('Способ: ${_getMethodName(_selectedMethod)}'),
            const SizedBox(height: 16),
            const Text('Подтвердить оплату?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPaymentSuccess();
            },
            child: const Text('Оплатить'),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Счет успешно пополнен на $_amount руб.!'),
        backgroundColor: Colors.green,
      ),
    );

    // Очищаем форму
    setState(() {
      _amount = 0;
      _cardNumberController.clear();
      _cardHolderController.clear();
      _expiryController.clear();
      _cvvController.clear();
    });
  }

  String _getMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Кредитная карта';
      case PaymentMethod.debitCard:
        return 'Дебетовая карта';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
      case PaymentMethod.balance:
        return 'Баланс счета';
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}