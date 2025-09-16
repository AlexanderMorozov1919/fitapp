import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/navigation/app_navigator.dart';
import 'package:fitness_center_app/widgets/app_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, dynamic> _userProfile = {
    'name': 'Александр Морозов',
    'email': 'alex.morozov@email.com',
    'phone': '+7 (999) 123-45-67',
    'membership': {
      'type': 'Премиум',
      'status': 'Активен',
      'expiryDate': '2024-12-31',
      'remainingDays': 289,
    },
    'stats': {
      'visitsThisMonth': 12,
      'totalVisits': 156,
      'workoutHours': 234,
      'caloriesBurned': 125400,
    },
    'preferences': {
      'notifications': true,
      'newsletter': false,
      'marketing': false,
    },
  };

  final List<Map<String, dynamic>> _profileSections = [
    {
      'title': 'Личная информация',
      'icon': Icons.person,
      'items': [
        {'label': 'Имя', 'value': 'Александр Морозов', 'editable': true},
        {'label': 'Email', 'value': 'alex.morozov@email.com', 'editable': true},
        {'label': 'Телефон', 'value': '+7 (999) 123-45-67', 'editable': true},
      ],
    },
    {
      'title': 'Абонемент',
      'icon': Icons.card_membership,
      'items': [
        {'label': 'Тип', 'value': 'Премиум', 'editable': false},
        {'label': 'Статус', 'value': 'Активен', 'editable': false},
        {'label': 'Действует до', 'value': '31.12.2024', 'editable': false},
        {'label': 'Осталось дней', 'value': '289', 'editable': false},
      ],
    },
    {
      'title': 'Статистика',
      'icon': Icons.analytics,
      'items': [
        {'label': 'Посещений в этом месяце', 'value': '12', 'editable': false},
        {'label': 'Всего посещений', 'value': '156', 'editable': false},
        {'label': 'Часов тренировок', 'value': '234', 'editable': false},
        {'label': 'Сожжено калорий', 'value': '125,400', 'editable': false},
      ],
    },
    {
      'title': 'Настройки',
      'icon': Icons.settings,
      'items': [
        {'label': 'Уведомления', 'value': 'Включены', 'editable': true, 'type': 'switch'},
        {'label': 'Email рассылка', 'value': 'Отключена', 'editable': true, 'type': 'switch'},
        {'label': 'Маркетинговые сообщения', 'value': 'Отключены', 'editable': true, 'type': 'switch'},
      ],
    },
  ];

  void _editProfile() {
    // Здесь будет логика редактирования профиля
    // Редактирование профиля
  }

  void _toggleSetting(String settingKey, bool value) {
    setState(() {
      _userProfile['preferences'][settingKey] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        children: [
          // Header with back button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => AppNavigator.pop(),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Профиль',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editProfile,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ),

          // User profile header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.light,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'АМ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userProfile['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _userProfile['email'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.gray,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _userProfile['phone'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Profile sections
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _profileSections.length,
              itemBuilder: (context, index) {
                final section = _profileSections[index];
                return _buildProfileSection(section);
              },
            ),
          ),

          // Logout button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                // Здесь будет логика выхода из системы
                // Выход из системы
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Выйти из системы',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(Map<String, dynamic> section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(section['icon'], size: 20, color: AppTheme.primary),
                const SizedBox(width: 10),
                Text(
                  section['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Section items
          for (final item in section['items'] as List<Map<String, dynamic>>)
            _buildProfileItem(item, section['title']),
        ],
      ),
    );
  }

  Widget _buildProfileItem(Map<String, dynamic> item, String sectionTitle) {
    final isSettingsSection = sectionTitle == 'Настройки';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item['label'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isSettingsSection && item['type'] == 'switch')
            Switch(
              value: _getSettingValue(item['label']),
              onChanged: (value) => _handleSettingChange(item['label'], value),
              activeColor: AppTheme.primary,
            )
          else
            Text(
              item['value'],
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  bool _getSettingValue(String label) {
    switch (label) {
      case 'Уведомления':
        return _userProfile['preferences']['notifications'];
      case 'Email рассылка':
        return _userProfile['preferences']['newsletter'];
      case 'Маркетинговые сообщения':
        return _userProfile['preferences']['marketing'];
      default:
        return false;
    }
  }

  void _handleSettingChange(String label, bool value) {
    switch (label) {
      case 'Уведомления':
        _toggleSetting('notifications', value);
        break;
      case 'Email рассылка':
        _toggleSetting('newsletter', value);
        break;
      case 'Маркетинговые сообщения':
        _toggleSetting('marketing', value);
        break;
    }
  }
}