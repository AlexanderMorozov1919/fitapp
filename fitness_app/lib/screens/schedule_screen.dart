import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/trainer_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'Все';
  String _selectedLevel = 'Все';

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
          
          // Дата
          _buildDateSelector(),
          
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppColors.shadowSm,
      ),
      child: Row(
        children: [
          // Фильтр по типу
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Тип занятия',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppStyles.borderRadiusLg,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: _classTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: AppTextStyles.bodySmall,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      isDense: true,
                    ),
                    style: AppTextStyles.bodySmall,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Фильтр по уровню
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Уровень',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppStyles.borderRadiusLg,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLevel,
                    items: _classLevels.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(
                          level,
                          style: AppTextStyles.bodySmall,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLevel = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      isDense: true,
                    ),
                    style: AppTextStyles.bodySmall,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: AppColors.primary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: AppStyles.borderRadiusLg,
            ),
            child: Text(
              _formatDate(_selectedDate),
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: AppColors.primary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: AppStyles.paddingLg,
      decoration: AppStyles.elevatedCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок и время
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onPressed: canBook ? () => _bookClass(classItem) : null,
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

  void _bookClass(GroupClass classItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Запись на занятие',
          style: AppTextStyles.headline5,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Занятие: ${classItem.name}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Время: ${_formatTime(classItem.startTime)}-${_formatTime(classItem.endTime)}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Тренер: ${classItem.trainerName}',
              style: AppTextStyles.bodyMedium,
            ),
            if (classItem.price > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Стоимость: ${classItem.price} ₽',
                style: AppTextStyles.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Подтвердить запись?',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showBookingSuccess(classItem);
            },
            style: AppStyles.primaryButtonStyle,
            child: const Text('Записаться'),
          ),
        ],
      ),
    );
  }

  void _showBookingSuccess(GroupClass classItem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Вы записаны на "${classItem.name}"!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.borderRadiusLg,
        ),
      ),
    );
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

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}