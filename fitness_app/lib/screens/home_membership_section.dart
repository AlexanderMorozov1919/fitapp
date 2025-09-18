import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';

class HomeMembershipSection extends StatelessWidget {
  final User user;
  final Function(String, [dynamic]) onQuickAccessNavigate;

  const HomeMembershipSection({
    super.key,
    required this.user,
    required this.onQuickAccessNavigate,
  });

  @override
  Widget build(BuildContext context) {
    if (user.membership == null) {
      return Container(); // Не показываем, если нет абонемента
    }

    final membership = user.membership!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Карточка абонемента
        GestureDetector(
          onTap: () => onQuickAccessNavigate('membership_detail', membership),
          child: GradientCard(
            gradient: AppColors.secondaryGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Заголовок и тип абонемента
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
                  Expanded(
                    child: Text(
                      membership.type,
                      style: AppTextStyles.headline5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Прогресс бар дней
              _buildDaysProgress(membership),
              const SizedBox(height: 16),
              
              // Детали абонемента
              _buildMembershipDetails(membership),
              const SizedBox(height: 12),
              
              // Включенные услуги
              _buildIncludedServices(membership),
            ],
            ),
          ),
        ),
        
      ],
    );
  }

  Widget _buildDaysProgress(Membership membership) {
    final progress = membership.daysRemaining / 30; // Пример: 30 дней в месяце
    final daysText = DateFormatters.formatDays(membership.daysRemaining);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Осталось дней',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Text(
              daysText,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: AppStyles.progressBarDecoration.copyWith(
            color: Colors.white.withOpacity(0.3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: AppStyles.progressBarFillDecoration(Colors.white),
            ),
          ),
        ),
      ],
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

  String _formatDateFull(DateTime date) {
    return DateFormatters.formatDateWithMonth(date);
  }
}