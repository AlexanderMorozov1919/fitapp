import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/trainer_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';
import 'trainer_detail_screen.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Тренеры',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Фильтры - горизонтальный скролл (как в bookings_screen)
          Container(
            padding: AppStyles.paddingLg,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppColors.shadowSm,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _sports.map((sport) {
                  final isSelected = sport == _selectedSport;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChipWidget(
                      label: sport,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedSport = sport;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Список тренеров
          Expanded(
            child: filteredTrainers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: AppStyles.paddingLg,
                    itemCount: filteredTrainers.length,
                    itemBuilder: (context, index) {
                      final trainer = filteredTrainers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildTrainerCard(trainer),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(Trainer trainer) {
    return GestureDetector(
      onTap: () => _navigateToTrainerDetail(trainer),
      child: Container(
        padding: AppStyles.paddingLg,
        decoration: AppStyles.elevatedCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статус
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    trainer.fullName,
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trainer.isAvailable
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: AppStyles.borderRadiusSm,
                  ),
                  child: Text(
                    trainer.isAvailable ? 'Доступен' : 'Занят',
                    style: AppTextStyles.overline.copyWith(
                      color: trainer.isAvailable ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Основная информация о тренере
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Аватар тренера
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.background,
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
                          color: AppColors.textTertiary,
                        ),
                ),
                const SizedBox(width: 16),
                
                // Детали тренера
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.specialty,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Рейтинг и отзывы
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            trainer.displayRating,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${trainer.totalReviews} отзывов)',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Виды спорта
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: trainer.availableSports
                            .take(3)
                            .map((sport) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: AppStyles.borderRadiusSm,
                                  ),
                                  child: Text(
                                    sport,
                                    style: AppTextStyles.overline.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Разделитель
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            
            // Стоимость занятий
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Стоимость:',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'от ${trainer.hourlyRates.values.reduce((a, b) => a < b ? a : b).toInt()} ₽/час',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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
    return EmptyState(
      icon: Icons.person_search,
      title: 'Тренеры не найдены',
      subtitle: 'Попробуйте изменить фильтр или зайти позже',
    );
  }

  void _navigateToTrainerDetail(Trainer trainer) {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('trainer_detail', trainer);
    } else {
      // Альтернативная навигация для случаев, когда NavigationService недоступен
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrainerDetailScreen(trainer: trainer),
        ),
      );
    }
  }
}
