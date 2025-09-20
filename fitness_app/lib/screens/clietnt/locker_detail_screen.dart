import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';

class LockerDetailScreen extends StatefulWidget {
  final Locker locker;
  final int rentalDays;

  const LockerDetailScreen({
    super.key,
    required this.locker,
    this.rentalDays = 1,
  });

  @override
  State<LockerDetailScreen> createState() => _LockerDetailScreenState();
}

class _LockerDetailScreenState extends State<LockerDetailScreen> {
  int _rentalDays = 1;

  @override
  void initState() {
    super.initState();
    _rentalDays = widget.rentalDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Шкафчик ${widget.locker.number}'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о шкафчике
            _buildLockerInfo(),
            
            const SizedBox(height: 24),
            
            // Выбор количества дней
            _buildRentalPeriodSelector(),
            
            const SizedBox(height: 24),
            
            // Итоговая стоимость
            _buildTotalPrice(),
            
            const SizedBox(height: 32),
            
            // Кнопка аренды
            PrimaryButton(
              text: 'Арендовать за ${_calculatePrice()} руб.',
              onPressed: _rentLocker,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockerInfo() {
    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.lock,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Шкафчик ${widget.locker.number}',
            style: AppTextStyles.headline5.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildInfoRow('Размер:', widget.locker.size),
          _buildInfoRow('Цена за день:', '${widget.locker.pricePerDay} руб.'),
          _buildInfoRow('Статус:', widget.locker.isAvailable ? 'Доступен' : 'Занят'),
          _buildInfoRow('Расположение:', 'Раздевалка, 1 этаж'),
          
          const SizedBox(height: 12),
          
          Text(
            'Удобный индивидуальный шкафчик для хранения личных вещей во время тренировок.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalPeriodSelector() {
    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Период аренды:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          Slider(
            value: _rentalDays.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            label: _rentalDays.toString(),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
            onChanged: (value) {
              setState(() {
                _rentalDays = value.toInt();
              });
            },
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_rentalDays ${_getDaysText(_rentalDays)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${widget.locker.pricePerDay * _rentalDays} руб.',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice() {
    final totalPrice = _calculatePrice();
    
    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Итоговая стоимость:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildPriceRow('Цена за день:', '${widget.locker.pricePerDay} руб.'),
          _buildPriceRow('Количество дней:', '$_rentalDays'),
          const Divider(height: 24),
          _buildPriceRow(
            'Итого:',
            '$totalPrice руб.',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _rentLocker() {
    showPaymentConfirmDialog(
      context: context,
      title: 'Аренда шкафчика',
      content: 'Шкафчик: ${widget.locker.number}\n'
          'Размер: ${widget.locker.size}\n'
          'Период: $_rentalDays ${_getDaysText(_rentalDays)}',
      amount: _calculatePrice(),
      paymentMethod: 'Банковская карта',
      confirmText: 'Арендовать',
      cancelText: 'Отмена',
    ).then((confirmed) {
      if (confirmed == true) {
        // Переходим на экран оплаты
        final navigationService = NavigationService.of(context);
        navigationService?.navigateTo('payment', {
          'booking': Booking(
            id: 'locker_${widget.locker.number}_${DateTime.now().millisecondsSinceEpoch}',
            userId: 'current_user_id', // TODO: Заменить на реальный ID пользователя
            type: BookingType.locker,
            startTime: DateTime.now(),
            endTime: DateTime.now().add(Duration(days: _rentalDays)),
            title: 'Аренда шкафчика ${widget.locker.number}',
            status: BookingStatus.awaitingPayment,
            price: _calculatePrice(),
            lockerNumber: widget.locker.number,
            createdAt: DateTime.now(),
          ),
          'amount': _calculatePrice(),
          'description': 'Аренда шкафчика ${widget.locker.number} на $_rentalDays ${_getDaysText(_rentalDays)}',
        });
      }
    });
  }

  double _calculatePrice() {
    return widget.locker.pricePerDay * _rentalDays;
  }

  String _getDaysText(int days) {
    if (days % 10 == 1 && days % 100 != 11) return 'день';
    if (days % 10 >= 2 && days % 10 <= 4 && (days % 100 < 10 || days % 100 >= 20)) {
      return 'дня';
    }
    return 'дней';
  }
}