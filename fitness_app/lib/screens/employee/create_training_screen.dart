import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../models/user_model.dart';
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
  final _descriptionController = TextEditingController();
  final _clientSearchController = TextEditingController();
  
  BookingType _selectedType = BookingType.personalTraining;
  DateTime _selectedStartTime = DateTime.now();
  DateTime _selectedEndTime = DateTime.now().add(Duration(hours: 1));
  int _selectedDuration = 60; // минут по умолчанию
  User? _selectedClient;

  final List<int> _availableDurations = [30, 45, 60, 90, 120];
  List<User> _filteredClients = [];
  bool _isClientDropdownOpen = false;
  bool _isTypeDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    // Устанавливаем время из свободного слота
    _selectedStartTime = widget.freeTimeSlot.startTime;
    _selectedEndTime = _selectedStartTime.add(Duration(minutes: _selectedDuration));
    _filteredClients = MockDataService.clients;
    
    _clientSearchController.addListener(() {
      _filterClients(_clientSearchController.text);
    });
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

              // Продолжительность
              Text(
                'Продолжительность',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _buildDurationSelector(),
              const SizedBox(height: 24),

              // Выбор клиента
              Text(
                'Клиент',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _buildClientSelector(),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createTraining,
                  style: AppStyles.primaryButtonStyle.copyWith(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  child: Text(
                    'Создать тренировку',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Доступное время',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${DateFormatters.formatTime(widget.freeTimeSlot.startTime)} - ${DateFormatters.formatTime(widget.freeTimeSlot.endTime)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Максимальная продолжительность: ${widget.freeTimeSlot.duration.inMinutes} минут',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isTypeDropdownOpen = !_isTypeDropdownOpen),
          child: Container(
            padding: AppStyles.paddingMd,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppStyles.borderRadiusMd,
            ),
            child: Row(
              children: [
                Icon(
                  _getTypeIcon(_selectedType),
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getTypeName(_selectedType),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  _isTypeDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_isTypeDropdownOpen) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppStyles.borderRadiusMd,
              color: Colors.white,
            ),
            child: Column(
              children: BookingType.values.map((type) {
                final isSelected = type == _selectedType;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                      _isTypeDropdownOpen = false;
                    });
                  },
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
          ),
        ],
      ],
    );
  }

  Widget _buildDurationSelector() {
    final maxDuration = _getMaxAvailableDuration();
    final availableDurations = _availableDurations.where((d) => d <= maxDuration).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppStyles.borderRadiusMd,
      ),
      child: Column(
        children: availableDurations.map((duration) {
          final isSelected = duration == _selectedDuration;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDuration = duration;
                _selectedEndTime = _selectedStartTime.add(Duration(minutes: duration));
              });
            },
            child: Container(
              padding: AppStyles.paddingMd,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                border: Border(
                  bottom: duration != availableDurations.last
                      ? BorderSide(color: AppColors.border)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$duration минут',
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

  Widget _buildClientSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isClientDropdownOpen = !_isClientDropdownOpen),
          child: Container(
            padding: AppStyles.paddingMd,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppStyles.borderRadiusMd,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _selectedClient != null
                      ? Text(
                          '${_selectedClient!.firstName} ${_selectedClient!.lastName}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        )
                      : Text(
                          'Выберите клиента...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                ),
                Icon(
                  _isClientDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_isClientDropdownOpen) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppStyles.borderRadiusMd,
              color: Colors.white,
            ),
            child: Column(
              children: [
                // Поле поиска
                Padding(
                  padding: AppStyles.paddingMd,
                  child: TextFormField(
                    controller: _clientSearchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск клиента...',
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: AppStyles.borderRadiusSm,
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
                const Divider(height: 1),
                // Список клиентов
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = _filteredClients[index];
                      final isSelected = client == _selectedClient;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedClient = client;
                            _isClientDropdownOpen = false;
                            _clientSearchController.clear();
                          });
                        },
                        child: Container(
                          padding: AppStyles.paddingMd,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                            border: Border(
                              bottom: index != _filteredClients.length - 1
                                  ? BorderSide(color: AppColors.border)
                                  : BorderSide.none,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${client.firstName} ${client.lastName}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      client.phone,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
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
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
      if (_selectedClient == null) {
        showErrorSnackBar(context, 'Пожалуйста, выберите клиента');
        return;
      }

      // Проверка доступного времени
      if (!_isTimeSlotAvailable()) {
        showErrorSnackBar(context, 'Выбранное время недоступно. Пожалуйста, выберите другую продолжительность.');
        return;
      }

      final newTraining = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _selectedClient!.id,
        type: _selectedType,
        startTime: _selectedStartTime,
        endTime: _selectedEndTime,
        title: _getTrainingTitle(),
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        status: BookingStatus.confirmed,
        price: 0,
        createdAt: DateTime.now(),
        clientName: '${_selectedClient!.firstName} ${_selectedClient!.lastName}',
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
        return 'Теннисный корт - ${_selectedClient!.firstName} ${_selectedClient!.lastName}';
      case BookingType.groupClass:
        return 'Групповое занятие - ${_selectedClient!.firstName} ${_selectedClient!.lastName}';
      case BookingType.personalTraining:
        return 'Персональная тренировка - ${_selectedClient!.firstName} ${_selectedClient!.lastName}';
      case BookingType.locker:
        return 'Аренда шкафчика - ${_selectedClient!.firstName} ${_selectedClient!.lastName}';
    }
  }

  void _filterClients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClients = MockDataService.clients;
      } else {
        _filteredClients = MockDataService.clients.where((client) {
          final fullName = '${client.firstName} ${client.lastName}'.toLowerCase();
          final phone = client.phone.toLowerCase();
          return fullName.contains(query.toLowerCase()) || phone.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  int _getMaxAvailableDuration() {
    final nextTraining = _getNextTraining();
    if (nextTraining == null) {
      return widget.freeTimeSlot.duration.inMinutes;
    }

    final timeUntilNextTraining = nextTraining.startTime.difference(_selectedStartTime);
    return timeUntilNextTraining.inMinutes;
  }

  Booking? _getNextTraining() {
    final employeeTrainings = MockDataService.employeeTrainings.where((training) {
      return training.startTime.isAfter(_selectedStartTime) &&
             training.startTime.day == _selectedStartTime.day;
    }).toList();

    if (employeeTrainings.isEmpty) {
      return null;
    }

    employeeTrainings.sort((a, b) => a.startTime.compareTo(b.startTime));
    return employeeTrainings.first;
  }

  bool _isTimeSlotAvailable() {
    final nextTraining = _getNextTraining();
    if (nextTraining == null) {
      return true;
    }

    final trainingEndTime = _selectedStartTime.add(Duration(minutes: _selectedDuration));
    return trainingEndTime.isBefore(nextTraining.startTime) ||
           trainingEndTime.isAtSameMomentAs(nextTraining.startTime);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _clientSearchController.dispose();
    super.dispose();
  }
}