import 'package:flutter/material.dart';
import 'package:fitness_app/theme/app_colors.dart';
import 'package:fitness_app/theme/app_text_styles.dart';

class DemoDisclaimer extends StatelessWidget {
  const DemoDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: double.infinity, // Растягиваем на всю высоту
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(right: 24, top: 40, bottom: 40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.shadowLg,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          // Заголовок с иконкой
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Демонстрационная версия',
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Разделитель
          Container(
            height: 1,
            color: AppColors.divider,
          ),
          
          const SizedBox(height: 16),
          
          // Основной текст
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Данный демонстрационный стенд от ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                TextSpan(
                  text: 'Система.Поток',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' показывает, как можно быстро и легко сконфигурировать платформу мобильного приложения под бизнес-процессы любого бизнеса.\n\n'
                        'В данном случае это фитнес-центр с теннисными кортами, где реализованы все ключевые процессы: ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                TextSpan(
                  text: 'бронирование занятий, управление абонементами, работа с тренерами и клиентами',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '.\n\n'
                        'В приложении реализована ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                TextSpan(
                  text: 'полноценная система оплаты',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ', а также ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                TextSpan(
                  text: 'умный магазин с персонализированными предложениями товаров',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ', которые подбираются под выбранные услуги и предпочтения пользователя.\n\n'
                        'Также доступен ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                TextSpan(
                  text: 'режим личного кабинета клиента',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ', который ',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                TextSpan(
                  text: 'доступен только через браузер компьютера',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' и предоставляет расширенный интерфейс для удобной работы.\n\n'
                        'Некоторые функции могут быть временно недоступны или ограничены. '
                        'Анимации и визуальные переходы intentionally упрощены, поскольку '
                        'веб-браузер не позволяет в полной мере воспроизвести нативные '
                        'жесты и взаимодействия, характерные для мобильных устройств.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Важное уведомление
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.info.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone_iphone_rounded,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Полная функциональность доступна в мобильном приложении. '
                    'Для максимально приближенного к смартфону опыта запустите приложение в браузере на мобильном устройстве.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Дополнительная информация
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.accent,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Все данные являются тестовыми и служат для демонстрации. '
                    'Приложение поддерживает все современные функции мобильных приложений.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}