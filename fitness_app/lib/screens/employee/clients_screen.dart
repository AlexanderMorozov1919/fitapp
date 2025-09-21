import 'package:flutter/material.dart';
import '../../services/mock_data/client_data.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import '../../main.dart';
import 'add_client_screen.dart';
import 'employee_chat_screen.dart';
import 'client_detail_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _filteredClients = [];

  @override
  void initState() {
    super.initState();
    _filteredClients = clients;
    _searchController.addListener(_filterClients);
  }

  void _filterClients() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredClients = clients;
      });
    } else {
      setState(() {
        _filteredClients = clients.where((client) {
          final fullName = '${client.firstName} ${client.lastName}'.toLowerCase();
          final phone = client.phone.toLowerCase();
          final email = client.email.toLowerCase();
          return fullName.contains(query) || 
                 phone.contains(query) || 
                 email.contains(query);
        }).toList();
      });
    }
  }

  void _navigateToAddClient() {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('add_client');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddClientScreen()),
      );
    }
  }

  void _navigateToClientDetail(User client) {
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('client_detail', client);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClientDetailScreen(client: client),
        ),
      );
    }
  }

  void _startChatWithClient(User client) {
    final contactId = 'client_${client.id}';
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.navigateTo('employee_chat', {
        'contactId': contactId,
        'contactName': '${client.firstName} ${client.lastName}',
        'contactAvatar': client.photoUrl,
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeChatScreen(
            contactId: contactId,
            contactName: '${client.firstName} ${client.lastName}',
            contactAvatar: client.photoUrl,
          ),
        ),
      );
    }
  }

  Widget _buildClientCard(User client) {
    return AppCard(
      padding: AppStyles.paddingMd,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.secondary,
          child: Text(
            '${client.firstName[0]}${client.lastName[0]}',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          '${client.firstName} ${client.lastName}',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              client.phone,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              client.email,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: client.membership?.isActive == true 
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                borderRadius: AppStyles.borderRadiusSm,
              ),
              child: Text(
                client.membership?.type ?? 'Без абонемента',
                style: AppTextStyles.caption.copyWith(
                  color: client.membership?.isActive == true 
                      ? AppColors.success
                      : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.chat, size: 20, color: AppColors.primary),
              onPressed: () => _startChatWithClient(client),
              tooltip: 'Написать клиенту',
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
        onTap: () => _navigateToClientDetail(client),
      ),
    );
  }

  Widget _buildStatsCard() {
    final activeClients = clients.where((c) => c.membership?.isActive == true).length;
    final inactiveClients = clients.length - activeClients;

    return AppCard(
      padding: AppStyles.paddingLg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Всего', clients.length.toString(), AppColors.primary),
          _buildStatItem('Активные', activeClients.toString(), AppColors.success),
          _buildStatItem('Неактивные', inactiveClients.toString(), AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headline5.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Клиенты'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddClient,
            tooltip: 'Добавить клиента',
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: AppStyles.paddingLg,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по имени, телефону или email...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                border: OutlineInputBorder(
                  borderRadius: AppStyles.borderRadiusLg,
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),

          // Статистика
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildStatsCard(),
          ),
          const SizedBox(height: 16),

          // Список клиентов
          Expanded(
            child: _filteredClients.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Клиенты не найдены'
                              : 'По запросу "${_searchController.text}" ничего не найдено',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredClients.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildClientCard(_filteredClients[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddClient,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}