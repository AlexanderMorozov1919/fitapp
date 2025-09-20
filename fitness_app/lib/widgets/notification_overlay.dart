import 'package:flutter/material.dart';
import 'package:fitness_app/theme/app_colors.dart';
import 'package:fitness_app/theme/app_styles.dart';
import 'package:fitness_app/theme/app_text_styles.dart';
import 'package:fitness_app/models/notification_model.dart';
import 'package:fitness_app/services/custom_notification_service.dart';

class NotificationOverlay extends StatefulWidget {
  final AppNotification notification;
  final VoidCallback onDismiss;
  final Duration displayDuration;

  const NotificationOverlay({
    super.key,
    required this.notification,
    required this.onDismiss,
    this.displayDuration = const Duration(seconds: 3),
  });

  @override
  State<NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Запускаем анимацию появления
    _controller.forward();

    // Устанавливаем таймер для автоматического скрытия
    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppStyles.borderRadiusLg,
                  boxShadow: AppColors.shadowLg,
                  border: Border.all(
                    color: widget.notification.typeColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Акцентная полоса слева
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: widget.notification.typeColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Иконка уведомления
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: widget.notification.typeColor.withOpacity(0.1),
                              borderRadius: AppStyles.borderRadiusFull,
                            ),
                            child: Icon(
                              widget.notification.typeIcon,
                              color: widget.notification.typeColor,
                              size: 20,
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Контент уведомления
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Заголовок и тип
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.notification.title,
                                        style: AppTextStyles.headline6.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: widget.notification.typeColor.withOpacity(0.1),
                                        borderRadius: AppStyles.borderRadiusSm,
                                      ),
                                      child: Text(
                                        widget.notification.typeText,
                                        style: AppTextStyles.caption.copyWith(
                                          color: widget.notification.typeColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 4),
                                
                                // Сообщение
                                Text(
                                  widget.notification.message,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Время
                                Text(
                                  _formatTime(widget.notification.timestamp),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Кнопка закрытия
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: AppColors.textTertiary,
                            ),
                            onPressed: _dismiss,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'Только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч назад';
    } else {
      return '${difference.inDays} дн назад';
    }
  }
}

class NotificationOverlayManager extends StatefulWidget {
  final Widget child;
  
  const NotificationOverlayManager({super.key, required this.child});

  @override
  State<NotificationOverlayManager> createState() => _NotificationOverlayManagerState();
}

class _NotificationOverlayManagerState extends State<NotificationOverlayManager> {
  final List<AppNotification> _notifications = [];
  
  void showNotification(AppNotification notification) {
    setState(() {
      _notifications.add(notification);
    });
    
    // Автоматическое удаление через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _notifications.remove(notification);
        });
      }
    });
  }

  void _removeNotification(AppNotification notification) {
    setState(() {
      _notifications.remove(notification);
    });
  }

  @override
  void initState() {
    super.initState();
    // Инициализируем сервис уведомлений
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomNotificationService.initialize(showNotification);
    });
  }

  @override
  void dispose() {
    CustomNotificationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        // Уведомления поверх всего контента
        ..._notifications.map((notification) => Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: NotificationOverlay(
            notification: notification,
            onDismiss: () => _removeNotification(notification),
          ),
        )).toList(),
      ],
    );
  }
}