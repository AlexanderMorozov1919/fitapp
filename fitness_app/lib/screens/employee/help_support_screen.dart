import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../main.dart';

/// Экран помощи и поддержки для сотрудников
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Помощь и поддержка'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQ раздел
            const SectionHeader(title: 'Часто задаваемые вопросы'),
            const SizedBox(height: 16),
            
            _buildFAQItem(
              context,
              'Как изменить расписание тренировок?',
              'Для изменения расписания перейдите в раздел "Мое расписание", выберите нужную тренировку и нажмите "Редактировать". Изменения автоматически синхронизируются с системой.',
            ),
            
            _buildFAQItem(
              context,
              'Как посмотреть статистику KPI?',
              'Статистика KPI доступна в одноименном разделе. Там вы найдете информацию о количестве проведенных занятий, средней оценке и других показателях эффективности.',
            ),
            
            _buildFAQItem(
              context,
              'Как связаться с технической поддержкой?',
              'Для связи с технической поддержкой используйте контакты ниже. Обычно ответ приходит в течение 1-2 рабочих дней.',
            ),
            
            const SizedBox(height: 32),
            
            // Контакты поддержки
            const SectionHeader(title: 'Контакты поддержки'),
            const SizedBox(height: 16),
            
            _buildContactItem(
              Icons.phone,
              'Телефон',
              '+7 (495) 123-45-67',
              onTap: () => _callSupport(),
            ),
            
            _buildContactItem(
              Icons.email,
              'Email',
              'support@fitnessclub.ru',
              onTap: () => _emailSupport(),
            ),
            
            _buildContactItem(
              Icons.chat,
              'Чат поддержки',
              'Онлайн консультация',
              onTap: () => _openChatSupport(context),
            ),
            
            const SizedBox(height: 32),
            
            // Документация
            const SectionHeader(title: 'Документация'),
            const SizedBox(height: 16),
            
            _buildDocumentationItem(
              'Руководство пользователя',
              'Полное руководство по работе с приложением',
              onTap: () => _openUserGuide(),
            ),
            
            _buildDocumentationItem(
              'Политика конфиденциальности',
              'Как мы защищаем ваши данные',
              onTap: () => _openPrivacyPolicy(),
            ),
            
            _buildDocumentationItem(
              'Условия использования',
              'Правила работы с приложением',
              onTap: () => _openTermsOfUse(),
            ),
            
            const SizedBox(height: 32),
            
            // Информация о версии
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppStyles.borderRadiusLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Информация о приложении',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Версия: 1.0.0',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Дата сборки: 19.09.2024',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textTertiary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDocumentationItem(String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: ListTile(
        leading: const Icon(
          Icons.description,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textTertiary,
        ),
        onTap: onTap,
      ),
    );
  }

  void _callSupport() {
    // Здесь будет логика звонка в поддержку
    print('Звонок в поддержку');
  }

  void _emailSupport() {
    // Здесь будет логика отправки email
    print('Отправка email в поддержку');
  }

  void _openChatSupport(BuildContext context) {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('employee_chat');
  }

  void _openUserGuide() {
    // Здесь будет открытие руководства пользователя
    print('Открытие руководства пользователя');
  }

  void _openPrivacyPolicy() {
    // Здесь будет открытие политики конфиденциальности
    print('Открытие политики конфиденциальности');
  }

  void _openTermsOfUse() {
    // Здесь будет открытие условий использования
    print('Открытие условий использования');
  }
}