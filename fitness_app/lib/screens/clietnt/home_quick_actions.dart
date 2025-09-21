import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';

class HomeQuickActions extends StatefulWidget {
  final Function(String) onQuickAccessNavigate;

  const HomeQuickActions({super.key, required this.onQuickAccessNavigate});

  @override
  State<HomeQuickActions> createState() => _HomeQuickActionsState();
}

class _HomeQuickActionsState extends State<HomeQuickActions>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppStyles.animationDurationMedium,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      _buildActionData(Icons.sports_tennis, 'Теннис', AppColors.secondary, 'tennis'),
      _buildActionData(Icons.credit_card, 'Абонемент', AppColors.primary, 'membership'),
      _buildActionData(Icons.people, 'Тренеры', AppColors.warning, 'trainers'),
      _buildActionData(Icons.calendar_today, 'Расписание', AppColors.accent, 'schedule'),
      _buildActionData(Icons.account_balance_wallet, 'Пополнить', AppColors.success, 'payment'),
      _buildActionData(Icons.lock, 'Шкафчик', AppColors.error, 'locker'),
      _buildActionData(Icons.book_online, 'Мои записи', AppColors.primaryLight, 'bookings'),
      _buildActionData(Icons.shopping_cart, 'Магазин', AppColors.info, 'shop'),
    ];

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: actions
            .map((action) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildQuickAction(
                    action['icon'] as IconData,
                    action['label'] as String,
                    action['color'] as Color,
                    action['onTap'] as VoidCallback,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Map<String, dynamic> _buildActionData(
      IconData icon, String label, Color color, String screenKey) {
    return {
      'icon': icon,
      'label': label,
      'color': color,
      'onTap': () => _onActionTap(screenKey),
    };
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () {
          _animationController.forward(from: 0.0);
          Future.delayed(const Duration(milliseconds: 100), onTap);
        },
        onTapDown: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.forward(),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowMd,
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка с круглым фоном
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: AppStyles.borderRadiusFull,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              
              // Текст под иконкой
              SizedBox(
                width: 70,
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onActionTap(String screenKey) {
    widget.onQuickAccessNavigate(screenKey);
  }
}