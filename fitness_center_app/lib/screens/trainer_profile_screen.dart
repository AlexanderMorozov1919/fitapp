import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/widgets/app_container.dart';

class TrainerProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? trainer;

  const TrainerProfileScreen({super.key, this.trainer});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  final Map<String, dynamic> _defaultTrainer = {
    'id': '1',
    'name': 'Иван Петров',
    'specialization': 'Теннис, Фитнес',
    'rating': 4.9,
    'reviews': 124,
    'experience': '8 лет',
    'price': 2500,
    'description': 'Сертифицированный тренер по теннису с 8-летним опытом работы. Специализируется на индивидуальных тренировках для всех уровней подготовки - от начинающих до профессиональных спортсменов. Помогает улучшить технику, развить физическую форму и достичь спортивных целей.',
    'skills': ['Теннис', 'Фитнес', 'Реабилитация', 'Персональные тренировки'],
    'availability': ['Пн-Пт: 09:00-18:00', 'Сб: 10:00-16:00'],
    'certifications': [
      'Международный сертификат тренера по теннису (ITF)',
      'Сертификат по спортивной реабилитации',
      'Курс первой медицинской помощи'
    ],
    'education': 'Высшее спортивное образование, МГАФК',
    'languages': ['Русский', 'Английский'],
  };

  Map<String, dynamic> get _trainer {
    return widget.trainer ?? _defaultTrainer;
  }

  final List<Map<String, dynamic>> _reviews = [
    {
      'user': 'Анна К.',
      'rating': 5.0,
      'date': '2 недели назад',
      'comment': 'Отличный тренер! За несколько месяцев занятий значительно улучшила свою технику. Очень внимательный и профессиональный подход.',
    },
    {
      'user': 'Михаил С.',
      'rating': 4.8,
      'date': '1 месяц назад',
      'comment': 'Иван помог мне восстановиться после травмы. Индивидуальный подход и грамотная программа тренировок дали отличные результаты.',
    },
    {
      'user': 'Елена В.',
      'rating': 5.0,
      'date': '2 месяца назад',
      'comment': 'Занимаемся с сыном-подростком. Тренер нашел подход к ребенку, занятия проходят интересно и продуктивно. Рекомендую!',
    },
  ];

  void _bookTraining() {
    AppNavigator.pushNamed(
      AppRoutes.trainerBooking,
      arguments: _trainer,
    );
  }

  void _contactTrainer() {
    // Здесь будет логика связи с тренером
    // Связь с тренером ${_trainer['name']}
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        );
      }),
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
                  'Профиль тренера',
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
                  // Trainer header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _trainer['name']
                                  .toString()
                                  .split(' ')
                                  .map((n) => n[0])
                                  .join(''),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _trainer['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _trainer['specialization'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.gray,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRatingStars(_trainer['rating']),
                            const SizedBox(width: 8),
                            Text(
                              '${_trainer['rating']} (${_trainer['reviews']} отзывов)',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // About section
                  const Text(
                    'О тренере',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _trainer['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Details
                  _buildDetailSection('Навыки', _trainer['skills']),
                  _buildDetailSection('Доступность', _trainer['availability']),
                  _buildDetailSection('Образование', [_trainer['education']]),
                  _buildDetailSection('Сертификаты', _trainer['certifications']),
                  _buildDetailSection('Языки', _trainer['languages']),

                  const SizedBox(height: 20),

                  // Price and experience
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoCard('Опыт', _trainer['experience']),
                      _buildInfoCard('Стоимость', '${_trainer['price']} ₽/час'),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Reviews section
                  const Text(
                    'Отзывы',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final review in _reviews)
                    _buildReviewCard(review),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _contactTrainer,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(16),
                      side: const BorderSide(color: AppTheme.primary),
                    ),
                    child: const Text(
                      'Написать',
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _bookTraining,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(16),
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

  Widget _buildDetailSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(
                    item.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.light,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.gray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['user'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                review['date'],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRatingStars(review['rating']),
          const SizedBox(height: 8),
          Text(
            review['comment'],
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.gray,
            ),
          ),
        ],
      ),
    );
  }
}