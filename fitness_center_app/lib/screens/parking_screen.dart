import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/widgets/app_container.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  bool _hasActiveBooking = false;
  DateTime? _bookingStartTime;
  DateTime? _bookingEndTime;
  String _selectedZone = 'A';
  int _selectedSpot = 1;

  final List<String> _parkingZones = ['A', 'B', 'C'];
  final List<int> _availableSpots = List.generate(50, (index) => index + 1);

  void _bookParking() {
    setState(() {
      _hasActiveBooking = true;
      _bookingStartTime = DateTime.now();
      _bookingEndTime = DateTime.now().add(const Duration(hours: 2));
    });
  }

  void _extendParking() {
    setState(() {
      _bookingEndTime = _bookingEndTime?.add(const Duration(hours: 1));
    });
  }

  void _endParking() {
    setState(() {
      _hasActiveBooking = false;
      _bookingStartTime = null;
      _bookingEndTime = null;
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hoursч $minutesм';
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
                  'Парковка',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_hasActiveBooking && _bookingStartTime != null && _bookingEndTime != null)
                    _buildActiveBooking()
                  else
                    _buildBookingInterface(),

                  const SizedBox(height: 30),
                  _buildParkingMap(),

                  const SizedBox(height: 30),
                  _buildParkingRules(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBooking() {
    final now = DateTime.now();
    final remainingTime = _bookingEndTime!.difference(now);
    // final totalTime = _bookingEndTime!.difference(_bookingStartTime!);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.success.withAlpha(25),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.success, width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_parking,
            size: 50,
            color: AppTheme.success,
          ),
          const SizedBox(height: 15),
          const Text(
            'Парковка активна',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Место: $_selectedZone-$_selectedSpot',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            'До окончания: ${_formatDuration(remainingTime)}',
            style: TextStyle(
              fontSize: 16,
              color: remainingTime.inMinutes < 30 ? Colors.red : AppTheme.dark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _extendParking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Продлить +1ч'),
              ),
              ElevatedButton(
                onPressed: _endParking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Завершить'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingInterface() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Бронирование парковки',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Выберите зону и место для парковки',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.gray,
          ),
        ),
        const SizedBox(height: 20),

        // Zone selection
        const Text(
          'Зона парковки:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: _parkingZones.map((zone) {
            final isSelected = _selectedZone == zone;
            return ChoiceChip(
              label: Text('Зона $zone'),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedZone = zone;
                  _selectedSpot = 1;
                });
              },
              selectedColor: AppTheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.dark,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),
        const Text(
          'Номер места:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<int>(
          value: _selectedSpot,
          items: _availableSpots.map((spot) {
            return DropdownMenuItem(
              value: spot,
              child: Text('Место $spot'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSpot = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _bookParking,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'Забронировать парковку',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildParkingMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Карта парковки',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppTheme.light,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              // Simplified parking map
              for (int row = 0; row < 5; row++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int col = 0; col < 10; col++)
                      Container(
                        width: 25,
                        height: 40,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _isSpotAvailable(row * 10 + col + 1)
                              ? AppTheme.success.withAlpha(76)
                              : AppTheme.gray.withAlpha(76),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: _isSpotAvailable(row * 10 + col + 1)
                                ? AppTheme.success
                                : AppTheme.gray,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${row * 10 + col + 1}',
                            style: TextStyle(
                              fontSize: 10,
                              color: _isSpotAvailable(row * 10 + col + 1)
                                  ? AppTheme.success
                                  : AppTheme.gray,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Вход', style: TextStyle(fontSize: 12)),
                  Text('Выход', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _isSpotAvailable(int spot) {
    // Simulate some spots being occupied
    return spot % 3 != 0;
  }

  Widget _buildParkingRules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Правила парковки:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildRuleItem('• Бесплатная парковка для клиентов клуба'),
        _buildRuleItem('• Максимальное время парковки: 4 часа'),
        _buildRuleItem('• Бронирование действительно в течение 15 минут'),
        _buildRuleItem('• При необходимости продления используйте кнопку "Продлить"'),
        _buildRuleItem('• Не забудьте завершить парковку перед уходом'),
      ],
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.gray,
        ),
      ),
    );
  }
}