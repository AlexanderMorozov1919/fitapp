import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';

/// Экран управления платежными методами для клиентов
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'card',
      'title': 'Банковская карта',
      'subtitle': '**** 1234',
      'icon': Icons.credit_card,
      'color': AppColors.primary,
      'isDefault': true,
    },
    {
      'type': 'apple_pay',
      'title': 'Apple Pay',
      'subtitle': 'Настроено',
      'icon': Icons.apple,
      'color': AppColors.textPrimary,
      'isDefault': false,
    },
    {
      'type': 'google_pay',
      'title': 'Google Pay',
      'subtitle': 'Настроено',
      'icon': Icons.phone_android,
      'color': AppColors.secondary,
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Способы оплаты',
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
            // Список платежных методов
            Text(
              'Мои способы оплаты',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            ..._paymentMethods.map((method) => _buildPaymentMethodCard(method)),
            
            const SizedBox(height: 24),
            
            // Добавление нового метода
            Text(
              'Добавить способ оплаты',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildAddPaymentMethodButton(
              'Банковская карта',
              Icons.credit_card,
              AppColors.primary,
              onTap: _addCard,
            ),
            const SizedBox(height: 12),
            
            _buildAddPaymentMethodButton(
              'Apple Pay',
              Icons.apple,
              AppColors.textPrimary,
              onTap: _addApplePay,
            ),
            const SizedBox(height: 12),
            
            _buildAddPaymentMethodButton(
              'Google Pay',
              Icons.phone_android,
              AppColors.secondary,
              onTap: _addGooglePay,
            ),
            
            const SizedBox(height: 32),
            
            // Информация о безопасности
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppStyles.borderRadiusLg,
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: AppColors.success, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Все платежи защищены и обрабатываются через безопасное соединение',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: method['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(method['icon'], color: method['color']),
        ),
        title: Text(
          method['title'],
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          method['subtitle'],
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: method['isDefault']
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: AppStyles.borderRadiusSm,
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Text(
                  'По умолчанию',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        onTap: () => _editPaymentMethod(method),
      ),
    );
  }

  Widget _buildAddPaymentMethodButton(
    String title,
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.add, color: AppColors.textTertiary),
        onTap: onTap,
      ),
    );
  }

  void _addCard() {
    showInfoSnackBar(context, 'Добавление банковской карты');
    // TODO: Реализовать добавление карты
  }

  void _addApplePay() {
    showInfoSnackBar(context, 'Настройка Apple Pay');
    // TODO: Реализовать настройку Apple Pay
  }

  void _addGooglePay() {
    showInfoSnackBar(context, 'Настройка Google Pay');
    // TODO: Реализовать настройку Google Pay
  }

  void _editPaymentMethod(Map<String, dynamic> method) {
    showInfoSnackBar(context, 'Редактирование ${method['title']}');
    // TODO: Реализовать редактирование метода оплаты
  }
}