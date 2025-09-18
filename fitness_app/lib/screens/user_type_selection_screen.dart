import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';

enum UserType {
  client,
  employee,
}

class UserTypeSelectionScreen extends StatefulWidget {
  final Function(UserType) onUserTypeSelected;

  const UserTypeSelectionScreen({super.key, required this.onUserTypeSelected});

  @override
  State<UserTypeSelectionScreen> createState() => _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            
            // Логотип или иконка приложения
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 40,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Заголовок
            Text(
              'Добро пожаловать!',
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Подзаголовок
            Text(
              'Выберите тип пользователя для входа',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Карточка клиента
            _buildUserTypeCard(
              title: 'Клиент',
              subtitle: 'Полный доступ к бронированию услуг, просмотру расписания и управлению абонементом',
              icon: Icons.person,
              color: AppColors.primary,
              onTap: () => widget.onUserTypeSelected(UserType.client),
            ),
            
            const SizedBox(height: 16),
            
            // Карточка сотрудника
            _buildUserTypeCard(
              title: 'Сотрудник',
              subtitle: 'Доступ к служебным функции и управлению системой',
              icon: Icons.work,
              color: AppColors.success,
              onTap: () => widget.onUserTypeSelected(UserType.employee),
            ),
            
            const SizedBox(height: 32),
            
            // Информационный текст
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Выбор типа пользователя поможет нам предоставить вам наиболее подходящий интерфейс и функционал',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Иконка
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Текст
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headline6.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Стрелка
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}