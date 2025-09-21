import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/free_time_card.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import 'training_detail_screen.dart';
import '../clietnt/calendar_filter.dart';
import 'create_training_screen.dart';

class EmployeeScheduleScreen extends StatefulWidget {
  const EmployeeScheduleScreen({super.key});

  @override
  State<EmployeeScheduleScreen> createState() => _EmployeeScheduleScreenState();
}

class _EmployeeScheduleScreenState extends State<EmployeeScheduleScreen> {
  String _selectedFilter = 'Все';
  DateTime _selectedDate = DateTime.now();

  final List<String> _filters = ['Все', 'Предстоящие', 'Завершенные', 'Отмененные'];

  @override
  Widget build(BuildContext context) {
    final filteredTrainings = _filterTrainings();
    final datesWithTrainings = _getDatesWithTrainings();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Мое расписание',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Календарный фильтр
          CalendarFilter(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            datesWithBookings: datesWithTrainings,
          ),
          
          // Фильтры - горизонтальный скролл
          Container(
            padding: AppStyles.paddingLg,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppColors.shadowSm,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChipWidget(
                      label: filter,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Список тренировок и свободного времени
          Expanded(
            child: _buildScheduleWithFreeTime(filteredTrainings),
          ),
        ],
      ),
    );
  }

  List<Booking> _filterTrainings() {
    return MockDataService.employeeTrainings.where((training) {
      // Фильтр по дате
      final isDateMatch = training.startTime.year == _selectedDate.year &&
          training.startTime.month == _selectedDate.month &&
          training.startTime.day == _selectedDate.day;
      
      if (!isDateMatch) return false;
      
      // Фильтр по статусу
      switch (_selectedFilter) {
        case 'Предстоящие':
          return training.isUpcoming;
        case 'Завершенные':
          return training.status == BookingStatus.completed;
        case 'Отмененные':
          return training.status == BookingStatus.cancelled;
        default:
          return true;
      }
    }).toList();
  }

  List<DateTime> _getDatesWithTrainings() {
    final dates = <DateTime>[];
    for (final training in MockDataService.employeeTrainings) {
      final date = DateTime(
        training.startTime.year,
        training.startTime.month,
        training.startTime.day,
      );
      if (!dates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day)) {
        dates.add(date);
      }
    }
    return dates;
  }

  Widget _buildScheduleWithFreeTime(List<Booking> trainings) {
    if (trainings.isEmpty) {
      return _buildEmptyState();
    }

    // Получаем свободное время
    final freeTimeSlots = MockDataService.getEmployeeFreeTimeSlots(_selectedDate);
    
    // Создаем объединенный список тренировок и свободного времени
    final allItems = <_ScheduleItem>[];
    
    // Добавляем тренировки
    for (final training in trainings) {
      allItems.add(_ScheduleItem(type: _ItemType.training, training: training));
    }
    
    // Добавляем свободное время
    for (final freeTime in freeTimeSlots) {
      allItems.add(_ScheduleItem(type: _ItemType.freeTime, freeTime: freeTime));
    }
    
    // Сортируем по времени начала
    allItems.sort((a, b) {
      final aTime = a.type == _ItemType.training ? a.training!.startTime : a.freeTime!.startTime;
      final bTime = b.type == _ItemType.training ? b.training!.startTime : b.freeTime!.startTime;
      return aTime.compareTo(bTime);
    });

    return ListView.builder(
      padding: AppStyles.paddingLg,
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: item.type == _ItemType.training
              ? _buildTrainingItem(item.training!)
              : FreeTimeCard(
                  freeTimeSlot: item.freeTime!,
                  onTap: () => _navigateToCreateTraining(item.freeTime!),
                ),
        );
      },
    );
  }

  void _navigateToCreateTraining(FreeTimeSlot freeTimeSlot) {
    final now = DateTime.now();
    
    // Проверяем, что слот не прошел
    if (freeTimeSlot.endTime.isBefore(now)) {
      showErrorSnackBar(context, 'Это время уже прошло. Выберите другое свободное время.');
      return;
    }
    
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('create_training', freeTimeSlot);
    } else {
      // Альтернативная навигация для случаев, когда NavigationService недоступен
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateTrainingScreen(
            freeTimeSlot: freeTimeSlot,
          ),
        ),
      );
    }
  }

  Widget _buildTrainingItem(Booking training) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _navigateToTrainingDetail(training),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: AppStyles.paddingLg,
          decoration: AppStyles.elevatedCardDecoration.copyWith(
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок и время с индикатором кликабельности
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            training.title,
                            style: AppTextStyles.headline6.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: AppStyles.borderRadiusLg,
                    ),
                    child: Text(
                      '${DateFormatters.formatTimeRangeRussian(training.startTime, training.endTime)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Информация о тренировке
              Text(
                _getTrainingDetails(training),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 8),
              
              if (training.description != null)
                Text(
                  training.description!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: 12),
              
              // Детали и статус
              Row(
                children: [
                  // Дата
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatters.formatDate(training.startTime),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Статус
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(training.status).withOpacity(0.1),
                      borderRadius: AppStyles.borderRadiusSm,
                    ),
                    child: Text(
                      _getStatusText(training.status),
                      style: AppTextStyles.overline.copyWith(
                        color: _getStatusColor(training.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Клиент и действия
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Клиент
                  if (training.clientName != null)
                    Text(
                      'Клиент: ${training.clientName}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  
                ],
              ),
              
              // Дополнительная информация
              if (training.courtNumber != null ||
                  training.trainerId != null ||
                  training.className != null ||
                  training.lockerNumber != null) ...[
                
                if (training.courtNumber != null)
                  _buildDetailItem('Корт:', training.courtNumber!),
                if (training.lockerNumber != null)
                  _buildDetailItem('Шкафчик:', training.lockerNumber!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _getTrainingDetails(Booking training) {
    final details = <String>[];
    
    switch (training.type) {
      case BookingType.tennisCourt:
        details.add('Теннисный корт');
        break;
      case BookingType.groupClass:
        details.add('Групповое занятие');
        break;
      case BookingType.personalTraining:
        details.add('Персональная тренировка');
        break;
      case BookingType.locker:
        details.add('Аренда шкафчика');
        break;
    }
    
    if (training.clientName != null) {
      details.add('Клиент: ${training.clientName}');
    }
    
    return details.join(' • ');
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.calendar_today,
      title: _getEmptyStateMessage(),
      subtitle: _getEmptyStateSubtitle(),
    );
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'Предстоящие':
        return 'Нет предстоящих тренировок';
      case 'Завершенные':
        return 'Нет завершенных тренировок';
      case 'Отмененные':
        return 'Нет отмененных тренировок';
      default:
        return 'У вас пока нет тренировок';
    }
  }

  String _getEmptyStateSubtitle() {
    switch (_selectedFilter) {
      case 'Предстоящие':
        return 'Здесь будут отображаться ваши предстоящие тренировки';
      case 'Завершенные':
        return 'Здесь будут отображаться ваши завершенные занятия';
      case 'Отмененные':
        return 'Здесь будут отображаться отмененные тренировки';
      default:
        return 'Начните планировать свои тренировки';
    }
  }

  void _cancelTraining(Booking training) {
    showConfirmDialog(
      context: context,
      title: 'Отмена тренировки',
      content: 'Вы уверены, что хотите отменить эту тренировку?',
      confirmText: 'Да, отменить',
      confirmColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        // Используем метод MockDataService для отмены тренировки
        MockDataService.updateEmployeeTrainingStatus(
          training.id,
          BookingStatus.cancelled,
          cancellationReason: 'Отменено сотрудником'
        );
        
        _showCancellationSuccess();
        setState(() {}); // Обновляем UI
      }
    });
  }

  void _confirmTraining(Booking training) {
    showSuccessSnackBar(context, 'Тренировка успешно подтверждена');
  }

  void _showCancellationSuccess() {
    showSuccessSnackBar(context, 'Тренировка успешно отменена');
  }

  String _getTrainerName(String trainerId) {
    final trainer = MockDataService.trainers
        .firstWhere((t) => t.id == trainerId, orElse: () => MockDataService.trainers.first);
    return trainer.fullName;
  }

  void _navigateToTrainingDetail(Booking training) {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('training_detail', training);
    } else {
      // Альтернативная навигация для случаев, когда NavigationService недоступен
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrainingDetailScreen(training: training),
        ),
      );
    }
  }

  IconData _getTrainingIcon(Booking training) {
    switch (training.type) {
      case BookingType.tennisCourt:
        return Icons.sports_tennis;
      case BookingType.groupClass:
        return Icons.group;
      case BookingType.personalTraining:
        return Icons.person;
      case BookingType.locker:
        return Icons.lock;
      default:
        return Icons.calendar_today;
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.awaitingPayment:
        return AppColors.warning;
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.completed:
        return AppColors.info;
      case BookingStatus.awaitingPayment:
        return Colors.orange;
    }
    return AppColors.textTertiary;
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Подтверждено';
      case BookingStatus.awaitingPayment:
        return 'Ожидает оплаты';
      case BookingStatus.pending:
        return 'Ожидание';
      case BookingStatus.cancelled:
        return 'Отменено';
      case BookingStatus.completed:
        return 'Завершено';
      case BookingStatus.awaitingPayment:
        return 'Ожидает оплаты';
    }
    return 'Неизвестно';
  }
}

enum _ItemType { training, freeTime }

class _ScheduleItem {
  final _ItemType type;
  final Booking? training;
  final FreeTimeSlot? freeTime;

  _ScheduleItem({
    required this.type,
    this.training,
    this.freeTime,
  });
}