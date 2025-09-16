import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/trainer_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'Все';
  String _selectedLevel = 'Все';

  final List<String> _classTypes = ['Все', 'Йога', 'Кардио', 'Силовые', 'Теннис'];
  final List<String> _classLevels = ['Все', 'Начинающий', 'Средний', 'Продвинутый'];

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _filterClasses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание занятий'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Фильтры
          _buildFilters(),
          
          // Дата
          _buildDateSelector(),
          
          // Список занятий
          Expanded(
            child: filteredClasses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredClasses.length,
                    itemBuilder: (context, index) {
                      return _buildClassCard(filteredClasses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<GroupClass> _filterClasses() {
    return MockDataService.groupClasses.where((classItem) {
      final isDateMatch = classItem.startTime.year == _selectedDate.year &&
                         classItem.startTime.month == _selectedDate.month &&
                         classItem.startTime.day == _selectedDate.day;
      
      final isTypeMatch = _selectedType == 'Все' || classItem.type == _selectedType;
      final isLevelMatch = _selectedLevel == 'Все' || classItem.level == _selectedLevel;
      
      return isDateMatch && isTypeMatch && isLevelMatch;
    }).toList();
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Фильтр по типу
          Row(
            children: [
              const Text('Тип:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: _classTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Фильтр по уровню
          Row(
            children: [
              const Text('Уровень:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  items: _classLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          
          Text(
            _formatDate(_selectedDate),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(GroupClass classItem) {
    final isFull = classItem.isFull;
    final canBook = classItem.isAvailable && !isFull;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и время
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  classItem.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_formatTime(classItem.startTime)}-${_formatTime(classItem.endTime)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Информация о классе
            Text(
              '${classItem.type} • ${classItem.level} • ${classItem.trainerName}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              classItem.description,
              style: const TextStyle(fontSize: 14),
            ),
            
            const SizedBox(height: 12),
            
            // Детали
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  classItem.location,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const Spacer(),
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${classItem.currentParticipants}/${classItem.maxParticipants}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isFull ? Colors.red : Colors.grey[600],
                    fontWeight: isFull ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Цена и кнопка записи
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  classItem.price > 0 ? '${classItem.price} руб.' : 'Бесплатно',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                ElevatedButton(
                  onPressed: canBook ? () => _bookClass(classItem) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canBook ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    isFull ? 'Мест нет' : 'Записаться',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Занятий на выбранную дату нет',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте выбрать другую дату или изменить фильтры',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _bookClass(GroupClass classItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Запись на занятие'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Занятие: ${classItem.name}'),
            Text('Время: ${_formatTime(classItem.startTime)}-${_formatTime(classItem.endTime)}'),
            Text('Тренер: ${classItem.trainerName}'),
            if (classItem.price > 0) Text('Стоимость: ${classItem.price} руб.'),
            const SizedBox(height: 16),
            const Text('Подтвердить запись?'),
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
              _showBookingSuccess(classItem);
            },
            child: const Text('Записаться'),
          ),
        ],
      ),
    );
  }

  void _showBookingSuccess(GroupClass classItem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы записаны на "${classItem.name}"!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (date.year == today.year && 
        date.month == today.month && 
        date.day == today.day) {
      return 'Сегодня';
    } else if (date.year == tomorrow.year && 
               date.month == tomorrow.month && 
               date.day == tomorrow.day) {
      return 'Завтра';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}