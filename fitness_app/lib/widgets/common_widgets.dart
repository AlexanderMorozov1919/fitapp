import 'package:flutter/material.dart';
import 'package:fitness_app/services/custom_notification_service.dart';
import 'package:fitness_app/models/notification_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../utils/formatters.dart';

/// Общие виджеты для единого дизайна приложения

/// Карточка с тенью и скруглением (стандартный стиль)
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.card,
        borderRadius: borderRadius ?? AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowMd,
      ),
      child: child,
    );
  }
}

/// Карточка с градиентным фоном
class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Gradient? gradient;

  const GradientCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppStyles.paddingLg,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowLg,
      ),
      child: child,
    );
  }
}

/// Заголовок секции с единым стилем
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.paddingLg,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.headline5.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

/// Кнопка с единым стилем
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: AppStyles.primaryButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppColors.textTertiary;
            }
            return AppColors.primary;
          }),
        ),
        child: Text(
          text,
          style: AppTextStyles.buttonMedium,
        ),
      ),
    );
  }
}

/// Вторичная кнопка с обводкой
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final Color? color;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: AppStyles.secondaryButtonStyle.copyWith(
          side: MaterialStateProperty.all(
            BorderSide(
              color: isEnabled ? (color ?? AppColors.primary) : AppColors.textTertiary,
            ),
          ),
          foregroundColor: MaterialStateProperty.all(
            isEnabled ? (color ?? AppColors.primary) : AppColors.textTertiary,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.buttonMedium.copyWith(
            color: isEnabled ? (color ?? AppColors.primary) : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

/// Чип для фильтров с единым стилем
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? (selectedColor ?? AppColors.primary) : AppColors.background,
            borderRadius: AppStyles.borderRadiusFull,
            border: Border.all(
              color: isSelected ? (selectedColor ?? AppColors.primary) : AppColors.border,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Элемент списка с иконкой и текстом
class ListItemWithIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;

  const ListItemWithIcon({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
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
          color: iconColor ?? AppColors.primary,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: onTap != null
            ? const Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

/// Статусный бейдж
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppStyles.borderRadiusSm,
      ),
      child: Text(
        text,
        style: AppTextStyles.overline.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Пустое состояние с иконкой и текстом
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppStyles.paddingLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor ?? AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.headline5.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Диалог подтверждения с единым стилем
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Подтвердить',
  String cancelText = 'Отмена',
  Color confirmColor = AppColors.primary,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.headline5,
      ),
      content: Text(
        content,
        style: AppTextStyles.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelText,
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: AppStyles.primaryButtonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(confirmColor),
          ),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

/// Красивый диалог подтверждения оплаты в стиле приложения
Future<bool?> showPaymentConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required double amount,
  required String paymentMethod,
  String confirmText = 'Оплатить',
  String cancelText = 'Отмена',
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppStyles.borderRadiusXl,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 200, // Ограничиваем ширину диалога
          maxHeight: 600, // Ограничиваем высоту диалога
        ),
        child: Padding(
          padding: AppStyles.paddingXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Заголовок
            Center(
              child: Text(
                title,
                style: AppTextStyles.headline4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Сумма оплаты
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: AppStyles.borderRadiusLg,
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сумма:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$amount руб.',
                    style: AppTextStyles.headline5.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Способ оплаты
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppStyles.borderRadiusLg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Способ:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    paymentMethod,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Дополнительная информация
            if (content.isNotEmpty)
              Text(
                content,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Кнопки
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: cancelText,
                    onPressed: () => Navigator.pop(context, false),
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: confirmText,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    )
  );
}

/// Успешное уведомление
void showSuccessSnackBar(BuildContext context, String message) {
  CustomNotificationService.showNotification(
    AppNotification(
      id: 'success_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Успешно',
      message: message,
      type: NotificationType.success,
      timestamp: DateTime.now(),
    ),
  );
}

/// Ошибка уведомления
void showErrorSnackBar(BuildContext context, String message) {
  CustomNotificationService.showNotification(
    AppNotification(
      id: 'error_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Ошибка',
      message: message,
      type: NotificationType.error,
      timestamp: DateTime.now(),
    ),
  );
}

/// Информационное уведомление
void showInfoSnackBar(BuildContext context, String message) {
  CustomNotificationService.showNotification(
    AppNotification(
      id: 'info_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Информация',
      message: message,
      type: NotificationType.info,
      timestamp: DateTime.now(),
    ),
  );
}

/// Виджет для отображения временного слота с индикацией занятости и выбора
class TimeSlotChip extends StatelessWidget {
  final TimeOfDay time;
  final bool isSelected;
  final bool isOccupied;
  final VoidCallback? onTap;
  final String? endTimeText;

  const TimeSlotChip({
    super.key,
    required this.time,
    required this.isSelected,
    required this.isOccupied,
    this.onTap,
    this.endTimeText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isOccupied
                  ? AppColors.background
                  : Colors.white,
          borderRadius: AppStyles.borderRadiusFull,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isOccupied
                    ? AppColors.border
                    : AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isOccupied ? null : AppColors.shadowSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(time),
              style: AppTextStyles.caption.copyWith(
                color: isSelected
                    ? Colors.white
                    : isOccupied
                        ? AppColors.textTertiary
                        : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (endTimeText != null) ...[
              const SizedBox(height: 2),
              Text(
                endTimeText!,
                style: AppTextStyles.overline.copyWith(
                  color: isSelected
                      ? Colors.white.withOpacity(0.8)
                      : AppColors.textTertiary,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final dateTime = DateTime(2024, 1, 1, time.hour, time.minute);
    return DateFormatters.formatTimeRussian(dateTime);
  }
}
