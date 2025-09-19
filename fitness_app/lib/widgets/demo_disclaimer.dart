import 'package:flutter/material.dart';
import 'package:fitness_app/theme/app_colors.dart';
import 'package:fitness_app/theme/app_text_styles.dart';

class DemoDisclaimer extends StatelessWidget {
  const DemoDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.shadowLg,
      ),
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
          Text(
            'Данный демонстрационный стенд от Система.Поток показывает, '
            'как можно быстро и легко сконфигурировать платформу мобильного '
            'приложения под бизнес-процессы любого бизнеса.\n\n'
            'В данном случае это фитнес-центр с теннисными кортами, '
            'где реализованы все ключевые процессы: бронирование занятий, '
            'управление абонементами, работа с тренерами и клиентами.\n\n'
            'Некоторые функции могут быть временно недоступны или ограничены. '
            'Анимации и визуальные переходы intentionally упрощены, поскольку '
            'веб-браузер не позволяет в полной мере воспроизвести нативные '
            'жесты и взаимодействия, характерные для мобильных устройств.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
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
                    'Полная функциональность доступна в мобильном приложении',
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
                    'Все данные являются тестовыми и служат для демонстрации',
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
    );
  }
}