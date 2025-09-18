import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/payment_model.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';
import '../main.dart';

class MembershipDetailScreen extends StatefulWidget {
  final dynamic membershipData; // Может быть Membership или MembershipType
  final bool isMembershipType;

  const MembershipDetailScreen({super.key, required this.membershipData})
      : isMembershipType = membershipData is MembershipType;

  @override
  State<MembershipDetailScreen> createState() => _MembershipDetailScreenState();
}

class _MembershipDetailScreenState extends State<MembershipDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final currentMembership = MockDataService.currentUser.membership;
    final isCurrentMembership = widget.isMembershipType
        ? currentMembership?.type == (widget.membershipData as MembershipType).name
        : true;
    
    final membership = widget.isMembershipType
        ? _convertToMembership(widget.membershipData as MembershipType)
        : widget.membershipData as Membership;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Детали абонемента',
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
                  // Заголовок и статус
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          membership.type,
                          style: AppTextStyles.headline6.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(
                        text: membership.isActive ? 'Активен' : 'Истек',
                        color: membership.isActive ? AppColors.success : AppColors.error,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Иконка и тип абонемента
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: AppStyles.borderRadiusLg,
                        ),
                        child: Icon(
                          Icons.credit_card,
                          size: 24,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Абонемент',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getMembershipDescription(membership.type),
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

                  // Разделитель
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),

                  // Детали абонемента
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    title: 'Начало действия',
                    value: DateFormatters.formatDate(membership.startDate),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    title: 'Окончание действия',
                    value: DateFormatters.formatDate(membership.endDate),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.timer,
                    title: 'Осталось дней',
                    value: '${membership.daysRemaining}',
                  ),
                  const SizedBox(height: 8),
                  
                  // Информация о посещениях
                  if (membership.remainingVisits > 0) ...[
                    _buildDetailRow(
                      icon: Icons.confirmation_number,
                      title: 'Осталось посещений',
                      value: '${membership.remainingVisits}',
                    ),
                    const SizedBox(height: 8),
                  ] else if (membership.remainingVisits == -1) ...[
                    _buildDetailRow(
                      icon: Icons.all_inclusive,
                      title: 'Посещения',
                      value: 'Неограниченные',
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Стоимость
                  if (membership.price > 0) ...[
                    _buildDetailRow(
                      icon: Icons.attach_money,
                      title: 'Стоимость',
                      value: '${membership.price.toInt()} ₽',
                      valueStyle: AppTextStyles.price.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Автопродление
                  _buildDetailRow(
                    icon: Icons.autorenew,
                    title: 'Автопродление',
                    value: membership.autoRenew ? 'Включено' : 'Отключено',
                    valueStyle: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: membership.autoRenew ? AppColors.success : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Включенные услуги
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Включенные услуги',
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._buildIncludedServices(membership),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Кнопки действий
            if (widget.isMembershipType && !isCurrentMembership) ...[
              // Кнопка покупки для нового абонемента
              PrimaryButton(
                text: 'Купить за ${(widget.membershipData as MembershipType).price} руб.',
                onPressed: _purchaseMembership,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
            ] else if (membership.isActive) ...[
              // Кнопки управления для активного абонемента
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Отключить автопродление',
                      onPressed: _toggleAutoRenew,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Продлить абонемент',
                      onPressed: _renewMembership,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Информация о покупке
            Text(
              'Абонемент приобретен: ${DateFormatters.formatDateTime(membership.startDate)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: valueStyle ?? AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildIncludedServices(Membership membership) {
    final services = <Widget>[];
    
    for (final service in membership.includedServices) {
      services.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getServiceDisplayName(service),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return services;
  }

  String _getMembershipDescription(String type) {
    switch (type.toLowerCase()) {
      case 'стандарт':
        return 'Базовый доступ к тренажерному залу';
      case 'премиум':
        return 'Полный доступ ко всем услугам клуба';
      case 'теннис':
        return 'Доступ к теннисным кортам и залу';
      case 'безлимит':
        return 'Неограниченные посещения всех зон';
      default:
        return 'Фитнес абонемент';
    }
  }

  String _getServiceDisplayName(String service) {
    switch (service) {
      case 'тренажерный зал':
        return '🏋️ Тренажерный зал';
      case 'групповые занятия':
        return '👥 Групповые занятия';
      case 'теннис':
        return '🎾 Теннисные корты';
      case 'бассейн':
        return '🏊 Бассейн';
      case 'сауна':
        return '🧖 Сауна';
      default:
        return service;
    }
  }

  void _toggleAutoRenew() {
    // TODO: Реализовать логику отключения автопродления
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Автопродление ${widget.membershipData.autoRenew ? 'отключено' : 'включено'}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _renewMembership() {
    // TODO: Реализовать логику продления абонемента
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('payment', widget.membershipData);
  }

  void _purchaseMembership() {
    final membershipType = widget.membershipData as MembershipType;
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('payment', {
      'amount': membershipType.price,
      'description': 'Покупка абонемента: ${membershipType.name}',
      'membership': membershipType,
    });
  }

  Membership _convertToMembership(MembershipType membershipType) {
    return Membership(
      id: 'temp_membership',
      type: membershipType.name,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: membershipType.durationDays)),
      remainingVisits: membershipType.maxVisits == 0 ? -1 : membershipType.maxVisits,
      price: membershipType.price,
      includedServices: _getIncludedServicesFromType(membershipType),
      autoRenew: false,
    );
  }

  List<String> _getIncludedServicesFromType(MembershipType membershipType) {
    final services = <String>[];
    if (membershipType.includesGym) services.add('тренажерный зал');
    if (membershipType.includesGroupClasses) services.add('групповые занятия');
    if (membershipType.includesTennis) services.add('теннис');
    return services;
  }
}