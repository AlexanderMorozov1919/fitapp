import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/trainer_model.dart';

class TrainersScreen extends StatefulWidget {
  const TrainersScreen({super.key});

  @override
  State<TrainersScreen> createState() => _TrainersScreenState();
}

class _TrainersScreenState extends State<TrainersScreen> {
  String _selectedSport = 'Все';
  final List<String> _sports = ['Все', 'Теннис', 'Силовые', 'Йога', 'Кардио'];

  @override
  Widget build(BuildContext context) {
    final filteredTrainers = _selectedSport == 'Все'
        ? MockDataService.trainers
        : MockDataService.trainers
            .where((trainer) => trainer.availableSports.contains(_selectedSport.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Тренеры'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Фильтр по видам спорта
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _sports.map((sport) {
                  final isSelected = sport == _selectedSport;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(sport),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSport = sport;
                        });
                      },
                      selectedColor: Colors.blue,
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Список тренеров
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTrainers.length,
              itemBuilder: (context, index) {
                final trainer = filteredTrainers[index];
                return _buildTrainerCard(trainer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(Trainer trainer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrainerDetailScreen(trainer: trainer),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар тренера
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: trainer.photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          trainer.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey[600],
                      ),
              ),
              const SizedBox(width: 16),

              // Информация о тренере
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trainer.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trainer.specialty,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Рейтинг
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trainer.displayRating,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${trainer.totalReviews} отзывов)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: trainer.availableSports
                          .take(3)
                          .map((sport) => Chip(
                                label: Text(
                                  sport,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),

              // Статус доступности
              Column(
                children: [
                  Icon(
                    trainer.isAvailable ? Icons.circle : Icons.circle_outlined,
                    color: trainer.isAvailable ? Colors.green : Colors.grey,
                    size: 12,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trainer.isAvailable ? 'Доступен' : 'Занят',
                    style: TextStyle(
                      fontSize: 10,
                      color: trainer.isAvailable ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainerDetailScreen extends StatelessWidget {
  final Trainer trainer;

  const TrainerDetailScreen({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trainer.fullName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и рейтинг
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: trainer.photoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              trainer.photoUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[600],
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    trainer.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trainer.specialty,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        trainer.displayRating,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${trainer.totalReviews} отзывов)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // О тренере
            const Text(
              'О тренере:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              trainer.bio,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 24),

            // Сертификаты
            if (trainer.certifications.isNotEmpty) ...[
              const Text(
                'Сертификаты:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: trainer.certifications
                    .map((cert) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.verified, size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(cert),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],

            const SizedBox(height: 24),

            // Виды спорта
            const Text(
              'Специализация:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: trainer.availableSports
                  .map((sport) => Chip(
                        label: Text(sport),
                        backgroundColor: Colors.blue.withOpacity(0.1),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 24),

            // Стоимость занятий
            const Text(
              'Стоимость занятий:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: trainer.hourlyRates.entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${entry.value} руб./час',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 32),

            // Кнопка записи
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showBookingDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Записаться на тренировку',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Запись к тренеру'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Тренер: ${trainer.fullName}'),
            const SizedBox(height: 16),
            const Text('Выберите тип тренировки:'),
            const SizedBox(height: 8),
            ...trainer.hourlyRates.entries.map((entry) => ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value} руб./час'),
                  onTap: () {
                    Navigator.pop(context);
                    _showTimeSelectionDialog(context, entry.key, entry.value);
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showTimeSelectionDialog(
      BuildContext context, String trainingType, double price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите дату и время'),
        content: const Text('Функционал выбора времени будет реализован позже'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Запись к ${trainer.fullName} оформлена!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Записаться'),
          ),
        ],
      ),
    );
  }
}