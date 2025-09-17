import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/payment_model.dart';
import '../models/user_model.dart';
import '../main.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Текущий абонемент
            if (currentMembership != null) _buildCurrentMembership(currentMembership),
            
            const SizedBox(height: 24),
            
            // Доступные абонементы
            const Text(
              'Доступные абонементы:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: ListView(
                children: MockDataService.membershipTypes.map((membership) {
                  final isSelected = membership == _selectedMembership;
                  final isCurrent = currentMembership?.type == membership.name;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected 
                        ? Colors.blue.withOpacity(0.1) 
                        : isCurrent
                            ? Colors.green.withOpacity(0.1)
                            : Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(
                        isCurrent ? Icons.check_circle : Icons.credit_card,
                        color: isCurrent ? Colors.green : Colors.blue,
                      ),
                      title: Text(
                        membership.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.green : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(membership.description),
                          const SizedBox(height: 4),
                          Text(
                            '${membership.price} руб. / ${membership.durationDays} дней',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildMembershipFeatures(membership),
                        ],
                      ),
                      trailing: isCurrent
                          ? const Text(
                              'Активен',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Icon(
                              isSelected ? Icons.check : Icons.arrow_forward,
                              color: isSelected ? Colors.blue : Colors.grey,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Текущий абонемент:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            membership.type,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('Действует до: ${_formatDate(membership.endDate)}'),
          Text('Осталось дней: ${membership.daysRemaining}'),
          if (membership.remainingVisits > 0)
            Text('Осталось посещений: ${membership.remainingVisits}'),
          if (membership.autoRenew)
            const Text(
              'Автопродление: Включено',
              style: TextStyle(color: Colors.green),
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

  Widget _buildPurchaseButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedMembership != null ? _purchaseMembership : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Купить за ${_selectedMembership?.price} руб.',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _purchaseMembership() {
    if (_selectedMembership == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Покупка абонемента'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Абонемент: ${_selectedMembership!.name}'),
            Text('Стоимость: ${_selectedMembership!.price} руб.'),
            Text('Длительность: ${_selectedMembership!.durationDays} дней'),
            const SizedBox(height: 16),
            const Text('Подтвердить покупку?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPurchaseSuccess();
            },
            child: const Text('Купить'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Абонемент "${_selectedMembership!.name}" успешно приобретен!'),
        backgroundColor: Colors.green,
      ),
    );
    
    setState(() {
      _selectedMembership = null;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}