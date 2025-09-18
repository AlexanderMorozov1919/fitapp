import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../main.dart';
import '../widgets/common_widgets.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final double amount;
  final String paymentMethod;
  final String? description;

  const PaymentSuccessScreen({
    super.key,
    required this.amount,
    required this.paymentMethod,
    this.description,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Автоматический переход на главный экран через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    // Используем навигацию через NavigationService приложения
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      // Полностью очищаем стек быстрого доступа, возвращаясь к главному экрану
      navigationService.navigateToHome();
    } else {
      // Fallback навигация для случая, если NavigationService недоступен
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: AppStyles.paddingXl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Анимированная иконка успеха
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppColors.success,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Заголовок
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Оплата прошла успешно!',
                  style: AppTextStyles.headline4.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              
              // Сумма оплаты
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  '${widget.amount.toStringAsFixed(0)} руб.',
                  style: AppTextStyles.headline3.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Способ оплаты
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Способ: ${widget.paymentMethod}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              
              // Описание (если есть)
              if (widget.description != null) ...[
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    widget.description!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Индикатор загрузки
              FadeTransition(
                opacity: _fadeAnimation,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              
              // Текст о автоматическом переходе
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Автоматический переход на главный экран...',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Кнопка для ручного перехода с анимацией нажатия
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _navigateToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppStyles.borderRadiusLg,
                      ),
                    ),
                    child: const Text('Перейти сейчас'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}