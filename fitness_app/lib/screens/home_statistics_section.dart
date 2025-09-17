import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';

class HomeStatisticsSection extends StatelessWidget {
  const HomeStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Статистика в виде карточек
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              '12',
              'Посещений',
              Icons.fitness_center,
              AppColors.primary,
            ),
            _buildStatCard(
              '8',
              'Теннис',
              Icons.sports_tennis,
              AppColors.secondary,
            ),
            _buildStatCard(
              '4',
              'Групповые',
              Icons.people,
              AppColors.accent,
            ),
            _buildStatCard(
              '16ч',
              'Тренировок',
              Icons.timer,
              AppColors.info,
            ),
          ],
        ),
        const SizedBox(height: 16),
        
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Иконка с фоном
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: AppStyles.borderRadiusFull,
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          
          // Значение
          Text(
            value,
            style: AppTextStyles.statValue.copyWith(
              color: color,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          
          // Подпись
          Text(
            label,
            style: AppTextStyles.statLabel.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}