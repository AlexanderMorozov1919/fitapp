import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';

/// Экран настроек безопасности для клиентов
class ClientSecuritySettingsScreen extends StatefulWidget {
  const ClientSecuritySettingsScreen({super.key});

  @override
  State<ClientSecuritySettingsScreen> createState() => _ClientSecuritySettingsScreenState();
}

class _ClientSecuritySettingsScreenState extends State<ClientSecuritySettingsScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _biometricsEnabled = true;
  bool _autoLogoutEnabled = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _twoFactorEnabled = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      showErrorSnackBar(context, 'Пароли не совпадают');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      showErrorSnackBar(context, 'Пароль должен содержать не менее 6 символов');
      return;
    }

    // TODO: Реализовать смену пароля через API
    showSuccessSnackBar(context, 'Пароль успешно изменен');
    
    // Очищаем поля
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Безопасность',
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
            // Смена пароля
            Text(
              'Смена пароля',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: AppColors.shadowSm,
              ),
              child: Column(
                children: [
                  _buildPasswordField(
                    controller: _currentPasswordController,
                    label: 'Текущий пароль',
                    isVisible: _showCurrentPassword,
                    onVisibilityChanged: (value) {
                      setState(() => _showCurrentPassword = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    controller: _newPasswordController,
                    label: 'Новый пароль',
                    isVisible: _showNewPassword,
                    onVisibilityChanged: (value) {
                      setState(() => _showNewPassword = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Подтверждение пароля',
                    isVisible: _showConfirmPassword,
                    onVisibilityChanged: (value) {
                      setState(() => _showConfirmPassword = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Изменить пароль',
                      onPressed: _changePassword,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Настройки безопасности
            Text(
              'Настройки безопасности',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: AppColors.shadowSm,
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'Биометрическая аутентификация',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Вход по отпечатку пальца или Face ID',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _biometricsEnabled,
                    onChanged: (value) {
                      setState(() => _biometricsEnabled = value);
                      showSuccessSnackBar(
                        context, 
                        value ? 'Биометрия включена' : 'Биометрия отключена'
                      );
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Divider(height: 24),
                  SwitchListTile(
                    title: Text(
                      'Двухфакторная аутентификация',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Дополнительная защита вашего аккаунта',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _twoFactorEnabled,
                    onChanged: (value) {
                      setState(() => _twoFactorEnabled = value);
                      showSuccessSnackBar(
                        context, 
                        value ? '2FA включена' : '2FA отключена'
                      );
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Divider(height: 24),
                  SwitchListTile(
                    title: Text(
                      'Автоматический выход',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Выход из системы после 15 минут бездействия',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: _autoLogoutEnabled,
                    onChanged: (value) {
                      setState(() => _autoLogoutEnabled = value);
                      showSuccessSnackBar(
                        context, 
                        value ? 'Автовыход включен' : 'Автовыход отключен'
                      );
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // История входов
            Text(
              'История входов',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: AppStyles.paddingLg,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: AppColors.shadowSm,
              ),
              child: Column(
                children: [
                  _buildLoginHistoryItem('Сегодня, 10:30', 'iPhone 13 Pro', 'Москва'),
                  const Divider(height: 16),
                  _buildLoginHistoryItem('Вчера, 18:45', 'Samsung Galaxy S22', 'Санкт-Петербург'),
                  const Divider(height: 16),
                  _buildLoginHistoryItem('2 дня назад, 09:15', 'iPhone 13 Pro', 'Москва'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required Function(bool) onVisibilityChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppStyles.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.primary),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.textSecondary,
          ),
          onPressed: () => onVisibilityChanged(!isVisible),
        ),
        filled: true,
        fillColor: AppColors.background,
      ),
    );
  }

  Widget _buildLoginHistoryItem(String time, String device, String location) {
    return Row(
      children: [
        Icon(Icons.phone_iphone, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$time • $location',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: AppStyles.borderRadiusSm,
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Text(
            'Успешно',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}