import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';

class CreateTrainingScreen extends StatefulWidget {
  final FreeTimeSlot freeTimeSlot;
  final VoidCallback onTrainingCreated;

  const CreateTrainingScreen({
    super.key,
    required this.freeTimeSlot,
    required this.onTrainingCreated,
  });

  @override
  State<CreateTrainingScreen> createState() => _CreateTrainingScreenState();
}

class _CreateTrainingScreenState extends State<CreateTrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  BookingType _selectedType = BookingType.personalTraining;
  DateTime _selectedStartTime = DateTime.now();
  DateTime _selectedEndTime = DateTime.now().add(Duration(hours: 1));

  @override
  void initState() {
    super.initState();
    // Устанавливаем время из свободного слота
    _selectedStartTime = widget.freeTimeSlot.startTime;
    _selectedEndTime = widget.freeTimeSlot.endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Создать тренировку',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: AppStyles.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Информация о выбранном времени
              _buildTimeInfo(),
              const SizedBox(height: 24),

              // Тип тренировки
              Text(
                'Тип тренировки',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _buildTypeSelector(),
              const SizedBox(height: 24),

              // Имя клиента
              Text(
                'Имя клиента',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(
                  hintText: 'Введите имя клиента',
                  border: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите имя клиента';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Описание (опционально)
              Text(
                'Описание (необязательно)',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Дополнительная информация о тренировке...',
                  border: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppStyles.borderRadiusMd,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Кнопка создания
              PrimaryButton(
                text: 'Создать тренировку',
                onPressed: _createTraining,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo() {
    return Container(
      padding: AppStyles.paddingLg,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: AppStyles.borderRadiusLg,
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Выбранное время',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.freeTimeSlot.formattedTime,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppStyles.borderRadiusMd,
      ),
      child: Column(
        children: BookingType.values.map((type) {
          final isSelected = type == _selectedType;
          return GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: Container(
              padding: AppStyles.paddingMd,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                border: Border(
                  bottom: type != BookingType.values.last
                      ? BorderSide(color: AppColors.border)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getTypeIcon(type),
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getTypeName(type),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check,
                      color: AppColors.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getTypeIcon(BookingType type) {
    switch (type) {
      case BookingType.tennisCourt:
        return Icons.sports_tennis;
      case BookingType.groupClass:
        return Icons.group;
      case BookingType.personalTraining:
        return Icons.person;
      case BookingType.locker:
        return Icons.lock;
    }
  }

  String _getTypeName(BookingType type) {
    switch (type) {
      case BookingType.tennisCourt:
        return 'Теннисный корт';
      case BookingType.groupClass:
        return 'Групповое занятие';
      case BookingType.personalTraining:
        return 'Персональная тренировка';
      case BookingType.locker:
        return 'Аренда шкафчика';
    }
  }

  void _createTraining() {
    if (_formKey.currentState!.validate()) {
      final newTraining = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: MockDataService.currentUser.id,
        type: _selectedType,
        startTime: _selectedStartTime,
        endTime: _selectedEndTime,
        title: _getTrainingTitle(),
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        status: BookingStatus.confirmed,
        price: 0,
        createdAt: DateTime.now(),
        clientName: _clientNameController.text,
      );

      MockDataService.addEmployeeTraining(newTraining);
      widget.onTrainingCreated();
      
      showSuccessSnackBar(context, 'Тренировка успешно создана!');
      
      // Используем NavigationService для возврата назад
      final navigationService = NavigationService.of(context);
      if (navigationService != null) {
        navigationService.onBack();
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  String _getTrainingTitle() {
    switch (_selectedType) {
      case BookingType.tennisCourt:
        return 'Теннисный корт - ${_clientNameController.text}';
      case BookingType.groupClass:
        return 'Групповое занятие - ${_clientNameController.text}';
      case BookingType.personalTraining:
        return 'Персональная тренировка - ${_clientNameController.text}';
      case BookingType.locker:
        return 'Аренда шкафчика - ${_clientNameController.text}';
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}