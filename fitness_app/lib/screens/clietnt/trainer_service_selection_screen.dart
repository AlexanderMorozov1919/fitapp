import 'package:flutter/material.dart';
import '../../models/trainer_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';

class TrainerServiceSelectionScreen extends StatefulWidget {
  final Trainer trainer;

  const TrainerServiceSelectionScreen({super.key, required this.trainer});

  @override
  State<TrainerServiceSelectionScreen> createState() => _TrainerServiceSelectionScreenState();
}

class _TrainerServiceSelectionScreenState extends State<TrainerServiceSelectionScreen> {
  String? _selectedService;

  @override
  Widget build(BuildContext context) {
    final trainer = widget.trainer;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Выбор услуги',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final navigationService = NavigationService.of(context);
            navigationService?.onBack();
          },
        ),
      ),
      body: Padding(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о тренере
            Container(
              padding: AppStyles.paddingLg,
              decoration: AppStyles.elevatedCardDecoration,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: trainer.photoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              trainer.photoUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 24,
                            color: AppColors.textTertiary,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainer.fullName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          trainer.specialty,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Выберите услугу для бронирования:',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView(
                children: trainer.hourlyRates.entries.map((entry) {
                  final serviceName = entry.key;
                  final price = entry.value;
                  final isSelected = serviceName == _selectedService;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: AppStyles.elevatedCardDecoration.copyWith(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.sports,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      title: Text(
                        serviceName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${price.toInt()} ₽/час',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: AppColors.textTertiary,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedService = serviceName;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            
            if (_selectedService != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Выбрать время',
                  onPressed: () {
                    final navigationService = NavigationService.of(context);
                    navigationService?.navigateTo('trainer_time_selection', {
                      'trainer': widget.trainer,
                      'serviceName': _selectedService,
                      'price': widget.trainer.hourlyRates[_selectedService],
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}