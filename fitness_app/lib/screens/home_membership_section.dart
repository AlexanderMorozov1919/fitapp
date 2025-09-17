import 'package:flutter/material.dart';
import '../models/user_model.dart';

class HomeMembershipSection extends StatelessWidget {
  final User user;
  final Function(String) onQuickAccessNavigate;

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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      membership.type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMembershipDetailItem(
                '📅 Действует до',
                _formatDateFull(membership.endDate),
              ),
              _buildMembershipDetailItem(
                '⏰ Осталось дней',
                '${membership.daysRemaining}',
              ),
              if (membership.remainingVisits > 0)
                _buildMembershipDetailItem(
                  '🎯 Осталось посещений',
                  '${membership.remainingVisits}',
                ),
              if (membership.remainingVisits == -1)
                _buildMembershipDetailItem(
                  '♾️ Посещения',
                  'Неограниченные',
                ),
              if (membership.autoRenew)
                _buildMembershipDetailItem(
                  '🔄 Автопродление',
                  'Включено',
                  color: Colors.green,
                ),
              const SizedBox(height: 8),
              const Text(
                'Включенные услуги:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              _buildMembershipFeatures(membership),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              onQuickAccessNavigate('membership');
            },
            child: const Text(
              'Управление абонементом →',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipDetailItem(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipFeatures(Membership membership) {
    final features = <Widget>[];
    
    // Проверяем включенные услуги
    if (membership.includedServices.contains('gym')) {
      features.add(_buildFeatureItem('🏋️ Тренажерный зал'));
    }
    if (membership.includedServices.contains('group_classes')) {
      features.add(_buildFeatureItem('👥 Групповые занятия'));
    }
    if (membership.includedServices.contains('tennis')) {
      features.add(_buildFeatureItem('🎾 Теннисные корты'));
    }
    if (membership.includedServices.contains('pool')) {
      features.add(_buildFeatureItem('🏊 Бассейн'));
    }
    if (membership.includedServices.contains('yoga')) {
      features.add(_buildFeatureItem('🧘 Йога'));
    }

    // Добавляем информацию о неограниченных посещениях
    if (membership.remainingVisits == -1) {
      features.add(_buildFeatureItem('♾️ Неограниченные посещения'));
    } else if (membership.remainingVisits > 0) {
      features.add(_buildFeatureItem('📊 Посещений: ${membership.remainingVisits}'));
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
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatDateFull(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}