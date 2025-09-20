import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';

class TennisSelectionScreen extends StatefulWidget {
  const TennisSelectionScreen({super.key});

  @override
  State<TennisSelectionScreen> createState() => _TennisSelectionScreenState();
}

class _TennisSelectionScreenState extends State<TennisSelectionScreen> {
  TennisCourt? _selectedCourt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Выбор теннисного корта',
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
            Text(
              'Выберите корт для бронирования:',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView(
                children: MockDataService.tennisCourts.map((court) {
                  final isSelected = court == _selectedCourt;
                  final isAvailable = court.isAvailable;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: AppStyles.elevatedCardDecoration.copyWith(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.sports_tennis,
                        color: isAvailable ? AppColors.success : AppColors.textTertiary,
                        size: 24,
                      ),
                      title: Text(
                        court.number,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isAvailable ? AppColors.textPrimary : AppColors.textTertiary,
                        ),
                      ),
                      subtitle: Text(
                        '${court.surfaceType} • ${court.isIndoor ? 'Крытый' : 'Открытый'} • от ${court.basePricePerHour.toInt()} ₽/час',
                        style: AppTextStyles.caption.copyWith(
                          color: isAvailable ? AppColors.textSecondary : AppColors.error,
                        ),
                      ),
                      trailing: isAvailable
                          ? Icon(
                              Icons.chevron_right,
                              color: AppColors.textTertiary,
                            )
                          : Text(
                              'Занят',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                _selectedCourt = court;
                              });
                            }
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            
            if (_selectedCourt != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Выбрать время',
                  onPressed: () {
                    final navigationService = NavigationService.of(context);
                    navigationService?.navigateTo('tennis_time_selection', _selectedCourt);
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