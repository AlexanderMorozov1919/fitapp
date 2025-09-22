import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SideNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SideNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Личный кабинет',
              style: AppTextStyles.headline5.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const Divider(height: 1),
          
          // Пункты меню
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  index: 0,
                  icon: Icons.home,
                  label: 'Главная',
                ),
                _buildMenuItem(
                  context,
                  index: 1,
                  icon: Icons.calendar_today,
                  label: 'Расписание',
                ),
                _buildMenuItem(
                  context,
                  index: 2,
                  icon: Icons.book_online,
                  label: 'Мои записи',
                ),
                _buildMenuItem(
                  context,
                  index: 3,
                  icon: Icons.person,
                  label: 'Профиль',
                ),
                const Divider(height: 1),
                _buildMenuItem(
                  context,
                  index: 4,
                  icon: Icons.shopping_cart,
                  label: 'Магазин',
                ),
                _buildMenuItem(
                  context,
                  index: 5,
                  icon: Icons.lock,
                  label: 'Боксеры',
                ),
                _buildMenuItem(
                  context,
                  index: 6,
                  icon: Icons.help,
                  label: 'Помощь',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          border: isSelected
              ? Border(
                  left: BorderSide(
                    color: AppColors.primary,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}