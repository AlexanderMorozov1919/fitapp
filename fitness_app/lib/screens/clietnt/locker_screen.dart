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
        title: const Text('Управление шкафчиками'),
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
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
    return Padding(
      padding: AppStyles.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Доступные шкафчики:',
            style: AppTextStyles.headline5.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Выбор количества дней
          Text(
            'Количество дней аренды:',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
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
            '$_rentalDays дней • ${_calculatePrice()} руб.',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Список шкафчиков
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: availableLockers.length,
              itemBuilder: (context, index) {
                final locker = availableLockers[index];
                return _buildLockerCard(locker);
              },
            ),
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
          : ListView.builder(
              itemCount: userLockers.length,
              itemBuilder: (context, index) {
                final locker = userLockers[index];
                return _buildUserLockerCard(locker);
              },
            ),
    );
  }

  Widget _buildLockerCard(Locker locker) {
    final isSelected = locker == _selectedLocker;
    
    return AppCard(
      backgroundColor: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLocker = locker;
          });
        },
        child: Padding(
          padding: AppStyles.paddingMd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 40,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(height: 8),
              Text(
                locker.number,
                style: AppTextStyles.headline6.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
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
              const SizedBox(height: 8),
              if (isSelected)
                PrimaryButton(
                  text: 'Арендовать',
                  onPressed: () => _rentLocker(locker),
                  width: double.infinity,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserLockerCard(Locker locker) {
    return AppCard(
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
              style: AppTextStyles.bodyMedium,
            ),
            Text(
              'Действует до: ${_formatDate(locker.rentalEndDate!)}',
              style: AppTextStyles.bodyMedium,
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
    return EmptyState(
      icon: Icons.lock_open,
      title: 'У вас нет арендованных шкафчиков',
      subtitle: 'Арендуйте шкафчик для удобного хранения вещей',
      iconColor: AppColors.textTertiary,
    );
  }

  double _calculatePrice() {
    if (_selectedLocker == null) return 0;
    return _selectedLocker!.pricePerDay * _rentalDays;
  }

  void _rentLocker(Locker locker) {
    showConfirmDialog(
      context: context,
      title: 'Аренда шкафчика',
      content: 'Шкафчик: ${locker.number}\n'
          'Размер: ${locker.size}\n'
          'Период: $_rentalDays дней\n'
          'Стоимость: ${_calculatePrice()} руб.\n\n'
          'Подтвердить аренду?',
      confirmText: 'Арендовать',
      cancelText: 'Отмена',
      confirmColor: AppColors.primary,
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
              '$_rentalDays дней • ${locker.pricePerDay * _rentalDays} руб.',
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