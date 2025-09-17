import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/booking_model.dart';
import '../main.dart';

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
            const TabBar(
              tabs: [
                Tab(text: 'Доступные'),
                Tab(text: 'Мои шкафчики'),
              ],
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Доступные шкафчики:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          // Выбор количества дней
          const Text('Количество дней аренды:'),
          Slider(
            value: _rentalDays.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            label: _rentalDays.toString(),
            onChanged: (value) {
              setState(() {
                _rentalDays = value.toInt();
              });
            },
          ),
          Text('$_rentalDays дней • ${_calculatePrice()} руб.'),
          
          const SizedBox(height: 16),
          
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
      padding: const EdgeInsets.all(16),
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
    
    return Card(
      color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLocker = locker;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 40,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                locker.number,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Размер: ${locker.size}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '${locker.pricePerDay} руб./день',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (isSelected)
                ElevatedButton(
                  onPressed: () => _rentLocker(locker),
                  child: const Text('Арендовать'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserLockerCard(Locker locker) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locker.number,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Text(
                    'Активен',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Размер: ${locker.size}'),
            Text('Действует до: ${_formatDate(locker.rentalEndDate!)}'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _extendRental(locker),
                    child: const Text('Продлить'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openLocker(locker),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Открыть'),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_open,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'У вас нет арендованных шкафчиков',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Арендуйте шкафчик для удобного хранения вещей',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePrice() {
    if (_selectedLocker == null) return 0;
    return _selectedLocker!.pricePerDay * _rentalDays;
  }

  void _rentLocker(Locker locker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Аренда шкафчика'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Шкафчик: ${locker.number}'),
            Text('Размер: ${locker.size}'),
            Text('Период: $_rentalDays дней'),
            Text('Стоимость: ${_calculatePrice()} руб.'),
            const SizedBox(height: 16),
            const Text('Подтвердить аренду?'),
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
              _showRentalSuccess(locker);
            },
            child: const Text('Арендовать'),
          ),
        ],
      ),
    );
  }

  void _extendRental(Locker locker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Продление аренды'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Выберите количество дополнительных дней:'),
            Slider(
              value: _rentalDays.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: _rentalDays.toString(),
              onChanged: (value) {
                setState(() {
                  _rentalDays = value.toInt();
                });
              },
            ),
            Text('$_rentalDays дней • ${locker.pricePerDay * _rentalDays} руб.'),
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
              _showExtensionSuccess();
            },
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
        title: const Text('Открыть шкафчик'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_open, size: 48, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Шкафчик ${locker.number} открыт',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Не забудьте закрыть его после использования',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRentalSuccess(Locker locker) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Шкафчик ${locker.number} успешно арендован!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showExtensionSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Аренда успешно продлена!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}