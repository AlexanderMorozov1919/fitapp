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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: AppStyles.borderRadiusMd,
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            const SizedBox(height: 2),
            Text(
              client.membership?.type ?? 'Без абонемента',
              style: AppTextStyles.caption.copyWith(
                color: client.membership?.isActive == true 
                    ? AppColors.success 
                    : AppColors.error,
                fontWeight: FontWeight.w500,
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
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
        onTap: () => _navigateToClientDetail(client),
      ),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Поиск
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по имени, телефону или email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: AppStyles.borderRadiusMd,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Статистика
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppStyles.borderRadiusMd,
                boxShadow: AppColors.shadowSm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Всего', clients.length.toString(), AppColors.primary),
                  _buildStatItem('Активные', 
                    clients.where((c) => c.membership?.isActive == true).length.toString(), 
                    AppColors.success
                  ),
                  _buildStatItem('Без абон.', 
                    clients.where((c) => c.membership == null || !c.membership!.isActive).length.toString(), 
                    AppColors.warning
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Список клиентов
            Expanded(
              child: _filteredClients.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'Клиенты не найдены'
                            : 'По запросу "${_searchController.text}" ничего не найдено',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredClients.length,
                      itemBuilder: (context, index) {
                        return _buildClientCard(_filteredClients[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddClient,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headline6.copyWith(
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}