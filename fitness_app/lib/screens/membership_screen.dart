import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/payment_model.dart';
import '../models/user_model.dart';
import '../main.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  MembershipType? _selectedMembership;

  @override
  Widget build(BuildContext context) {
    final currentMembership = MockDataService.currentUser.membership;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Абонементы'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
            // Текущий абонемент
            if (currentMembership != null) _buildCurrentMembership(currentMembership),
            
            const SizedBox(height: 24),
            
            // Доступные абонементы
            Text(
              'Доступные абонементы:',
              style: AppTextStyles.headline5.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView(
                children: MockDataService.membershipTypes.map((membership) {
                  final isSelected = membership == _selectedMembership;
                  final isCurrent = currentMembership?.type == membership.name;
                  
                  return AppCard(
                    backgroundColor: isSelected 
                        ? AppColors.primary.withOpacity(0.05) 
                        : isCurrent
                            ? AppColors.success.withOpacity(0.1)
                            : Colors.white,
                    child: ListTile(
                      contentPadding: AppStyles.paddingLg,
                      leading: Icon(
                        isCurrent ? Icons.check_circle : Icons.credit_card,
                        color: isCurrent ? AppColors.success : AppColors.primary,
                        size: 28,
                      ),
                      title: Text(
                        membership.name,
                        style: AppTextStyles.headline6.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCurrent ? AppColors.success : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            membership.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${membership.price} руб. / ${membership.durationDays} дней',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildMembershipFeatures(membership),
                        ],
                      ),
                      trailing: isCurrent
                          ? StatusBadge(
                              text: 'Активен',
                              color: AppColors.success,
                            )
                          : Icon(
                              isSelected ? Icons.check : Icons.arrow_forward,
                              color: isSelected ? AppColors.primary : AppColors.textTertiary,
                            ),
                      onTap: isCurrent ? null : () {
                        setState(() {
                          _selectedMembership = membership;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            
            // Кнопка покупки
            if (_selectedMembership != null) ...[
              const SizedBox(height: 16),
              _buildPurchaseButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentMembership(Membership membership) {
    return GradientCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.success, AppColors.success.withOpacity(0.8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Текущий абонемент:',
            style: AppTextStyles.headline6.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            membership.type,
            style: AppTextStyles.headline5.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Действует до: ${_formatDate(membership.endDate)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Text(
            'Осталось дней: ${membership.daysRemaining}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          if (membership.remainingVisits > 0)
            Text(
              'Осталось посещений: ${membership.remainingVisits}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          if (membership.autoRenew)
            Text(
              'Автопродление: Включено',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMembershipFeatures(MembershipType membership) {
    final features = <Widget>[];
    
    if (membership.includesGym) {
      features.add(_buildFeatureItem('🏋️ Тренажерный зал'));
    }
    if (membership.includesGroupClasses) {
      features.add(_buildFeatureItem('👥 Групповые занятия'));
    }
    if (membership.includesTennis) {
      features.add(_buildFeatureItem('🎾 Теннисные корты'));
    }
    if (membership.tennisCourtDiscount > 0) {
      features.add(_buildFeatureItem(
          '🎾 Скидка на корты: ${(membership.tennisCourtDiscount * 100).toInt()}%'));
    }
    if (membership.personalTrainingDiscount > 0) {
      features.add(_buildFeatureItem(
          '💪 Скидка на тренировки: ${(membership.personalTrainingDiscount * 100).toInt()}%'));
    }
    if (membership.maxVisits > 0) {
      features.add(_buildFeatureItem('📊 Посещений в месяц: ${membership.maxVisits}'));
    } else if (membership.includesGym || membership.includesGroupClasses) {
      features.add(_buildFeatureItem('♾️ Неограниченные посещения'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features,
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.check, size: 16, color: AppColors.success),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton() {
    return PrimaryButton(
      text: 'Купить за ${_selectedMembership?.price} руб.',
      onPressed: _purchaseMembership,
      isEnabled: _selectedMembership != null,
      width: double.infinity,
    );
  }

  void _purchaseMembership() {
    if (_selectedMembership == null) return;

    showConfirmDialog(
      context: context,
      title: 'Покупка абонемента',
      content: 'Абонемент: ${_selectedMembership!.name}\n'
          'Стоимость: ${_selectedMembership!.price} руб.\n'
          'Длительность: ${_selectedMembership!.durationDays} дней\n\n'
          'Подтвердить покупку?',
      confirmText: 'Купить',
      cancelText: 'Отмена',
      confirmColor: AppColors.primary,
    ).then((confirmed) {
      if (confirmed == true) {
        _showPurchaseSuccess();
      }
    });
  }

  void _showPurchaseSuccess() {
    showSuccessSnackBar(
      context,
      'Абонемент "${_selectedMembership!.name}" успешно приобретен!',
    );
    
    setState(() {
      _selectedMembership = null;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}