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
          'Бронирование корта',
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
      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              padding: AppStyles.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Выбор клиента
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
                        const SizedBox(height: 8),
                        _buildClientSelector(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Выбор корта
                  AppCard(
                    padding: AppStyles.paddingLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Выберите корт:',
                          style: AppTextStyles.headline6.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        ...MockDataService.tennisCourts.map((court) {
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 80), // Отступ для кнопки
                ],
              ),
            ),
          ),
        ],
      ),
      // Кнопка продолжения внизу экрана
      bottomNavigationBar: _selectedCourt != null && _selectedClient != null
          ? Container(
              padding: AppStyles.paddingLg,
              color: Colors.white,
              child: PrimaryButton(
                text: 'Выбрать время',
                onPressed: _navigateToTimeSelection,
              ),
            )
          : null,
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

  @override
  void dispose() {
    _clientSearchController.dispose();
    super.dispose();
  }
}