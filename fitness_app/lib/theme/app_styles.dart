import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppStyles {
  // Скругления углов
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(4));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(12));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(16));
  static const BorderRadius borderRadius2xl = BorderRadius.all(Radius.circular(20));
  static const BorderRadius borderRadiusFull = BorderRadius.all(Radius.circular(999));

  // Отступы
  static const EdgeInsets paddingSm = EdgeInsets.all(8);
  static const EdgeInsets paddingMd = EdgeInsets.all(12);
  static const EdgeInsets paddingLg = EdgeInsets.all(16);
  static const EdgeInsets paddingXl = EdgeInsets.all(20);
  static const EdgeInsets padding2xl = EdgeInsets.all(24);

  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: 20);

  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: 20);

  // Стили карточек
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.card,
    borderRadius: borderRadiusLg,
    boxShadow: AppColors.shadowMd,
  );

  static BoxDecoration elevatedCardDecoration = BoxDecoration(
    color: AppColors.card,
    borderRadius: borderRadiusLg,
    boxShadow: AppColors.shadowLg,
  );

  static BoxDecoration primaryCardDecoration = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: borderRadiusLg,
    boxShadow: AppColors.shadowLg,
  );

  // Стили кнопок
  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(AppColors.primary),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    )),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: borderRadiusLg,
    )),
    elevation: MaterialStateProperty.all(0),
    textStyle: MaterialStateProperty.all(AppTextStyles.buttonMedium),
  );

  static ButtonStyle secondaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    foregroundColor: MaterialStateProperty.all(AppColors.primary),
    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    )),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: borderRadiusLg,
      side: BorderSide(color: AppColors.primary, width: 1),
    )),
    elevation: MaterialStateProperty.all(0),
    textStyle: MaterialStateProperty.all(AppTextStyles.buttonMedium),
  );

  static ButtonStyle textButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    foregroundColor: MaterialStateProperty.all(AppColors.primary),
    padding: MaterialStateProperty.all(paddingHorizontalMd),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: borderRadiusMd,
    )),
    elevation: MaterialStateProperty.all(0),
    textStyle: MaterialStateProperty.all(AppTextStyles.buttonMedium),
  );

  // Стили инпутов
  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: AppColors.background,
    border: OutlineInputBorder(
      borderRadius: borderRadiusLg,
      borderSide: BorderSide.none,
    ),
    contentPadding: paddingLg,
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textTertiary,
    ),
  );

  // Анимации
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  static const Curve animationCurve = Curves.easeInOut;

  // Стили чипов
  static BoxDecoration chipDecoration(bool selected) {
    return BoxDecoration(
      color: selected ? AppColors.primary : AppColors.background,
      borderRadius: borderRadiusFull,
      border: Border.all(
        color: selected ? AppColors.primary : AppColors.border,
        width: 1,
      ),
    );
  }

  // Стили баджей
  static BoxDecoration badgeDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: borderRadiusSm,
      border: Border.all(color: color.withOpacity(0.3), width: 1),
    );
  }

  // Стили прогресс баров
  static BoxDecoration progressBarDecoration = BoxDecoration(
    color: AppColors.border,
    borderRadius: borderRadiusFull,
  );

  static BoxDecoration progressBarFillDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadiusFull,
    );
  }
}