import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';

class AddClientScreen extends StatefulWidget {
  final Function(String, [dynamic]) onNavigate;

  const AddClientScreen({super.key, required this.onNavigate});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();

  DateTime? _selectedBirthDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormatters.formatDate(picked);
      });
    }
  }

  void _addClient() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Создаем нового клиента
        final newClient = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          birthDate: _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
          userType: UserType.client,
        );

        // Добавляем клиента в моковые данные
        MockDataService.clients.add(newClient);

        showSuccessSnackBar(context, 'Клиент успешно добавлен!');

        // Предлагаем записать клиента на тренировку
        _showTrainingConfirmation(newClient);

      } catch (e) {
        showErrorSnackBar(context, 'Ошибка при добавлении клиента: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showTrainingConfirmation(User client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Клиент добавлен',
          style: AppTextStyles.headline5,
        ),
        content: Text(
          'Хотите записать ${client.firstName} ${client.lastName} на тренировку?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateBack();
            },
            child: Text(
              'Позже',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onNavigate('employee_schedule', {
                'preselectedClient': client,
              });
            },
            style: AppStyles.primaryButtonStyle,
            child: Text('Записать сейчас'),
          ),
        ],
      ),
    );
  }

  void _navigateBack() {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.onBack();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Добавить клиента',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                'Основная информация',
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Имя
              Text(
                'Имя',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'Введите имя',
                  border: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите имя';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Фамилия
              Text(
                'Фамилия',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Введите фамилию',
                  border: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите фамилию';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              Text(
                'Email',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Введите email',
                  border: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
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

              // Телефон
              Text(
                'Телефон',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+7 (999) 999-99-99',
                  border: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите телефон';
                  }
                  if (value.length < 10) {
                    return 'Пожалуйста, введите корректный телефон';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Дата рождения
              Text(
                'Дата рождения',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectBirthDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthDateController,
                    decoration: InputDecoration(
                      hintText: 'Выберите дату рождения',
                      suffixIcon: Icon(Icons.calendar_today, color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: AppStyles.borderRadiusMd,
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppStyles.borderRadiusMd,
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, выберите дату рождения';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Кнопка добавления
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addClient,
                  style: AppStyles.primaryButtonStyle.copyWith(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Добавить клиента',
                          style: AppTextStyles.buttonMedium,
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