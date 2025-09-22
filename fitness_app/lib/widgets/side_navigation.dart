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
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppColors.shadowMd,
        border: Border(
          right: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с логотипом
          _buildHeader(),
          
          const Divider(height: 1, color: AppColors.border),
          
          // Основное меню
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildSectionTitle('Основное'),
                _buildMenuItem(
                  context,
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Главная',
                ),
                _buildMenuItem(
                  context,
                  index: 1,
                  icon: Icons.sports_tennis_outlined,
                  activeIcon: Icons.sports_tennis,
                  label: 'Теннис',
                ),
                _buildMenuItem(
                  context,
                  index: 2,
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today,
                  label: 'Расписание',
                ),
                _buildMenuItem(
                  context,
                  index: 3,
                  icon: Icons.book_online_outlined,
                  activeIcon: Icons.book_online,
                  label: 'Мои записи',
                ),
                _buildMenuItem(
                  context,
                  index: 4,
                  icon: Icons.fitness_center_outlined,
                  activeIcon: Icons.fitness_center,
                  label: 'Абонемент',
                ),
                _buildMenuItem(
                  context,
                  index: 5,
                  icon: Icons.lock_outlined,
                  activeIcon: Icons.lock,
                  label: 'Боксеры',
                ),
                _buildMenuItem(
                  context,
                  index: 6,
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  label: 'Магазин',
                ),
                
                const SizedBox(height: 8),
                _buildSectionTitle('Общение'),
                _buildMenuItem(
                  context,
                  index: 7,
                  icon: Icons.chat_outlined,
                  activeIcon: Icons.chat,
                  label: 'Чат',
                ),
                _buildMenuItem(
                  context,
                  index: 8,
                  icon: Icons.help_outline,
                  activeIcon: Icons.help,
                  label: 'Помощь',
                ),
                
                const SizedBox(height: 8),
                _buildSectionTitle('Аккаунт'),
                _buildMenuItem(
                  context,
                  index: 9,
                  icon: Icons.person_outlined,
                  activeIcon: Icons.person,
                  label: 'Профиль',
                ),
                _buildMenuItem(
                  context,
                  index: 10,
                  icon: Icons.people_outlined,
                  activeIcon: Icons.people,
                  label: 'Тренеры',
                ),
                
                const SizedBox(height: 8),
                _buildSectionTitle('Дополнительно'),
                _buildMenuItem(
                  context,
                  index: 11,
                  icon: Icons.credit_card_outlined,
                  activeIcon: Icons.credit_card,
                  label: 'Методы оплаты',
                ),
                _buildMenuItem(
                  context,
                  index: 12,
                  icon: Icons.security_outlined,
                  activeIcon: Icons.security,
                  label: 'Безопасность',
                ),
              ],
            ),
          ),
          
          // Нижняя часть с информацией
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Логотип
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 24,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Название
          Text(
            'Личный кабинет',
            style: AppTextStyles.headline5.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Подзаголовок
          Text(
            'Фитнес клуб Премиум',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
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
                  isSelected ? activeIcon : icon,
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
                
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Премиум клуб',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Москва, ул. Фитнесная, 123',
            style: AppTextStyles.overline.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}