import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../main.dart';

/// Экран помощи и поддержки для клиентов
class ClientHelpSupportScreen extends StatelessWidget {
  const ClientHelpSupportScreen({super.key});

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
              'Как забронировать занятие?',
              'Для бронирования перейдите в раздел "Расписание", выберите нужное занятие и нажмите "Забронировать". Подтвердите бронирование и произведите оплату.',
            ),
            
            _buildFAQItem(
              context,
              'Как отменить бронирование?',
              'В разделе "Мои бронирования" выберите нужное бронирование и нажмите "Отменить". Отмена возможна не позднее чем за 2 часа до начала занятия.',
            ),
            
            _buildFAQItem(
              context,
              'Как продлить абонемент?',
              'В разделе "Абонементы" выберите текущий абонемент и нажмите "Продлить". Оплатите продление удобным способом.',
            ),

            _buildFAQItem(
              context,
              'Как работает система лояльности?',
              'За каждое посещение вы получаете бонусные баллы. Накопленные баллы можно использовать для получения скидок или бесплатных занятий.',
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

            _buildContactItem(
              Icons.location_on,
              'Адрес клуба',
              'ул. Спортивная, 15',
              onTap: () => _openMap(),
            ),
            
            const SizedBox(height: 32),
            
            // Часы работы
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
                    'Часы работы клуба',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildWorkingHoursItem('Пн-Пт', '06:00 - 23:00'),
                  _buildWorkingHoursItem('Сб-Вс', '08:00 - 22:00'),
                  _buildWorkingHoursItem('Праздничные дни', '09:00 - 20:00'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Документация
            const SectionHeader(title: 'Документация'),
            const SizedBox(height: 16),
            
            _buildDocumentationItem(
              'Правила клуба',
              'Основные правила посещения фитнес-клуба',
              onTap: () => _openClubRules(),
            ),
            
            _buildDocumentationItem(
              'Политика конфиденциальности',
              'Как мы защищаем ваши данные',
              onTap: () => _openPrivacyPolicy(),
            ),
            
            _buildDocumentationItem(
              'Договор оказания услуг',
              'Условия предоставления услуг',
              onTap: () => _openTermsOfService(),
            ),

            _buildDocumentationItem(
              'Программа лояльности',
              'Условия накопления и использования баллов',
              onTap: () => _openLoyaltyProgram(),
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

  Widget _buildWorkingHoursItem(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            time,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
    navigationService?.navigateTo('chat');
  }

  void _openMap() {
    // Здесь будет открытие карты
    print('Открытие карты с адресом клуба');
  }

  void _openClubRules() {
    // Здесь будет открытие правил клуба
    print('Открытие правил клуба');
  }

  void _openPrivacyPolicy() {
    // Здесь будет открытие политики конфиденциальности
    print('Открытие политики конфиденциальности');
  }

  void _openTermsOfService() {
    // Здесь будет открытие условий обслуживания
    print('Открытие условий обслуживания');
  }

  void _openLoyaltyProgram() {
    // Здесь будет открытие программы лояльности
    print('Открытие программы лояльности');
  }
}