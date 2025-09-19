import 'package:flutter/material.dart';
import '../../services/mock_data/client_data.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../main.dart';

// Глобальное состояние для передачи данных между экранами
class ChatSelectionState {
  static Function(Map<String, dynamic>)? onClientSelectedCallback;
  
  static void setCallback(Function(Map<String, dynamic>) callback) {
    onClientSelectedCallback = callback;
  }
  
  static void clearCallback() {
    onClientSelectedCallback = null;
  }
  
  static void notifyClientSelected(Map<String, dynamic> newContact) {
    if (onClientSelectedCallback != null) {
      onClientSelectedCallback!(newContact);
    }
  }
}

class SelectClientScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onClientSelected;

  const SelectClientScreen({super.key, this.onClientSelected});

  @override
  State<SelectClientScreen> createState() => _SelectClientScreenState();
}

class _SelectClientScreenState extends State<SelectClientScreen> {
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
          return fullName.contains(query) || phone.contains(query);
        }).toList();
      });
    }
  }

  void _selectClient(User client) {
    // Создаем новый контакт для чата
    final newContactId = 'client_${client.id}';
    final newContact = {
      'id': newContactId,
      'name': '${client.firstName} ${client.lastName}',
      'avatar': null,
      'lastMessage': 'Новый чат',
      'time': DateTime.now(),
      'unread': 0,
    };

    // Используем глобальное состояние для уведомления
    ChatSelectionState.notifyClientSelected(newContact);
    
    // Возвращаемся назад
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      navigationService.onBack();
    } else {
      Navigator.pop(context, newContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Выберите клиента'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Поиск
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по имени или телефону...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            // Список клиентов
            Expanded(
              child: ListView.builder(
                itemCount: _filteredClients.length,
                itemBuilder: (context, index) {
                  final client = _filteredClients[index];
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
                            client.membership?.type ?? 'Без абонемента',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _selectClient(client),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}