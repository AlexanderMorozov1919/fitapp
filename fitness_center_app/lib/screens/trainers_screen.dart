import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/widgets/app_container.dart';

class TrainersScreen extends StatefulWidget {
  const TrainersScreen({super.key});

  @override
  State<TrainersScreen> createState() => _TrainersScreenState();
}

class _TrainersScreenState extends State<TrainersScreen> {
  final List<Map<String, dynamic>> _trainers = [
    {
      'id': '1',
      'name': 'Иван Петров',
      'specialization': 'Теннис, Фитнес',
      'rating': 4.9,
      'reviews': 124,
      'experience': '8 лет',
      'price': 2500,
      'image': 'assets/trainers/trainer1.jpg',
      'description': 'Сертифицированный тренер по теннису. Специализируется на индивидуальных тренировках для всех уровней подготовки.',
      'skills': ['Теннис', 'Фитнес', 'Реабилитация'],
      'availability': ['Пн-Пт: 09:00-18:00', 'Сб: 10:00-16:00'],
    },
    {
      'id': '2',
      'name': 'Мария Сидорова',
      'specialization': 'Йога, Пилатес',
      'rating': 4.8,
      'reviews': 89,
      'experience': '6 лет',
      'price': 2000,
      'image': 'assets/trainers/trainer2.jpg',
      'description': 'Опытный инструктор по йоге и пилатесу. Помогает достичь гармонии тела и духа.',
      'skills': ['Йога', 'Пилатес', 'Стретчинг'],
      'availability': ['Вт-Чт: 10:00-19:00', 'Пт: 14:00-20:00'],
    },
    {
      'id': '3',
      'name': 'Алексей Козлов',
      'specialization': 'Бокс, MMA',
      'rating': 4.7,
      'reviews': 67,
      'experience': '10 лет',
      'price': 3000,
      'image': 'assets/trainers/trainer3.jpg',
      'description': 'Профессиональный тренер по боевым искусствам. Чемпион региона по MMA.',
      'skills': ['Бокс', 'MMA', 'Самозащита'],
      'availability': ['Пн-Ср-Пт: 08:00-17:00', 'Сб: 09:00-15:00'],
    },
    {
      'id': '4',
      'name': 'Елена Николаева',
      'specialization': 'Плавание',
      'rating': 4.9,
      'reviews': 102,
      'experience': '7 лет',
      'price': 2200,
      'image': 'assets/trainers/trainer4.jpg',
      'description': 'Инструктор по плаванию для взрослых и детей. Обучает правильной технике и безопасности на воде.',
      'skills': ['Плавание', 'Аквааэробика', 'Детское плавание'],
      'availability': ['Пн-Пт: 07:00-15:00', 'Сб-Вс: 09:00-14:00'],
    },
  ];

  String _searchQuery = '';
  String _selectedSpecialization = 'Все';

  final List<String> _specializations = [
    'Все',
    'Теннис',
    'Йога',
    'Боевые искусства',
    'Плавание',
    'Фитнес',
  ];

  List<Map<String, dynamic>> get _filteredTrainers {
    return _trainers.where((trainer) {
      final matchesSearch = trainer['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          trainer['specialization']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesSpecialization = _selectedSpecialization == 'Все' ||
          trainer['specialization']
              .toString()
              .toLowerCase()
              .contains(_selectedSpecialization.toLowerCase());

      return matchesSearch && matchesSpecialization;
    }).toList();
  }

  void _viewTrainerProfile(Map<String, dynamic> trainer) {
    AppNavigator.pushNamed(
      AppRoutes.trainerProfile,
      arguments: trainer,
    );
  }

  void _bookWithTrainer(Map<String, dynamic> trainer) {
    AppNavigator.pushNamed(
      AppRoutes.trainerBooking,
      arguments: trainer,
    );
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
                  'Тренеры',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Search and filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Поиск тренеров...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _specializations.map((spec) {
                      final isSelected = _selectedSpecialization == spec;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(spec),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSpecialization = spec;
                            });
                          },
                          selectedColor: AppTheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.dark,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Trainers list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredTrainers.length,
              itemBuilder: (context, index) {
                final trainer = _filteredTrainers[index];
                return _buildTrainerCard(trainer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(Map<String, dynamic> trainer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Trainer info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Trainer avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      trainer['name']
                          .toString()
                          .split(' ')
                          .map((n) => n[0])
                          .join(''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trainer['specialization'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.gray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${trainer['rating']} (${trainer['reviews']} отзывов)',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewTrainerProfile(trainer),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: AppTheme.primary),
                    ),
                    child: const Text(
                      'Профиль',
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _bookWithTrainer(trainer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Записаться'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}