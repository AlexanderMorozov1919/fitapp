import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/trainer_model.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../utils/formatters.dart';
import 'calendar_filter.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'Все';
  String _selectedLevel = 'Все';
  bool _showFilters = false;

  final List<String> _classTypes = ['Все', 'Йога', 'Кардио', 'Силовые', 'Теннис'];
  final List<String> _classLevels = ['Все', 'Начинающий', 'Средний', 'Продвинутый'];

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _filterClasses();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Расписание занятий',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Фильтры
          _buildFilters(),
          
          
          // Список занятий
          Expanded(
            child: filteredClasses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: AppStyles.paddingLg,
                    itemCount: filteredClasses.length,
                    itemBuilder: (context, index) {
                      return _buildClassCard(filteredClasses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<GroupClass> _filterClasses() {
    return MockDataService.groupClasses.where((classItem) {
      final isDateMatch = classItem.startTime.year == _selectedDate.year &&
                         classItem.startTime.month == _selectedDate.month &&
                         classItem.startTime.day == _selectedDate.day;
      
      final isTypeMatch = _selectedType == 'Все' || classItem.type == _selectedType;
      final isLevelMatch = _selectedLevel == 'Все' || classItem.level == _selectedLevel;
      
      return isDateMatch && isTypeMatch && isLevelMatch;
    }).toList();
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Календарный фильтр как в "Мои записи"
        CalendarFilter(
          selectedDate: _selectedDate,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
          datesWithBookings: _getDatesWithClasses(),
        ),
        
        // Кнопка показа/скрытия фильтров
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusLg,
                boxShadow: AppColors.shadowSm,
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _showFilters ? 'Скрыть фильтры' : 'Показать фильтры',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Фильтры по типу и уровню (скрыты по умолчанию)
        if (_showFilters) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppColors.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Фильтр по типу - горизонтальный скролл
                Text(
                  'Тип занятия:',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _classTypes.map((type) {
                      final isSelected = _selectedType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = type;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.background,
                              borderRadius: AppStyles.borderRadiusFull,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              type,
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Фильтр по уровню - горизонтальный скролл
                Text(
                  'Уровень:',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _classLevels.map((level) {
                      final isSelected = _selectedLevel == level;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedLevel = level;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.secondary : AppColors.background,
                              borderRadius: AppStyles.borderRadiusFull,
                              border: Border.all(
                                color: isSelected ? AppColors.secondary : AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              level,
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }


  Widget _buildClassCard(GroupClass classItem) {
    final isFull = classItem.isFull;
    final canBook = classItem.isAvailable && !isFull;
    final availableSpots = classItem.maxParticipants - classItem.currentParticipants;
    final isAlmostFull = availableSpots <= 2;

    Color statusColor;
    if (isFull) {
      statusColor = AppColors.error;
    } else if (isAlmostFull) {
      statusColor = AppColors.warning;
    } else {
      statusColor = AppColors.success;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _navigateToClassDetail(classItem),
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
                        classItem.name,
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
                  '${_formatTime(classItem.startTime)}-${_formatTime(classItem.endTime)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Информация о классе
          Text(
            '${classItem.type} • ${classItem.level} • ${classItem.trainerName}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            classItem.description,
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
              // Локация
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    classItem.location,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Участники
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${classItem.currentParticipants}/${classItem.maxParticipants}',
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
                  color: statusColor.withOpacity(0.1),
                  borderRadius: AppStyles.borderRadiusSm,
                ),
                child: Text(
                  isFull ? 'Нет мест' : '$availableSpots мест',
                  style: AppTextStyles.overline.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Цена и кнопка записи
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                classItem.price > 0 ? '${classItem.price} ₽' : 'Бесплатно',
                style: AppTextStyles.price.copyWith(
                  fontSize: 18,
                ),
              ),
              
              ElevatedButton(
               onPressed: canBook ? () => _selectClass(classItem) : null,
               style: AppStyles.primaryButtonStyle.copyWith(
                 backgroundColor: MaterialStateProperty.all(
                   canBook ? AppColors.primary : AppColors.textTertiary,
                 ),
               ),
               child: Text(
                 isFull ? 'Мест нет' : 'Записаться',
                 style: AppTextStyles.buttonSmall,
               ),
             ),
            ],
          ),
        ],
      ),
      ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppStyles.paddingLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Занятий на выбранную дату нет',
              style: AppTextStyles.headline5.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте выбрать другую дату или изменить фильтры',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  void _selectClass(GroupClass classItem) {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('class_detail', classItem);
  }

  void _navigateToClassDetail(GroupClass classItem) {
    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('class_detail', classItem);
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Сегодня';
    } else if (date.year == tomorrow.year &&
               date.month == tomorrow.month &&
               date.day == tomorrow.day) {
      return 'Завтра';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  List<DateTime> _getDatesWithClasses() {
    final dates = <DateTime>{};
    for (final classItem in MockDataService.groupClasses) {
      final date = DateTime(
        classItem.startTime.year,
        classItem.startTime.month,
        classItem.startTime.day,
      );
      dates.add(date);
    }
    return dates.toList()..sort();
  }

  String _formatTime(DateTime time) {
    return DateFormatters.formatTimeRussian(time);
  }
}