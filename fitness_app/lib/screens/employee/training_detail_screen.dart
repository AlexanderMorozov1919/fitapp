import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import '../../services/mock_data_service.dart';
import '../../services/custom_notification_service.dart';
import '../../models/notification_model.dart';
import '../../widgets/products_section_widget.dart';

class TrainingDetailScreen extends StatefulWidget {
  final Booking training;
  final VoidCallback? onTrainingUpdated;

  const TrainingDetailScreen({
    super.key,
    required this.training,
    this.onTrainingUpdated,
  });

  @override
  State<TrainingDetailScreen> createState() => _TrainingDetailScreenState();
}

class _TrainingDetailScreenState extends State<TrainingDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Детали тренировки'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка с основной информацией
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Иконка типа тренировки
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.training.status).withOpacity(0.1),
                          borderRadius: AppStyles.borderRadiusLg,
                        ),
                        child: Icon(
                          _getTrainingIcon(widget.training),
                          size: 24,
                          color: _getStatusColor(widget.training.status),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Основная информация
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.training.title,
                              style: AppTextStyles.headline6.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getTrainingTypeText(widget.training.type),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Статус
                      StatusBadge(
                        text: _getStatusText(widget.training.status),
                        color: _getStatusColor(widget.training.status),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Разделитель
                  Container(
                    height: 1,
                    color: AppColors.border,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Детальная информация
                  _buildInfoItem(
                    icon: Icons.calendar_today,
                    title: 'Дата и время',
                    value: '${DateFormatters.formatDate(widget.training.startTime)}, '
                          '${DateFormatters.formatTimeRangeRussian(widget.training.startTime, widget.training.endTime)}',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoItem(
                    icon: Icons.person,
                    title: 'Клиент',
                    value: widget.training.clientName ?? 'Не указан',
                  ),
                  
                  if (widget.training.description != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      icon: Icons.description,
                      title: 'Описание',
                      value: widget.training.description!,
                    ),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoItem(
                    icon: Icons.attach_money,
                    title: 'Стоимость',
                    value: '${widget.training.price} ₽',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Действия
            Text(
              'Действия',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            if (widget.training.status == BookingStatus.confirmed) ...[
              _buildActionButton(
                icon: Icons.edit,
                text: 'Редактировать тренировку',
                onPressed: () {
                  _navigateToEditTraining();
                },
              ),
              const SizedBox(height: 8),
            ],
            
            if (widget.training.status == BookingStatus.awaitingPayment) ...[
              _buildActionButton(
                icon: Icons.check,
                text: 'Подтвердить тренировку',
                onPressed: () {
                  _confirmTraining();
                },
              ),
              const SizedBox(height: 8),
            ],
            
            if (widget.training.status == BookingStatus.confirmed) ...[
              _buildActionButton(
                icon: Icons.cancel,
                text: 'Отменить тренировку',
                onPressed: () {
                  _navigateToCancelTraining();
                },
                isDestructive: true,
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                icon: Icons.schedule,
                text: 'Перенести занятие',
                onPressed: () {
                  _navigateToRescheduleTraining();
                },
              ),
              const SizedBox(height: 8),
            ],
            
            _buildActionButton(
              icon: Icons.chat,
              text: 'Написать клиенту',
              onPressed: () {
                _navigateToChat();
              },
            ),
            
            const SizedBox(height: 20),
            
            // Дополнительная информация
            Text(
              'Дополнительная информация',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            AppCard(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdditionalInfoItem(
                    title: 'ID тренировки',
                    value: widget.training.id,
                  ),
                  const SizedBox(height: 8),
                  _buildAdditionalInfoItem(
                    title: 'Создано',
                    value: DateFormatters.formatDateTime(widget.training.createdAt),
                  ),
                  const SizedBox(height: 8),
                  _buildAdditionalInfoItem(
                    title: 'Продолжительность',
                    value: '${widget.training.endTime.difference(widget.training.startTime).inMinutes} минут',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Секция товаров
            ProductsSectionWidget(products: widget.training.products),
          ],
        ),
      ),
    );
  }

  void _navigateToEditTraining() {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('edit_training', {
      'training': widget.training,
    });
  }

  void _navigateToCancelTraining() {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('cancel_training', {
      'training': widget.training,
    });
  }

  void _navigateToRescheduleTraining() {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('reschedule_training', {
      'training': widget.training,
    });
  }

  void _navigateToChat() {
    final chat = MockDataService.findClientAndCreateChat(widget.training.userId);
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('employee_chat', {
      'chat': chat,
      'contactId': widget.training.userId,
      'contactName': widget.training.clientName ?? 'Клиент',
    });
  }

  void _confirmTraining() {
    MockDataService.updateEmployeeTrainingStatus(
      widget.training.id,
      BookingStatus.confirmed,
    );
    
    // Показываем уведомление об успехе
    CustomNotificationService.showNotification(
      AppNotification(
        id: 'training_confirmed_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Тренировка подтверждена',
        message: 'Тренировка "${widget.training.title}" подтверждена',
        type: NotificationType.success,
        timestamp: DateTime.now(),
      ),
    );
    
    // Обновляем экран
    if (widget.onTrainingUpdated != null) {
      widget.onTrainingUpdated!();
    }
    
    // Переходим на главный экран после подтверждения
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateToHome();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }


  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: Icon(
          icon,
          size: 20,
          color: isDestructive ? AppColors.error : AppColors.primary,
        ),
        label: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDestructive ? AppColors.error : AppColors.primary,
          ),
        ),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: AppStyles.paddingLg,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadiusLg,
            side: BorderSide(
              color: isDestructive ? AppColors.error : AppColors.border,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoItem({
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  IconData _getTrainingIcon(Booking training) {
    switch (training.type) {
      case BookingType.tennisCourt:
        return Icons.sports_tennis;
      case BookingType.groupClass:
        return Icons.group;
      case BookingType.personalTraining:
        return Icons.person;
      default:
        return Icons.fitness_center;
    }
  }

  String _getTrainingTypeText(BookingType type) {
    switch (type) {
      case BookingType.tennisCourt:
        return 'Теннисный корт';
      case BookingType.groupClass:
        return 'Групповое занятие';
      case BookingType.personalTraining:
        return 'Персональная тренировка';
      default:
        return 'Тренировка';
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.awaitingPayment:
        return AppColors.warning;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.completed:
        return AppColors.info;
      case BookingStatus.pending:
        return AppColors.warning;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Подтверждено';
      case BookingStatus.awaitingPayment:
        return 'Ожидает оплаты';
      case BookingStatus.cancelled:
        return 'Отменено';
      case BookingStatus.completed:
        return 'Завершено';
      case BookingStatus.pending:
        return 'Ожидание';
    }
  }
}