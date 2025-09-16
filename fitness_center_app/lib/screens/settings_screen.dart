import 'package:flutter/material.dart';
import 'package:fitness_center_app/theme/app_theme.dart';
import 'package:fitness_center_app/utils/animations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricsEnabled = false;
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
        title: const Text('Настройки'),
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
            // Account Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _SettingsSection(
                title: 'Аккаунт',
                children: [
                  _SettingsItem(
                    icon: Icons.person,
                    title: 'Профиль',
                    subtitle: 'Личная информация',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  _SettingsItem(
                    icon: Icons.security,
                    title: 'Безопасность',
                    subtitle: 'Пароль и доступ',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  _SettingsItem(
                    icon: Icons.payment,
                    title: 'Способы оплаты',
                    subtitle: 'Карты и платежи',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Notifications Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _SettingsSection(
                title: 'Уведомления',
                children: [
                  _SettingsItem(
                    icon: Icons.notifications,
                    title: 'Уведомления',
                    subtitle: 'Включить/выключить',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                      activeColor: AppTheme.primary,
                    ),
                  ),
                  if (_notificationsEnabled) ...[
                    const _SettingsItem(
                      icon: Icons.email,
                      title: 'Email уведомления',
                      subtitle: 'Новости и обновления',
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    const _SettingsItem(
                      icon: Icons.calendar_today,
                      title: 'Напоминания о занятиях',
                      subtitle: 'За 1 час до начала',
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Appearance Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _SettingsSection(
                title: 'Внешний вид',
                children: [
                  _SettingsItem(
                    icon: Icons.dark_mode,
                    title: 'Темная тема',
                    subtitle: 'Включить темный режим',
                    trailing: Switch(
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() => _darkModeEnabled = value);
                      },
                      activeColor: AppTheme.primary,
                    ),
                  ),
                  const _SettingsItem(
                    icon: Icons.language,
                    title: 'Язык',
                    subtitle: 'Русский',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Security Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _SettingsSection(
                title: 'Безопасность',
                children: [
                  _SettingsItem(
                    icon: Icons.fingerprint,
                    title: 'Биометрия',
                    subtitle: 'Face ID/Touch ID',
                    trailing: Switch(
                      value: _biometricsEnabled,
                      onChanged: (value) {
                        setState(() => _biometricsEnabled = value);
                      },
                      activeColor: AppTheme.primary,
                    ),
                  ),
                  const _SettingsItem(
                    icon: Icons.lock,
                    title: 'Смена пароля',
                    subtitle: 'Обновить пароль',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Support Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _SettingsSection(
                title: 'Поддержка',
                children: [
                  _SettingsItem(
                    icon: Icons.help,
                    title: 'Помощь',
                    subtitle: 'FAQ и инструкции',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  _SettingsItem(
                    icon: Icons.support_agent,
                    title: 'Служба поддержки',
                    subtitle: 'Чат с оператором',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  _SettingsItem(
                    icon: Icons.description,
                    title: 'Условия использования',
                    subtitle: 'Правила и политика',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // App Info
            FadeTransition(
              opacity: _fadeAnimation,
              child: const _SettingsSection(
                title: 'О приложении',
                children: [
                  _SettingsItem(
                    icon: Icons.info,
                    title: 'Версия',
                    subtitle: '1.0.0',
                    trailing: SizedBox(),
                  ),
                  _SettingsItem(
                    icon: Icons.update,
                    title: 'Обновления',
                    subtitle: 'Доступна последняя версия',
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Logout Button
            FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Выйти из аккаунта'),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.dark,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppTheme.border, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children
                .map((child) => Container(
                      decoration: BoxDecoration(
                        border: child != children.last
                            ? const Border(
                                bottom: BorderSide(color: AppTheme.border, width: 1),
                              )
                            : null,
                      ),
                      child: child,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primary.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.gray,
        ),
      ),
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        // TODO: Handle tap
      },
    );
  }
}