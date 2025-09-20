
import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../services/notification_service.dart';
import '../../models/payment_model.dart';
import '../../models/user_model.dart';
import '../../models/booking_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const PaymentScreen({super.key, this.bookingData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late double _amount;
  PaymentMethod _selectedMethod = PaymentMethod.bankCard;
  BankCard? _selectedCard;
  bool _useNewCard = false;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'method': PaymentMethod.bankCard,
      'name': 'Банковская карта',
      'icon': Icons.credit_card,
      'color': AppColors.primary,
    },
    {
      'method': PaymentMethod.balance,
      'name': 'Баланс счета',
      'icon': Icons.account_balance_wallet,
      'color': AppColors.success,
    },
    {
      'method': PaymentMethod.sbp,
      'name': 'СБП',
      'icon': Icons.qr_code,
      'color': AppColors.info,
    },
    {
      'method': PaymentMethod.sberPay,
      'name': 'СберПэй',
      'icon': Icons.phone_iphone,
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
      'color': AppColors.warning,
    },
  ];

  @override
  void initState() {
    super.initState();
    _amount = widget.bookingData?['amount'] ?? 0;
    final user = MockDataService.currentUser;
    if (user.bankCards.isNotEmpty) {
      _selectedCard = user.bankCards.firstWhere(
        (card) => card.isDefault,
        orElse: () => user.bankCards.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookingData != null ? 'Оплата бронирования' : 'Пополнение счета'),
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

            // Сумма оплаты
            Text(
              widget.bookingData != null ? 'Сумма к оплате:' : 'Сумма пополнения:',
              style: AppTextStyles.headline5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.bookingData != null)
              _buildFixedAmount()
            else
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

            // Выбор привязанной карты (только для банковской карты)
            if (_selectedMethod == PaymentMethod.bankCard && user.bankCards.isNotEmpty)
              _buildCardSelection(),

            // Форма новой карты (только для банковской карты)
            if (_selectedMethod == PaymentMethod.bankCard && _useNewCard)
              _buildCardForm(),

            // Информация о выбранном методе оплаты
            if (_selectedMethod != PaymentMethod.bankCard)
              _buildPaymentMethodInfo(),

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

  Widget _buildFixedAmount() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: AppStyles.borderRadiusLg,
        border: Border.all(color: AppColors.primary),
      ),
      child: Center(
        child: Text(
          '${_amount.toStringAsFixed(0)} руб.',
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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

  Widget _buildCardSelection() {
    final user = MockDataService.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите карту:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...user.bankCards.map((card) {
          final isSelected = _selectedCard?.id == card.id;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
              borderRadius: AppStyles.borderRadiusLg,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: AppStyles.paddingMd,
              leading: _buildCardIcon(card.type),
              title: Text(
                card.maskedNumber,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${card.holderName} • ${card.formattedExpiry}',
                style: AppTextStyles.caption,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (card.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'По умолчанию',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (isSelected)
                    Icon(Icons.check, color: AppColors.primary, size: 20),
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedCard = card;
                  _useNewCard = false;
                });
              },
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _useNewCard = true;
              _selectedCard = null;
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: AppStyles.borderRadiusLg,
            ),
          ),
          child: const Text('Добавить новую карту'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCardIcon(CardType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case CardType.visa:
        icon = Icons.credit_card;
        color = Colors.blue;
        break;
      case CardType.mastercard:
        icon = Icons.credit_card;
        color = Colors.red;
        break;
      case CardType.mir:
        icon = Icons.credit_card;
        color = Colors.orange;
        break;
      case CardType.unionpay:
        icon = Icons.credit_card;
        color = Colors.green;
        break;
      case CardType.unknown:
        icon = Icons.credit_card;
        color = Colors.grey;
        break;
    }

    return Icon(icon, color: color, size: 28);
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Данные новой карты:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Сохранить карту для будущих платежей',
                style: AppTextStyles.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPaymentMethodInfo() {
    String infoText;
    IconData icon;
    Color color;

    switch (_selectedMethod) {
      case PaymentMethod.balance:
        infoText = 'Сумма будет списана с вашего баланса. Баланс: ${MockDataService.currentUser.balance} руб.';
        icon = Icons.account_balance_wallet;
        color = AppColors.success;
        break;
      case PaymentMethod.sbp:
        infoText = 'Оплата через Систему быстрых платежей. Вам будет показан QR-код для сканирования.';
        icon = Icons.qr_code;
        color = AppColors.info;
        break;
      case PaymentMethod.sberPay:
        infoText = 'Оплата через СберПэй. Потребуется подтверждение в приложении СберБанка.';
        icon = Icons.phone_iphone;
        color = AppColors.secondary;
        break;
      case PaymentMethod.applePay:
        infoText = 'Оплата через Apple Pay. Подтвердите платеж с помощью Face ID или Touch ID.';
        icon = Icons.phone_iphone;
        color = AppColors.textPrimary;
        break;
      case PaymentMethod.googlePay:
        infoText = 'Оплата через Google Pay. Подтвердите платеж в приложении Google Pay.';
        icon = Icons.phone_android;
        color = AppColors.warning;
        break;
      default:
        infoText = '';
        icon = Icons.info;
        color = AppColors.info;
    }

    return Container(
      padding: AppStyles.paddingMd,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppStyles.borderRadiusLg,
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              infoText,
              style: AppTextStyles.bodySmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    final canPay = _amount > 0;
    final user = MockDataService.currentUser;

    // Проверка достаточности баланса для оплаты через баланс
    if (_selectedMethod == PaymentMethod.balance && user.balance < _amount) {
      return Column(
        children: [
          Text(
            'Недостаточно средств на балансе',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Пополнить баланс',
            onPressed: () {
              setState(() {
                _selectedMethod = PaymentMethod.bankCard;
              });
            },
            width: double.infinity,
          ),
        ],
      );
    }

    String buttonText;
    switch (_selectedMethod) {
      case PaymentMethod.bankCard:
        buttonText = 'Оплатить картой';
        break;
      case PaymentMethod.balance:
        buttonText = 'Оплатить с баланса';
        break;
      case PaymentMethod.sbp:
        buttonText = 'Оплатить через СБП';
        break;
      case PaymentMethod.sberPay:
        buttonText = 'Оплатить через СберПэй';
        break;
      case PaymentMethod.applePay:
        buttonText = 'Оплатить через Apple Pay';
        break;
      case PaymentMethod.googlePay:
        buttonText = 'Оплатить через Google Pay';
        break;
    }

    return PrimaryButton(
      text: canPay ? '$buttonText $_amount руб.' : 'Выберите сумму',
      onPressed: canPay ? _processPayment : () {},
      isEnabled: canPay,
      width: double.infinity,
    );
  }

  void _processPayment() {
    if (_selectedMethod == PaymentMethod.bankCard && _useNewCard) {
      // Валидация данных новой карты
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

    final description = widget.bookingData?['description'] ?? 'Пополнение счета';
    final paymentMethodName = _getMethodName(_selectedMethod);
    
    showPaymentConfirmDialog(
      context: context,
      title: 'Подтверждение оплаты',
      content: widget.bookingData != null ? 'Назначение: $description' : '',
      amount: _amount,
      paymentMethod: paymentMethodName,
    ).then((confirmed) {
      if (confirmed == true) {
        _showPaymentProcessing();
      }
    });
  }

  void _showPaymentProcessing() {
    // Показываем экран обработки платежа с задержкой для имитации процесса
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );

    // Имитация обработки платежа
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Закрываем индикатор загрузки
      _processPaymentCompletion();
    });
  }

  void _processPaymentCompletion() {
    final paymentMethodName = _getMethodName(_selectedMethod);
    String? description;

    if (widget.bookingData != null && widget.bookingData!['membership'] != null) {
      // Обработка покупки абонемента
      final membershipType = widget.bookingData!['membership'] as MembershipType;
      description = 'Абонемент: ${membershipType.name}';
      _processMembershipPurchase(membershipType);
    } else if (widget.bookingData != null && widget.bookingData!['booking'] != null) {
      // Обработка оплаты бронирования
      final booking = widget.bookingData!['booking'] as Booking;
      description = 'Бронирование: ${booking.className}';
      
      // Обновляем статус бронирования на "подтверждено"
      if (booking.status == BookingStatus.awaitingPayment) {
        MockDataService.confirmBookingPayment(booking.id);
      }
    } else {
      // Обработка пополнения счета
      description = 'Пополнение баланса';
      _processBalanceTopUp();
    }

    // Переход на экран успеха через навигацию приложения
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('payment_success', {
        'amount': _amount,
        'paymentMethod': paymentMethodName,
        'description': description,
      });
    } else {
      // Fallback навигация
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            amount: _amount,
            paymentMethod: paymentMethodName,
            description: description,
          ),
        ),
      );
    }
  }

  void _processMembershipPurchase(MembershipType membershipType) {
    // Создаем новый абонемент
    final newMembership = Membership(
      id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
      type: membershipType.name,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: membershipType.durationDays)),
      remainingVisits: membershipType.maxVisits == 0 ? -1 : membershipType.maxVisits,
      price: membershipType.price,
      includedServices: _getIncludedServicesFromType(membershipType),
      autoRenew: false,
    );

    // Обновляем данные пользователя
    MockDataService.updateUserMembership(newMembership);
  }

  void _processBalanceTopUp() {
    // TODO: Реализовать пополнение баланса
    // Пока просто имитируем успешное пополнение
  }


  List<String> _getIncludedServicesFromType(MembershipType membershipType) {
    final services = <String>[];
    if (membershipType.includesGym) services.add('тренажерный зал');
    if (membershipType.includesGroupClasses) services.add('групповые занятия');
    if (membershipType.includesTennis) services.add('теннис');
    return services;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _getMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.bankCard:
        return 'Банковская карта';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
      case PaymentMethod.balance:
        return 'Баланс счета';
      case PaymentMethod.sberPay:
        return 'СберПэй';
      case PaymentMethod.sbp:
        return 'СБП';
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