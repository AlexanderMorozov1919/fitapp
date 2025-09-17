import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/payment_model.dart';
import '../models/user_model.dart';
import '../main.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';

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
      'color': AppColors.primary,
    },
    {
      'method': PaymentMethod.debitCard,
      'name': 'Дебетовая карта',
      'icon': Icons.credit_card,
      'color': AppColors.secondary,
    },
    {
      'method': PaymentMethod.applePay,
      'name': 'Apple Pay',
      'icon': Icons.phone_iphone,
      'color': AppColors.textPrimary,
    },
    {
      'method': PaymentMethod.googlePay,
      'name': 'Google Pay',
      'icon': Icons.phone_android,
      'color': AppColors.info,
    },
    {
      'method': PaymentMethod.balance,
      'name': 'Баланс счета',
      'icon': Icons.account_balance_wallet,
      'color': AppColors.success,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            final navigationService = NavigationService.of(context);
            navigationService?.onBack();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Текущий баланс
            _buildBalanceCard(user),
            const SizedBox(height: 24),

            // Сумма пополнения
            Text(
              'Сумма пополнения:',
              style: AppTextStyles.headline5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildAmountSelector(),
            const SizedBox(height: 24),

            // Способ оплаты
            Text(
              'Способ оплаты:',
              style: AppTextStyles.headline5.copyWith(
                fontWeight: FontWeight.w600,
              ),
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
    return GradientCard(
      gradient: AppColors.primaryGradient,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Текущий баланс:',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Доступно для оплаты услуг',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          Text(
            '${user.balance} руб.',
            style: AppTextStyles.headline4.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
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
        return FilterChipWidget(
          label: '$amount руб.',
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _amount = isSelected ? 0 : amount.toDouble();
            });
          },
          selectedColor: AppColors.primary,
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: _paymentMethods.map((method) {
        final isSelected = _selectedMethod == method['method'];
        final color = method['color'] as Color;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: AppStyles.paddingMd,
            leading: Icon(
              method['icon'] as IconData,
              color: isSelected ? color : AppColors.textSecondary,
              size: 24,
            ),
            title: Text(
              method['name'] as String,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? color : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check, color: color, size: 20)
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
          decoration: InputDecoration(
            labelText: 'Номер карты',
            border: OutlineInputBorder(
              borderRadius: AppStyles.borderRadiusMd,
              borderSide: BorderSide(color: AppColors.border),
            ),
            hintText: '0000 0000 0000 0000',
            filled: true,
            fillColor: AppColors.background,
          ),
          keyboardType: TextInputType.number,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardHolderController,
          decoration: InputDecoration(
            labelText: 'Имя владельца',
            border: OutlineInputBorder(
              borderRadius: AppStyles.borderRadiusMd,
              borderSide: BorderSide(color: AppColors.border),
            ),
            hintText: 'IVAN IVANOV',
            filled: true,
            fillColor: AppColors.background,
          ),
          textCapitalization: TextCapitalization.characters,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: InputDecoration(
                  labelText: 'Срок действия',
                  border: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  hintText: 'MM/YY',
                  filled: true,
                  fillColor: AppColors.background,
                ),
                keyboardType: TextInputType.datetime,
                style: AppTextStyles.bodyMedium,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  hintText: '123',
                  filled: true,
                  fillColor: AppColors.background,
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    final canPay = _amount > 0;

    return PrimaryButton(
      text: canPay ? 'Оплатить $_amount руб.' : 'Выберите сумму',
      onPressed: _processPayment,
      isEnabled: canPay,
      width: double.infinity,
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
        showErrorSnackBar(
          context,
          'Заполните все поля карты',
        );
        return;
      }
    }

    showConfirmDialog(
      context: context,
      title: 'Подтверждение оплаты',
      content: 'Сумма: $_amount руб.\n'
          'Способ: ${_getMethodName(_selectedMethod)}\n\n'
          'Подтвердить оплату?',
      confirmText: 'Оплатить',
      cancelText: 'Отмена',
      confirmColor: AppColors.primary,
    ).then((confirmed) {
      if (confirmed == true) {
        _showPaymentSuccess();
      }
    });
  }

  void _showPaymentSuccess() {
    showSuccessSnackBar(
      context,
      'Счет успешно пополнен на $_amount руб.!',
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