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
import 'payment_screen.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  @override
  Widget build(BuildContext context) {
    final currentMembership = MockDataService.currentUser.membership;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Абонементы'),
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
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Текущий абонемент
            if (currentMembership != null) _buildCurrentMembership(currentMembership),
            
            const SizedBox(height: 24),
            
            // Заголовок доступных абонементов
            SectionHeader(
              title: 'Доступные абонементы',
              trailing: Icon(
                Icons.info_outline,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onTrailingTap: () {
                _showMembershipInfo();
              },
            ),
            const SizedBox(height: 16),
            
            // Список абонементов
            Column(
              children: MockDataService.membershipTypes.map((membership) {
                final isCurrent = currentMembership?.type == membership.name;
                
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _navigateToMembershipDetail(membership);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: AppStyles.borderRadiusLg,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AppCard(
                        backgroundColor: isCurrent
                            ? AppColors.success.withOpacity(0.1)
                            : Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Заголовок и статус
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isCurrent ? AppColors.success : AppColors.primary,
                                    borderRadius: AppStyles.borderRadiusFull,
                                  ),
                                  child: Icon(
                                    isCurrent ? Icons.check_circle : Icons.credit_card,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              membership.name,
                                              style: AppTextStyles.headline6.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: isCurrent ? AppColors.success : AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          if (isCurrent)
                                            StatusBadge(
                                              text: 'Активен',
                                              color: AppColors.success,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        membership.description,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Цена и длительность
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.05),
                                borderRadius: AppStyles.borderRadiusMd,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${membership.price} руб.',
                                    style: AppTextStyles.price.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${membership.durationDays} дней',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Включенные услуги
                            _buildMembershipFeatures(membership),
                            
                            const SizedBox(height: 16),
                            
                            // Кнопка просмотра деталей
                            if (!isCurrent)
                              SecondaryButton(
                                text: 'Подробнее',
                                onPressed: () {
                                  _navigateToMembershipDetail(membership);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentMembership(Membership membership) {
    return GradientCard(
      gradient: AppColors.secondaryGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: AppStyles.borderRadiusFull,
                ),
                child: Icon(
                  Icons.credit_card,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Текущий абонемент',
                style: AppTextStyles.headline6.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            membership.type,
            style: AppTextStyles.headline5.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Детали абонемента
          _buildMembershipDetails(membership),
          
          const SizedBox(height: 16),
          
          // Включенные услуги
          _buildIncludedServices(membership),
        ],
      ),
    );
  }

  Widget _buildMembershipDetails(Membership membership) {
    return Column(
      children: [
        _buildDetailRow(
          Icons.calendar_today,
          'Действует до',
          DateFormatters.formatDateWithMonth(membership.endDate),
        ),
        const SizedBox(height: 8),
        if (membership.remainingVisits > 0)
          _buildDetailRow(
            Icons.confirmation_number,
            'Осталось посещений',
            '${membership.remainingVisits}',
          ),
        if (membership.remainingVisits == -1)
          _buildDetailRow(
            Icons.all_inclusive,
            'Посещения',
            'Неограниченные',
          ),
        if (membership.autoRenew)
          _buildDetailRow(
            Icons.autorenew,
            'Автопродление',
            'Включено',
            color: Colors.greenAccent,
          ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? Colors.white.withOpacity(0.8),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildIncludedServices(Membership membership) {
    final services = <Widget>[
      if (membership.includedServices.contains('тренажерный зал'))
        _buildServiceItem('🏋️ Тренажерный зал'),
      if (membership.includedServices.contains('групповые занятия'))
        _buildServiceItem('👥 Групповые занятия'),
      if (membership.includedServices.contains('теннис'))
        _buildServiceItem('🎾 Теннисные корты'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Включенные услуги:',
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: services,
        ),
      ],
    );
  }

  Widget _buildServiceItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: AppStyles.borderRadiusSm,
      ),
      child: Text(
        text,
        style: AppTextStyles.overline.copyWith(
          color: Colors.white,
        ),
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

  void _navigateToMembershipDetail(MembershipType membership) {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('membership_detail', membership);
  }

  void _showMembershipInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Информация об абонементах',
          style: AppTextStyles.headline5,
        ),
        content: Text(
          'Выберите подходящий абонемент для доступа к услугам клуба. '
          'Абонементы автоматически активируются после оплаты и действуют указанное количество дней.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Понятно',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}