import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';
import 'training_date_time_dialog.dart';
import 'booking_confirmation_screen.dart';
import '../../models/booking_confirmation_models.dart';

class TrainerDetailScreen extends StatefulWidget {
  final Trainer trainer;

  const TrainerDetailScreen({super.key, required this.trainer});

  @override
  State<TrainerDetailScreen> createState() => _TrainerDetailScreenState();
}

class _TrainerDetailScreenState extends State<TrainerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final trainer = widget.trainer;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Профиль тренера',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final navigationService = NavigationService.of(context);
            if (navigationService != null) {
              navigationService.onBack();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка с основной информацией
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок и рейтинг
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: trainer.photoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    trainer.photoUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.textTertiary,
                                ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          trainer.fullName,
                          style: AppTextStyles.headline4.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          trainer.specialty,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: AppColors.warning, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              trainer.displayRating,
                              style: AppTextStyles.headline6.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${trainer.totalReviews} отзывов)',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // О тренере
                  Text(
                    'О тренере:',
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trainer.bio,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Сертификаты
                  if (trainer.certifications.isNotEmpty) ...[
                    Text(
                      'Сертификаты:',
                      style: AppTextStyles.headline6.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: trainer.certifications
                          .map((cert) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.verified, size: 16, color: AppColors.success),
                                    const SizedBox(width: 8),
                                    Text(
                                      cert,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Виды спорта
                  Text(
                    'Специализация:',
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: trainer.availableSports
                        .map((sport) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: AppStyles.borderRadiusLg,
                              ),
                              child: Text(
                                sport,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Стоимость занятий
                  Text(
                    'Стоимость занятий:',
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: trainer.hourlyRates.entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${entry.value.toInt()} ₽/час',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Статус доступности
                  Container(
                    padding: AppStyles.paddingMd,
                    decoration: BoxDecoration(
                      color: trainer.isAvailable
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: AppStyles.borderRadiusLg,
                      border: Border.all(
                        color: trainer.isAvailable
                            ? AppColors.success
                            : AppColors.error,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          trainer.isAvailable ? Icons.check_circle : Icons.cancel,
                          color: trainer.isAvailable ? AppColors.success : AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            trainer.isAvailable
                                ? 'Тренер доступен для записи'
                                : 'Тренер временно недоступен',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: trainer.isAvailable ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Кнопка записи
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final navigationService = NavigationService.of(context);
                        navigationService?.navigateTo('trainer_service_selection', widget.trainer);
                      },
                      style: AppStyles.primaryButtonStyle.copyWith(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      child: Text(
                        'Записаться на тренировку',
                        style: AppTextStyles.buttonMedium,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Запись к тренеру',
              style: AppTextStyles.headline5.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              widget.trainer.fullName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Выберите услугу:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            ...widget.trainer.hourlyRates.entries.map((entry) => _buildServiceOption(
              context,
              entry.key,
              entry.value,
            )),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceOption(BuildContext context, String serviceName, double price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppStyles.borderRadiusLg,
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          serviceName,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${price.toInt()} ₽/час',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textTertiary,
        ),
        onTap: () {
          Navigator.pop(context);
          _showDateTimeSelectionDialog(context, serviceName, price);
        },
      ),
    );
  }

  void _showDateTimeSelectionDialog(BuildContext context, String serviceName, double price) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => DateTimeSelectionDialog(
        trainer: widget.trainer,
        serviceName: serviceName,
        price: price,
        onDateTimeSelected: (date, time) {
          Navigator.pop(context);
          _showConfirmationScreen(context, serviceName, price, date, time);
        },
      ),
    );
  }

  void _showConfirmationScreen(BuildContext context, String serviceName, double price, DateTime date, TimeOfDay time) {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('booking_confirmation',
        BookingConfirmationConfig(
          type: ConfirmationBookingType.personalTraining,
          title: 'Персональная тренировка',
          serviceName: serviceName,
          price: price,
          date: date,
          time: time,
          trainer: widget.trainer,
        )
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(
            config: BookingConfirmationConfig(
              type: ConfirmationBookingType.personalTraining,
              title: 'Персональная тренировка',
              serviceName: serviceName,
              price: price,
              date: date,
              time: time,
              trainer: widget.trainer,
            ),
          ),
        ),
      );
    }
  }
}