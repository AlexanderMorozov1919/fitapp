import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../utils/formatters.dart';
import 'employee_chat_screen.dart';
import '../../main.dart';

class EmployeeChatListScreen extends StatefulWidget {
  const EmployeeChatListScreen({super.key});

  @override
  State<EmployeeChatListScreen> createState() => _EmployeeChatListScreenState();
}

class _EmployeeChatListScreenState extends State<EmployeeChatListScreen> {
  final List<Map<String, dynamic>> _contacts = [
    {
      'id': 'client_1',
      'name': 'Анна Петрова',
      'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150&h=150&fit=crop&crop=face',
      'lastMessage': 'Спасибо за тренировку!',
      'time': DateTime.now().subtract(const Duration(minutes: 30)),
      'unread': 2,
    },
    {
      'id': 'client_2', 
      'name': 'Михаил Смирнов',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'lastMessage': 'Когда будет следующее занятие?',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'unread': 1,
    },
    {
      'id': 'colleague_1',
      'name': 'Мария Администратор',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      'lastMessage': 'Есть новый клиент на теннис',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'unread': 0,
    },
    {
      'id': 'client_3',
      'name': 'Дмитрий Иванов',
      'avatar': null,
      'lastMessage': 'Хочу записаться на индивидуальную тренировку',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'unread': 3,
    },
    {
      'id': 'colleague_2',
      'name': 'Алексей Тренер',
      'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'lastMessage': 'Можем поменяться сменами?',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Чаты'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          final hasUnread = (contact['unread'] as int) > 0;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: AppStyles.borderRadiusMd,
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: contact['avatar'] != null
                  ? CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(contact['avatar'] as String),
                    )
                  : CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.secondary,
                      child: Text(
                        contact['name'].toString().substring(0, 1),
                        style: AppTextStyles.headline6.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      contact['name'] as String,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasUnread)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        contact['unread'].toString(),
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    contact['lastMessage'] as String,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormatters.formatTime(contact['time'] as DateTime),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeChatScreen(
                      contactId: contact['id'] as String,
                      contactName: contact['name'] as String,
                      contactAvatar: contact['avatar'] as String?,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Реализовать создание нового чата
          _showNewChatDialog(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  void _showNewChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новый чат'),
          content: const Text('Функция создания нового чата будет реализована в будущем обновлении.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}