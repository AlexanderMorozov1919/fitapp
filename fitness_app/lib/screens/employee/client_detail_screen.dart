import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import 'employee_chat_screen.dart';

class ClientDetailScreen extends StatefulWidget {
  final User client;

  const ClientDetailScreen({super.key, required this.client});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  void _startChatWithClient() {
    final contactId = 'client_${widget.client.id}';
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('employee_chat', {
        'contactId': contactId,
        'contactName': widget.client.fullName,
        'contactAvatar': widget.client.photoUrl,
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeChatScreen(
            contactId: contactId,
            contactName: widget.client.fullName,
            contactAvatar: widget.client.photoUrl,
          ),
        ),
      );
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

  Widget _buildInfoCard(String title, Widget content) {
    return AppCard(
      padding: AppStyles.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildMembershipInfo() {
    final membership = widget.client.membership;
    
    if (membership == null) {
      return Column(
        children: [
          Text(
            'Абонемент отсутствует',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Оформить абонемент',
            onPressed: () {
              // TODO: Реализовать оформление абонемента
              showInfoSnackBar(context, 'Функция оформления абонемента будет доступна в будущем обновлении');
            },
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: membership.isActive ? AppColors.success : AppColors.error,
                borderRadius: AppStyles.borderRadiusSm,
              ),
              child: Text(
                membership.isActive ? 'АКТИВЕН' : 'НЕАКТИВЕН',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              membership.type,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Стоимость', '${membership.price} ₽'),
        _buildInfoRow('Начало', DateFormatters.formatDate(membership.startDate)),
        _buildInfoRow('Окончание', DateFormatters.formatDate(membership.endDate)),
        _buildInfoRow('Осталось дней', membership.daysRemaining.toString()),
        if (membership.remainingVisits > 0)
          _buildInfoRow('Осталось посещений', membership.remainingVisits.toString()),
        const SizedBox(height: 8),
        Text(
          'Включенные услуги: ${membership.includedServices.join(', ')}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.client.fullName,
          style: AppTextStyles.headline6,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: _startChatWithClient,
            tooltip: 'Написать клиенту',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          children: [
            // Аватар и основная информация
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.secondary,
                    child: Text(
                      '${widget.client.firstName[0]}${widget.client.lastName[0]}',
                      style: AppTextStyles.headline4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.client.fullName,
                    style: AppTextStyles.headline5.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.client.phone,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    widget.client.email,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Личная информация
            _buildInfoCard(
              'Личная информация',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Дата рождения', 
                    DateFormatters.formatDate(widget.client.birthDate)),
                  _buildInfoRow('Возраст', 
                    '${DateTime.now().difference(widget.client.birthDate).inDays ~/ 365} лет'),
                  if (widget.client.preferences.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Предпочтения:',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: widget.client.preferences.map((pref) {
                            return Chip(
                              label: Text(pref),
                              backgroundColor: AppColors.secondary.withOpacity(0.1),
                              labelStyle: AppTextStyles.caption.copyWith(
                                color: AppColors.secondary,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Абонемент
            _buildInfoCard(
              'Абонемент',
              _buildMembershipInfo(),
            ),
            const SizedBox(height: 16),

            // Финансовая информация
            _buildInfoCard(
              'Финансы',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Баланс', '${widget.client.balance} ₽'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Пополнить',
                          onPressed: () {
                            // TODO: Реализовать пополнение баланса
                            showInfoSnackBar(context, 'Функция пополнения баланса будет доступна в будущем обновлении');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'История',
                          onPressed: () {
                            // TODO: Реализовать историю платежей
                            showInfoSnackBar(context, 'Функция просмотра истории платежей будет доступна в будущем обновлении');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Действия
            _buildInfoCard(
              'Действия',
              Column(
                children: [
                  PrimaryButton(
                    text: 'Записать на тренировку',
                    onPressed: () {
                      final navigationService = NavigationService.of(context);
                      if (navigationService != null) {
                        navigationService.navigateTo('record_screen', {
                          'preselectedClient': widget.client,
                        });
                      } else {
                        // TODO: Реализовать навигацию на запись
                        showInfoSnackBar(context, 'Функция записи на тренировку будет доступна в будущем обновлении');
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    text: 'Редактировать данные',
                    onPressed: () {
                      // TODO: Реализовать редактирование данных клиента
                      showInfoSnackBar(context, 'Функция редактирования данных клиента будет доступна в будущем обновлении');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}