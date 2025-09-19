import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';

class LockerScreen extends StatefulWidget {
  const LockerScreen({super.key});

  @override
  State<LockerScreen> createState() => _LockerScreenState();
}

class _LockerScreenState extends State<LockerScreen> {
  Locker? _selectedLocker;
  int _rentalDays = 1;

  @override
  Widget build(BuildContext context) {
    final availableLockers = MockDataService.lockers
        .where((locker) => locker.isAvailable)
        .toList();

    final userLockers = MockDataService.currentUser.lockers
        .where((locker) => locker.isRented)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Шкафчики'),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Заголовок с табами
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.buttonMedium,
                unselectedLabelStyle: AppTextStyles.buttonMedium,
                tabs: const [
                  Tab(text: 'Доступные'),
                  Tab(text: 'Мои шкафчики'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Доступные шкафчики
                  _buildAvailableLockers(availableLockers),
                  
                  // Мои шкафчики
                  _buildMyLockers(userLockers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableLockers(List<Locker> availableLockers) {
    return SingleChildScrollView(
      padding: AppStyles.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Доступные шкафчики',
            style: AppTextStyles.headline5.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Выбор количества дней
          Container(
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
                  'Количество дней аренды:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
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
                      '${_calculatePrice()} руб.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Список шкафчиков
          Text(
            'Выберите шкафчик:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: availableLockers.length,
            itemBuilder: (context, index) {
              final locker = availableLockers[index];
              return _buildLockerCard(locker);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMyLockers(List<Locker> userLockers) {
    return Padding(
      padding: AppStyles.paddingLg,
      child: userLockers.isEmpty
          ? _buildEmptyLockersState()
          : ListView(
              children: [
                Text(
                  'Мои арендованные шкафчики',
                  style: AppTextStyles.headline5.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...userLockers.map((locker) => _buildUserLockerCard(locker)),
              ],
            ),
    );
  }

  Widget _buildLockerCard(Locker locker) {
    final isSelected = locker == _selectedLocker;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: InkWell(
        onTap: () {
          // Переходим на детальный экран шкафчика
          final navigationService = NavigationService.of(context);
          navigationService?.navigateTo('locker_detail', {
            'locker': locker,
            'rentalDays': _rentalDays,
          });
        },
        borderRadius: AppStyles.borderRadiusLg,
        child: Padding(
          padding: AppStyles.paddingLg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 40,
                color: AppColors.primary,
              ),
              const SizedBox(height: 8),
              Text(
                locker.number,
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Размер: ${locker.size}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${locker.pricePerDay} руб./день',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserLockerCard(Locker locker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Padding(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locker.number,
                  style: AppTextStyles.headline6.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                StatusBadge(
                  text: 'Активен',
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Размер: ${locker.size}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Действует до: ${_formatDate(locker.rentalEndDate!)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Продлить',
                    onPressed: () => _extendRental(locker),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(
                    text: 'Открыть',
                    onPressed: () => _openLocker(locker),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLockersState() {
    return Center(
      child: EmptyState(
        icon: Icons.lock_open,
        title: 'У вас нет арендованных шкафчиков',
        subtitle: 'Арендуйте шкафчик для удобного хранения вещей',
        iconColor: AppColors.textTertiary,
      ),
    );
  }

  String _getDaysText(int days) {
    if (days % 10 == 1 && days % 100 != 11) return 'день';
    if (days % 10 >= 2 && days % 10 <= 4 && (days % 100 < 10 || days % 100 >= 20)) {
      return 'дня';
    }
    return 'дней';
  }

  double _calculatePrice() {
    if (_selectedLocker == null) return 0;
    return _selectedLocker!.pricePerDay * _rentalDays;
  }

  void _rentLocker(Locker locker) {
    showPaymentConfirmDialog(
      context: context,
      title: 'Аренда шкафчика',
      content: 'Шкафчик: ${locker.number}\n'
          'Размер: ${locker.size}\n'
          'Период: $_rentalDays ${_getDaysText(_rentalDays)}',
      amount: _calculatePrice(),
      paymentMethod: 'Банковская карта',
      confirmText: 'Арендовать',
      cancelText: 'Отмена',
    ).then((confirmed) {
      if (confirmed == true) {
        _showRentalSuccess(locker);
      }
    });
  }

  void _extendRental(Locker locker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Продление аренды',
          style: AppTextStyles.headline5,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Выберите количество дополнительных дней:',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
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
            Text(
              '$_rentalDays ${_getDaysText(_rentalDays)} • ${locker.pricePerDay * _rentalDays} руб.',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showExtensionSuccess();
            },
            style: AppStyles.primaryButtonStyle,
            child: const Text('Продлить'),
          ),
        ],
      ),
    );
  }

  void _openLocker(Locker locker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Открыть шкафчик',
          style: AppTextStyles.headline5,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_open,
              size: 48,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            Text(
              'Шкафчик ${locker.number} открыт',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Не забудьте закрыть его после использования',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRentalSuccess(Locker locker) {
    showSuccessSnackBar(
      context,
      'Шкафчик ${locker.number} успешно арендован!',
    );
  }

  void _showExtensionSuccess() {
    showSuccessSnackBar(
      context,
      'Аренда успешно продлена!',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}