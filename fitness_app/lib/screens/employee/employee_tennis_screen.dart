import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/booking_model.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';

class EmployeeTennisScreen extends StatefulWidget {
  const EmployeeTennisScreen({super.key});

  @override
  State<EmployeeTennisScreen> createState() => _EmployeeTennisScreenState();
}

class _EmployeeTennisScreenState extends State<EmployeeTennisScreen> {
  TennisCourt? _selectedCourt;
  User? _selectedClient;
  final _clientSearchController = TextEditingController();
  List<User> _filteredClients = [];
  bool _isClientDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredClients = MockDataService.clients;
    _clientSearchController.addListener(() {
      _filterClients(_clientSearchController.text);
    });
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

  void _navigateBack() {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.onBack();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _navigateToTimeSelection() {
    if (_selectedCourt == null) {
      showErrorSnackBar(context, 'Пожалуйста, выберите корт');
      return;
    }
    if (_selectedClient == null) {
      showErrorSnackBar(context, 'Пожалуйста, выберите клиента');
      return;
    }

    final navigationService = NavigationService.of(context);
    navigationService?.navigateTo('employee_tennis_time_selection', {
      'court': _selectedCourt,
      'client': _selectedClient,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Бронирование теннисного корта',
          style: AppTextStyles.headline5,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateBack,
        ),
      ),
      body: Padding(
        padding: AppStyles.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // Выбор корта
            Text(
              'Выберите корт для бронирования:',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView(
                children: MockDataService.tennisCourts.map((court) {
                  final isSelected = court == _selectedCourt;
                  final isAvailable = court.isAvailable;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: AppStyles.elevatedCardDecoration.copyWith(
                      color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.sports_tennis,
                        color: isAvailable ? AppColors.success : AppColors.textTertiary,
                        size: 24,
                      ),
                      title: Text(
                        court.number,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isAvailable ? AppColors.textPrimary : AppColors.textTertiary,
                        ),
                      ),
                      subtitle: Text(
                        '${court.surfaceType} • ${court.isIndoor ? 'Крытый' : 'Открытый'} • ${court.pricePerHour.toInt()} ₽/час',
                        style: AppTextStyles.caption.copyWith(
                          color: isAvailable ? AppColors.textSecondary : AppColors.error,
                        ),
                      ),
                      trailing: isAvailable
                          ? Icon(
                              Icons.chevron_right,
                              color: AppColors.textTertiary,
                            )
                          : Text(
                              'Занят',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                _selectedCourt = court;
                              });
                            }
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            
            if (_selectedCourt != null && _selectedClient != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToTimeSelection,
                  style: AppStyles.primaryButtonStyle.copyWith(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  child: Text(
                    'Выбрать время',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
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

  @override
  void dispose() {
    _clientSearchController.dispose();
    super.dispose();
  }
}