
import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late User _user;
  bool _isEditing = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = User(
      id: 'employee-igor-vinogradov',
      firstName: 'Игорь',
      lastName: 'Виноградов',
      email: 'igor.vinogradov@fitness.ru',
      phone: '+7 (999) 123-45-67',
      birthDate: DateTime(1985, 6, 15),
      photoUrl: null,
      preferences: const [],
      membership: null,
      bookings: const [],
      lockers: const [],
      balance: 0,
    );
    _fillFormData();
  }

  void _fillFormData() {
    _firstNameController.text = 'Игорь';
    _lastNameController.text = 'Виноградов';
    _middleNameController.text = 'Вячеславович';
    _emailController.text = 'igor.vinogradov@fitness.ru';
    _phoneController.text = '+7 (999) 123-45-67';
    _positionController.text = 'Старший тренер';
    _specializationController.text = 'Фитнес, Йога, Персональные тренировки';
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _fillFormData(); // Восстанавливаем оригинальные данные при отмене редактирования
      }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _user = User(
          id: _user.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          birthDate: _user.birthDate,
          photoUrl: _user.photoUrl,
          preferences: _user.preferences,
          membership: _user.membership,
          bookings: _user.bookings,
          lockers: _user.lockers,
          balance: _user.balance,
        );
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Профиль успешно обновлен',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadiusLg,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Профиль сотрудника',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEdit,
            color: AppColors.primary,
          ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
              color: AppColors.primary,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар
              _buildAvatarSection(),
              const SizedBox(height: 24),

              // Личная информация
              Text(
                'Личная информация',
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildPersonalInfo(),

              const SizedBox(height: 32),

              // Служебная информация
              Text(
                'Служебная информация',
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildEmployeeInfo(),

              const SizedBox(height: 32),

              // Настройки уведомлений
              Text(
                'Настройки уведомлений',
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildNotificationSettings(),

              const SizedBox(height: 32),

              // Действия
              Text(
                'Действия',
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildActions(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _user.photoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      _user.photoUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(height: 16),
          if (_isEditing)
            TextButton(
              onPressed: () {
                // TODO: Реализовать загрузку фото
              },
              child: const Text('Изменить фото'),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Имя',
          ),
          enabled: _isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пожалуйста, введите имя';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Фамилия',
          ),
          enabled: _isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пожалуйста, введите фамилию';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _middleNameController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Отчество',
          ),
          enabled: _isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пожалуйста, введите отчество';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Email',
          ),
          enabled: _isEditing,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пожалуйста, введите email';
            }
            if (!value.contains('@')) {
              return 'Пожалуйста, введите корректный email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Телефон',
          ),
          enabled: _isEditing,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пожалуйста, введите телефон';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: AppStyles.paddingLg,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppStyles.borderRadiusLg,
          ),
          child: Row(
            children: [
              Icon(
                Icons.cake,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Дата рождения',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatDate(_user.birthDate),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isEditing)
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    // TODO: Реализовать выбор даты рождения
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeInfo() {
    return Column(
      children: [
        Container(
          padding: AppStyles.paddingLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.work,
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Должность',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Старший тренер',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: AppStyles.paddingLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.school,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Специализация',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Фитнес, Йога, Персональные тренировки',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: AppStyles.paddingLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.work_history,
                color: AppColors.accent,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Стаж работы',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '3 года 8 месяцев',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: AppStyles.paddingLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.badge,
                color: AppColors.success,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID сотрудника',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'EMP-2021-001',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        Container(
          padding: AppStyles.paddingLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: SwitchListTile(
            title: Text(
              'Уведомления о расписании',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Напоминания о начале занятий и изменениях в расписании',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            value: true,
            onChanged: _isEditing ? (value) {} : null,
            activeColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: AppStyles.paddingLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: SwitchListTile(
            title: Text(
              'Уведомления о KPI',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Еженедельные отчеты о показателях эффективности',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            value: true,
            onChanged: _isEditing ? (value) {} : null,
            activeColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: AppStyles.paddingLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: SwitchListTile(
            title: Text(
              'Административные уведомления',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Важные сообщения от администрации',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            value: false,
            onChanged: _isEditing ? (value) {} : null,
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: ListTile(
            leading: Icon(Icons.analytics, color: AppColors.primary),
            title: Text(
              'Мои показатели KPI',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {
              final navigationService = NavigationService.of(context);
              navigationService?.navigateTo('kpi_detail');
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: ListTile(
            leading: Icon(Icons.schedule, color: AppColors.secondary),
            title: Text(
              'Мое расписание',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {
              final navigationService = NavigationService.of(context);
              navigationService?.navigateTo('employee_schedule');
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: ListTile(
            leading: Icon(Icons.security, color: AppColors.accent),
            title: Text(
              'Безопасность',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Смена пароля, доступ к системе',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {
              final navigationService = NavigationService.of(context);
              navigationService?.navigateTo('security_settings');
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: ListTile(
            leading: Icon(Icons.help, color: AppColors.accent),
            title: Text(
              'Помощь и поддержка',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {
              final navigationService = NavigationService.of(context);
              navigationService?.navigateTo('help_support');
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppStyles.borderRadiusLg,
            boxShadow: AppColors.shadowSm,
          ),
          child: ListTile(
            leading: Icon(Icons.exit_to_app, color: AppColors.error),
            title: Text(
              'Выйти',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Выход из системы
              showSuccessSnackBar(context, 'Вы успешно вышли из системы');
              // Возврат на экран выбора типа пользователя
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/user-type',
                (route) => false
              );
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _specializationController.dispose();
    super.dispose();
  }
}
