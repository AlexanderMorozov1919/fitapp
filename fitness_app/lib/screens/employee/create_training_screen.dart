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
  final User? preselectedClient;

  const CreateTrainingScreen({
    super.key,
    required this.freeTimeSlot,
    this.preselectedClient,
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
    
    // Устанавливаем предварительно выбранного клиента, если он передан
    if (widget.preselectedClient != null) {
      _selectedClient = widget.preselectedClient;
    }
    
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
              AppCard(
                padding: AppStyles.paddingLg,
                child: _buildTimeInfo(),
              ),
              const SizedBox(height: 20),

              // Тип тренировки
              AppCard(
                padding: AppStyles.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тип тренировки',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTypeSelector(),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Продолжительность
              AppCard(
                padding: AppStyles.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Продолжительность',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDurationSelector(),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Информация о предварительно выбранном клиенте или выбор клиента
              if (widget.preselectedClient != null) ...[
                AppCard(
                  padding: AppStyles.paddingLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Клиент',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: AppStyles.paddingMd,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: AppStyles.borderRadiusLg,
                          border: Border.all(color: AppColors.success.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.person,
                                color: AppColors.success,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.preselectedClient!.firstName} ${widget.preselectedClient!.lastName}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.preselectedClient!.phone,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                AppCard(
                  padding: AppStyles.paddingLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Клиент',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildClientSelector(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Описание (опционально)
              AppCard(
                padding: AppStyles.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Описание (необязательно)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                        filled: true,
                        fillColor: AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Кнопка создания
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Создать тренировку',
                  onPressed: _createTraining,
                ),
              ),
              const SizedBox(height: 20),
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
            '${DateFormatters.formatTimeRangeRussian(widget.freeTimeSlot.startTime, widget.freeTimeSlot.endTime)}',
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
        // Красивое поле выбора типа тренировки
        GestureDetector(
          onTap: () => setState(() => _isTypeDropdownOpen = !_isTypeDropdownOpen),
          child: Container(
            padding: AppStyles.paddingMd,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppStyles.borderRadiusLg,
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.shadowSm,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getTypeIcon(_selectedType),
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getTypeName(_selectedType),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
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

        // Выпадающий список типов тренировок
        if (_isTypeDropdownOpen) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppStyles.borderRadiusLg,
              boxShadow: AppColors.shadowLg,
            ),
            child: Column(
              children: BookingType.values.map((type) {
                final isSelected = type == _selectedType;
                return ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      _getTypeIcon(type),
                      size: 18,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                  title: Text(
                    _getTypeName(type),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                      _isTypeDropdownOpen = false;
                    });
                  },
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
        color: Colors.white,
        borderRadius: AppStyles.borderRadiusLg,
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        children: availableDurations.map((duration) {
          final isSelected = duration == _selectedDuration;
          return ListTile(
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.timer,
                size: 18,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
            title: Text(
              '$duration минут',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 20,
                  )
                : null,
            onTap: () {
              setState(() {
                _selectedDuration = duration;
                _selectedEndTime = _selectedStartTime.add(Duration(minutes: duration));
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClientSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Красивое поле выбора клиента
        GestureDetector(
          onTap: () => setState(() => _isClientDropdownOpen = !_isClientDropdownOpen),
          child: Container(
            padding: AppStyles.paddingMd,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppStyles.borderRadiusLg,
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.shadowSm,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
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
                  child: _selectedClient != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_selectedClient!.firstName} ${_selectedClient!.lastName}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _selectedClient!.phone,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
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

        // Выпадающий список клиентов
        if (_isClientDropdownOpen) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppStyles.borderRadiusLg,
              boxShadow: AppColors.shadowLg,
            ),
            child: Column(
              children: [
                // Поле поиска
                Padding(
                  padding: AppStyles.paddingMd,
                  child: TextFormField(
                    controller: _clientSearchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск по имени или телефону...',
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: AppStyles.borderRadiusMd,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                
                // Список клиентов
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = _filteredClients[index];
                      final isSelected = client == _selectedClient;
                      return ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                        title: Text(
                          '${client.firstName} ${client.lastName}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          client.phone,
                          style: AppTextStyles.caption.copyWith(
                            color: isSelected ? AppColors.primary.withOpacity(0.8) : AppColors.textSecondary,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 20,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedClient = client;
                            _isClientDropdownOpen = false;
                            _clientSearchController.clear();
                          });
                        },
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

      // Проверка на прошедшее время
      if (_selectedStartTime.isBefore(DateTime.now())) {
        showErrorSnackBar(context, 'Невозможно создать тренировку на прошедшее время');
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
      
      showSuccessSnackBar(context, 'Тренировка успешно создана!');
      
      // Переходим на главный экран после создания тренировки
      final navigationService = NavigationService.of(context);
      if (navigationService != null) {
        navigationService.navigateToHome();
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
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