import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/booking_model.dart';

class TennisBookingScreen extends StatefulWidget {
  const TennisBookingScreen({super.key});

  @override
  State<TennisBookingScreen> createState() => _TennisBookingScreenState();
}

class _TennisBookingScreenState extends State<TennisBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TennisCourt? _selectedCourt;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  final List<TimeOfDay> _availableTimes = [
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 20, minute: 0),
  ];

  double get _totalPrice {
    if (_selectedCourt == null || _selectedStartTime == null || _selectedEndTime == null) {
      return 0;
    }
    
    final startHour = _selectedStartTime!.hour + _selectedStartTime!.minute / 60;
    final endHour = _selectedEndTime!.hour + _selectedEndTime!.minute / 60;
    final duration = endHour - startHour;
    
    return duration * _selectedCourt!.pricePerHour;
  }

  bool get _canBook => _selectedCourt != null && 
                      _selectedStartTime != null && 
                      _selectedEndTime != null;

  void _bookCourt() {
    if (!_canBook) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение бронирования'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Корт: ${_selectedCourt!.number}'),
            Text('Дата: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}'),
            Text('Время: ${_selectedStartTime!.format(context)} - ${_selectedEndTime!.format(context)}'),
            Text('Стоимость: $_totalPrice руб.'),
            const SizedBox(height: 16),
            const Text('Подтвердить бронирование?'),
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
              _showBookingSuccess();
            },
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );
  }

  void _showBookingSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Корт успешно забронирован!'),
        backgroundColor: Colors.green,
      ),
    );
    
    setState(() {
      _selectedCourt = null;
      _selectedStartTime = null;
      _selectedEndTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бронирование теннисных кортов'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Выбор даты
            _buildDateSelector(),
            const SizedBox(height: 24),
            
            // Список кортов
            const Text(
              'Доступные корты:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCourtsList(),
            
            // Выбор времени
            if (_selectedCourt != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Выберите время:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTimeSelector(),
            ],
            
            // Итоговая стоимость
            if (_canBook) ...[
              const SizedBox(height: 24),
              _buildTotalPrice(),
              const SizedBox(height: 16),
              _buildBookButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: [
        const Text(
          'Дата:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                  _selectedCourt = null;
                  _selectedStartTime = null;
                  _selectedEndTime = null;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourtsList() {
    return Column(
      children: MockDataService.tennisCourts.map((court) {
        final isSelected = court == _selectedCourt;
        final isAvailable = court.isAvailable;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.sports_tennis,
              color: isAvailable ? Colors.green : Colors.grey,
            ),
            title: Text(
              court.number,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isAvailable ? Colors.black : Colors.grey,
              ),
            ),
            subtitle: Text(
              '${court.surfaceType} • ${court.isIndoor ? 'Крытый' : 'Открытый'} • ${court.pricePerHour} руб/час',
              style: TextStyle(color: isAvailable ? Colors.grey : Colors.red),
            ),
            trailing: isAvailable
                ? const Icon(Icons.chevron_right)
                : const Text(
                    'Занят',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
            onTap: isAvailable
                ? () {
                    setState(() {
                      _selectedCourt = court;
                      _selectedStartTime = null;
                      _selectedEndTime = null;
                    });
                  }
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTimes.map((time) {
            final isSelected = time == _selectedStartTime;
            final isAfterSelected = _selectedStartTime != null && 
                                  time.hour > _selectedStartTime!.hour;
            
            return FilterChip(
              label: Text(time.format(context)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedStartTime = time;
                    _selectedEndTime = null;
                  } else {
                    _selectedStartTime = null;
                    _selectedEndTime = null;
                  }
                });
              },
              selectedColor: Colors.blue,
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        
        if (_selectedStartTime != null) ...[
          const SizedBox(height: 16),
          const Text(
            'Конечное время:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTimes.where((time) => 
                time.hour > _selectedStartTime!.hour).map((time) {
              final isSelected = time == _selectedEndTime;
              
              return FilterChip(
                label: Text(time.format(context)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedEndTime = selected ? time : null;
                  });
                },
                selectedColor: Colors.green,
                checkmarkColor: Colors.white,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildTotalPrice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Итоговая стоимость:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '$_totalPrice руб.',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _canBook ? _bookCourt : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Забронировать',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}