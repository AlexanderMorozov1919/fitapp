import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late User _user;
  bool _isEditing = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = MockDataService.currentUser;
    _fillFormData();
  }

  void _fillFormData() {
    _firstNameController.text = _user.firstName;
    _lastNameController.text = _user.lastName;
    _emailController.text = _user.email;
    _phoneController.text = _user.phone;
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
        const SnackBar(
          content: Text('Профиль успешно обновлен'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEdit,
          ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар
              _buildAvatarSection(),
              const SizedBox(height: 24),

              // Личная информация
              const Text(
                'Личная информация',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPersonalInfo(),

              const SizedBox(height: 32),

              // Настройки уведомлений
              const Text(
                'Настройки уведомлений',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildNotificationSettings(),

              const SizedBox(height: 32),

              // Действия
              const Text(
                'Действия',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(50),
            ),
            child: _user.photoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      _user.photoUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[600],
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
          decoration: const InputDecoration(
            labelText: 'Имя',
            border: OutlineInputBorder(),
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
          decoration: const InputDecoration(
            labelText: 'Фамилия',
            border: OutlineInputBorder(),
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
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
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
          decoration: const InputDecoration(
            labelText: 'Телефон',
            border: OutlineInputBorder(),
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
        ListTile(
          leading: const Icon(Icons.cake),
          title: const Text('Дата рождения'),
          subtitle: Text(_formatDate(_user.birthDate)),
          trailing: _isEditing
              ? IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Реализовать выбор даты рождения
                  },
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Уведомления о бронированиях'),
          subtitle: const Text('Получать уведомления о подтверждении и напоминаниях'),
          value: true,
          onChanged: _isEditing ? (value) {} : null,
        ),
        SwitchListTile(
          title: const Text('Уведомления о занятиях'),
          subtitle: const Text('Напоминания о начале групповых занятий'),
          value: true,
          onChanged: _isEditing ? (value) {} : null,
        ),
        SwitchListTile(
          title: const Text('Новости и акции'),
          subtitle: const Text('Получать информацию о новых услугах и акциях'),
          value: false,
          onChanged: _isEditing ? (value) {} : null,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.credit_card, color: Colors.blue),
          title: const Text('Способы оплаты'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Реализовать экран управления платежными методами
          },
        ),
        ListTile(
          leading: const Icon(Icons.security, color: Colors.green),
          title: const Text('Безопасность'),
          subtitle: const Text('Смена пароля, двухфакторная аутентификация'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Реализовать экран настроек безопасности
          },
        ),
        ListTile(
          leading: const Icon(Icons.help, color: Colors.orange),
          title: const Text('Помощь и поддержка'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Реализовать экран поддержки
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.red),
          title: const Text('Выйти'),
          onTap: () {
            _showLogoutDialog();
          },
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
              // TODO: Реализовать выход из системы
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Вы успешно вышли из системы'),
                  backgroundColor: Colors.green,
                ),
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
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}