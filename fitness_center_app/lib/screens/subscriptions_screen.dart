import 'package:flutter/material.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/utils/animations.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Мои подписки'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.dark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Subscription
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _CurrentSubscriptionCard(),
            ),
            const SizedBox(height: 25),
            
            // Available Plans
            const Text(
              'Доступные тарифы',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 15),
            
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _SubscriptionPlanCard(
                title: 'Базовый',
                price: '7 990 ₽/мес',
                features: [
                  '• Доступ к тренажерам',
                  '• 4 групповых занятия',
                  '• 4 часа тенниса',
                ],
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _SubscriptionPlanCard(
                title: 'Стандарт',
                price: '9 990 ₽/мес',
                features: [
                  '• Доступ к тренажерам',
                  '• 8 групповых занятий',
                  '• 6 часов тенниса',
                  '• 1 персональная тренировка',
                ],
                gradient: LinearGradient(
                  colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _SubscriptionPlanCard(
                title: 'Премиум',
                price: '12 990 ₽/мес',
                features: [
                  '• Неограниченный доступ к тренажерам',
                  '• 12 групповых занятий',
                  '• 8 часов тенниса',
                  '• 2 персональные тренировки',
                ],
                gradient: LinearGradient(
                  colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                ),
              ),
            ),
            const SizedBox(height: 25),
            
            // Payment History
            const Text(
              'История платежей',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 15),
            
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _PaymentHistoryItem(
                date: '15.03.2024',
                amount: '12 990 ₽',
                plan: 'Премиум подписка',
                status: 'Успешно',
              ),
            ),
            const SizedBox(height: 10),
            
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _PaymentHistoryItem(
                date: '15.02.2024',
                amount: '12 990 ₽',
                plan: 'Премиум подписка',
                status: 'Успешно',
              ),
            ),
            const SizedBox(height: 10),
            
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _PaymentHistoryItem(
                date: '15.01.2024',
                amount: '12 990 ₽',
                plan: 'Премиум подписка',
                status: 'Успешно',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentSubscriptionCard extends StatelessWidget {
  const _CurrentSubscriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Текущая подписка',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'All-inclusive Премиум',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            '12 990 ₽/мес',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            '• Неограниченный доступ к тренажерам\n'
            '• 12 групповых занятий\n'
            '• 8 часов тенниса\n'
            '• 2 персональные тренировки',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Действует до: 15.04.2024',
            style: TextStyle(
              color: Color(0xE6FFFFFF),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => AppNavigator.pushRenewSubscription(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(15),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sync, size: 18),
                SizedBox(width: 8),
                Text('Продлить подписку'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final Gradient gradient;

  const _SubscriptionPlanCard({
    required this.title,
    required this.price,
    required this.features,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              feature,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          )).toList(),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(12),
            ),
            child: const Text('Выбрать тариф'),
          ),
        ],
      ),
    );
  }
}

class _PaymentHistoryItem extends StatelessWidget {
  final String date;
  final String amount;
  final String plan;
  final String status;

  const _PaymentHistoryItem({
    required this.date,
    required this.amount,
    required this.plan,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.payment,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}