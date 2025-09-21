import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import 'package:flutter/services.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

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

  void _onBirthDateChanged(String value) {
    // Удаляем все нецифровые символы
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Ограничиваем длину (ддммгггг = 8 цифр)
    final limitedDigits = digitsOnly.length > 8 ? digitsOnly.substring(0, 8) : digitsOnly;
    
    // Форматируем в ДД.ММ.ГГГГ
    String formatted = '';
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '.';
      }
      formatted += limitedDigits[i];
    }
    
    // Обновляем контроллер, избегая бесконечного цикла
    if (_birthDateController.text != formatted) {
      _birthDateController.text = formatted;
      _birthDateController.selection = TextSelection.collapsed(offset: formatted.length);
    }
    
    // Парсим дату, если введены все 8 цифр
    if (limitedDigits.length == 8) {
      try {
        final day = int.parse(limitedDigits.substring(0, 2));
        final month = int.parse(limitedDigits.substring(2, 4));
        final year = int.parse(limitedDigits.substring(4, 8));
        
        if (year >= 1900 && year <= DateTime.now().year &&
            month >= 1 && month <= 12 &&
            day >= 1 && day <= 31) {
          final date = DateTime(year, month, day);
          if (date.isBefore(DateTime.now())) {
            setState(() {
              _selectedBirthDate = date;
            });
            return;
          }
        }
      } catch (e) {
        // Невалидная дата
      }
    }
    
    setState(() {
      _selectedBirthDate = null;
    });
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

        // Возвращаемся на главный экран
        _navigateToHome();

      } catch (e) {
        showErrorSnackBar(context, 'Ошибка при добавлении клиента: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToHome() {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateToHome();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
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
          style: AppTextStyles.headline5.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
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

              // Имя
              AppCard(
                padding: AppStyles.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      decoration: AppStyles.inputDecoration.copyWith(
                        hintText: 'Введите имя',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите имя';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Фамилия
              AppCard(
                padding: AppStyles.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      decoration: AppStyles.inputDecoration.copyWith(
                        hintText: 'Введите фамилию',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите фамилию';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Email
              AppCard(
                padding: AppStyles.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      decoration: AppStyles.inputDecoration.copyWith(
                        hintText: 'Введите email',
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
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Телефон
              AppCard(
                padding: AppStyles.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      decoration: AppStyles.inputDecoration.copyWith(
                        hintText: '+7 (999) 999-99-99',
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
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Дата рождения
              AppCard(
                padding: AppStyles.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Дата рождения',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _birthDateController,
                      decoration: AppStyles.inputDecoration.copyWith(
                        hintText: 'ДД.ММ.ГГГГ (например: 19.12.1994)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: _onBirthDateChanged,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите дату рождения';
                        }
                        if (_selectedBirthDate == null) {
                          return 'Пожалуйста, введите корректную дату в формате ДД.ММ.ГГГГ';
                        }
                        return null;
                      },
                    ),
                  ],
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