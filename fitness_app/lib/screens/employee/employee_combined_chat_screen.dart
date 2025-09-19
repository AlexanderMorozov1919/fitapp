import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../services/mock_data/client_data.dart';
import '../../services/chat_notification_service.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/common_widgets.dart';
import 'select_client_screen.dart';
import '../../main.dart';

class EmployeeCombinedChatScreen extends StatefulWidget {
  const EmployeeCombinedChatScreen({super.key});

  @override
  State<EmployeeCombinedChatScreen> createState() => _EmployeeCombinedChatScreenState();
}

class _EmployeeCombinedChatScreenState extends State<EmployeeCombinedChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  List<Map<String, dynamic>> _contacts = [];

  String? _selectedContactId;
  Chat? _currentChat;

  @override
  void initState() {
    super.initState();
    _loadContacts();
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  void _loadContacts() {
    final chats = MockDataService.getEmployeeChats();
    final demoContacts = [
      {
        'id': 'client_1',
        'name': 'Анна Петрова',
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150&h=150&fit=crop&crop=face',
        'lastMessage': 'Спасибо за тренировку!',
        'time': DateTime.now().subtract(const Duration(minutes: 30)),
        'unread': 3,
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
    ];

    setState(() {
      // Создаем контакты из реальных чатов
      final realContacts = chats.map((chat) {
        final contactId = chat.userId;
        
        // Ищем имя контакта в демо-контактах или используем ID
        String contactName = 'Клиент';
        String? avatar;
        String lastMessage = 'Нет сообщений';
        DateTime lastTime = DateTime.now();
        int unread = chat.unreadCount;
        
        // Пытаемся найти контакт в демо-данных
        final demoContact = demoContacts.firstWhere(
          (demo) => demo['id'] == contactId,
          orElse: () => {},
        );
        
        if (demoContact.isNotEmpty) {
          contactName = demoContact['name'] as String;
          avatar = demoContact['avatar'] as String?;
          lastMessage = demoContact['lastMessage'] as String;
          lastTime = demoContact['time'] as DateTime;
        } else if (chat.messages.isNotEmpty) {
          // Используем данные из реального чата
          final lastMsg = chat.messages.last;
          contactName = lastMsg.senderName ?? 'Клиент';
          lastMessage = lastMsg.content;
          lastTime = lastMsg.timestamp;
        }
        
        return {
          'id': contactId,
          'name': contactName,
          'avatar': avatar,
          'lastMessage': lastMessage,
          'time': lastTime,
          'unread': unread,
        };
      }).toList();

      // Добавляем демо контакты, которые еще не созданы как реальные чаты
      final demoContactsToAdd = demoContacts.where((demo) =>
        !realContacts.any((real) => real['id'] == demo['id'])
      ).toList();

      _contacts = [...realContacts, ...demoContactsToAdd];

      // Сортируем по времени последнего сообщения (новые сверху)
      _contacts.sort((a, b) => (b['time'] as DateTime).compareTo(a['time'] as DateTime));

      // Выбираем первый контакт по умолчанию
      if (_contacts.isNotEmpty && _selectedContactId == null) {
        _selectContact(_contacts.first['id'] as String);
      }
    });
  }

  void _selectContact(String contactId) {
    setState(() {
      _selectedContactId = contactId;
      final contact = _contacts.firstWhere((c) => c['id'] == contactId);
      _currentChat = MockDataService.getOrCreateEmployeeChat(
        contactId,
        contact['name'] as String,
        contact['avatar'] as String?,
      );
      
      // Помечаем сообщения как прочитанные при выборе чата
      MockDataService.markEmployeeChatAsRead(contactId);
      
      // Обновляем счетчик непрочитанных в списке контактов
      final contactIndex = _contacts.indexWhere((c) => c['id'] == contactId);
      if (contactIndex != -1) {
        _contacts[contactIndex]['unread'] = 0;
      }
      
      // Уведомляем об изменении количества непрочитанных сообщений
      ChatNotificationService.notifyUnreadCountChanged();
    });
    _scrollToBottom(animated: false);
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  void _sendMessage() {
    if (_selectedContactId == null || _messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    final contact = _contacts.firstWhere((c) => c['id'] == _selectedContactId);

    final newMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: _currentChat!.id,
      type: MessageType.text,
      sender: MessageSender.admin,
      content: message,
      timestamp: DateTime.now(),
      isRead: true,
      senderName: 'Игорь Виноградов',
    );

    MockDataService.addMessageToEmployeeChat(_selectedContactId!, newMessage);
    
    setState(() {
      _currentChat = MockDataService.getEmployeeChat(_selectedContactId!);
      // Обновляем последнее сообщение в списке контактов
      final contactIndex = _contacts.indexWhere((c) => c['id'] == _selectedContactId);
      if (contactIndex != -1) {
        _contacts[contactIndex]['lastMessage'] = message;
        _contacts[contactIndex]['time'] = DateTime.now();
      }
    });
    
    _scrollToBottom();
    _messageController.clear();

    // Имитация ответа клиента
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _selectedContactId != null) {
        final responses = [
          'Спасибо за информацию!',
          'Понятно, я учту это.',
          'Отлично, жду нашей встречи!',
          'Спасибо, что ответили так быстро!',
        ];
        final response = responses[DateTime.now().millisecondsSinceEpoch % responses.length];

        final clientReply = ChatMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          chatId: _currentChat!.id,
          type: MessageType.text,
          sender: MessageSender.user,
          content: response,
          timestamp: DateTime.now(),
          isRead: false,
          senderName: contact['name'] as String,
          senderAvatar: contact['avatar'] as String?,
        );

        MockDataService.addMessageToEmployeeChat(_selectedContactId!, clientReply);
        
        setState(() {
          _currentChat = MockDataService.getEmployeeChat(_selectedContactId!);
          // Обновляем непрочитанные сообщения
          final contactIndex = _contacts.indexWhere((c) => c['id'] == _selectedContactId);
          if (contactIndex != -1) {
            _contacts[contactIndex]['lastMessage'] = response;
            _contacts[contactIndex]['time'] = DateTime.now();
            _contacts[contactIndex]['unread'] = (_contacts[contactIndex]['unread'] as int) + 1;
          }
        });
        
        // Уведомляем об изменении количества непрочитанных сообщений
        ChatNotificationService.notifyUnreadCountChanged();
        
        _scrollToBottom();
      }
    });
  }

  Widget _buildContactList() {
    return Container(
      width: 280, // Уменьшил ширину для лучшего размещения
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          final isSelected = _selectedContactId == contact['id'];
          final hasUnread = (contact['unread'] as int) > 0;
          
          return Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              border: isSelected
                  ? Border(left: BorderSide(color: AppColors.primary, width: 3))
                  : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Уменьшил отступы
              leading: contact['avatar'] != null
                  ? CircleAvatar(
                      radius: 18, // Уменьшил размер аватара
                      backgroundImage: NetworkImage(contact['avatar'] as String),
                    )
                  : CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.secondary,
                      child: Text(
                        contact['name'].toString().substring(0, 1),
                        style: AppTextStyles.bodyMedium.copyWith(
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
                      style: AppTextStyles.bodyMedium.copyWith( // Уменьшил размер шрифта
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasUnread)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), // Уменьшил отступы
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        contact['unread'].toString(),
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 9, // Уменьшил размер шрифта
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 1),
                  Text(
                    contact['lastMessage'] as String,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 11, // Уменьшил размер шрифта
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    DateFormatters.formatTime(contact['time'] as DateTime),
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textTertiary,
                      fontSize: 9, // Уменьшил размер шрифта
                    ),
                  ),
                ],
              ),
              onTap: () => _selectContact(contact['id'] as String),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isEmployeeMessage = message.isAdminMessage;
    final contact = _contacts.firstWhere((c) => c['id'] == _selectedContactId);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isEmployeeMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isEmployeeMessage)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
                image: contact['avatar'] != null
                    ? DecorationImage(
                        image: NetworkImage(contact['avatar'] as String),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: contact['avatar'] == null
                  ? Icon(Icons.person, size: 16, color: Colors.white)
                  : null,
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isEmployeeMessage ? AppColors.primary : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isEmployeeMessage ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isEmployeeMessage ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: isEmployeeMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (message.senderName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName!,
                        style: AppTextStyles.caption.copyWith(
                          color: isEmployeeMessage 
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isEmployeeMessage ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormatters.formatTime(message.timestamp),
                    style: AppTextStyles.overline.copyWith(
                      color: isEmployeeMessage 
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.6),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isEmployeeMessage)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Icon(Icons.support_agent, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    if (_currentChat == null) {
      return const Center(
        child: Text('Выберите чат для общения'),
      );
    }

    return Column(
      children: [
        // Заголовок чата
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            children: [
              if (_selectedContactId != null)
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    _contacts.firstWhere((c) => c['id'] == _selectedContactId)['avatar'] as String? ?? '',
                  ),
                  onBackgroundImageError: (_, __) {},
                  child: _contacts.firstWhere((c) => c['id'] == _selectedContactId)['avatar'] == null
                      ? Icon(Icons.person, size: 16, color: Colors.white)
                      : null,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _contacts.firstWhere((c) => c['id'] == _selectedContactId)['name'] as String,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Онлайн',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Сообщения
        Expanded(
          child: GestureDetector(
            onTap: () => _focusNode.unfocus(),
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _currentChat!.messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_currentChat!.messages[index]);
                },
              ),
            ),
          ),
        ),
        // Поле ввода
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Введите сообщение...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 16),
                  onPressed: _sendMessage,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
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
        title: const Text('Чаты'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () => _navigateToSelectClient(context),
            tooltip: 'Новый чат',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Адаптивный дизайн для мобильных устройств
          if (constraints.maxWidth < 600) {
            // Для узких экранов показываем либо список, либо чат
            if (_selectedContactId == null) {
              return _buildContactListMobile();
            } else {
              return _buildChatAreaMobile();
            }
          } else {
            // Для широких экранов показываем оба раздела
            return Row(
              children: [
                _buildContactList(),
                Expanded(
                  child: _buildChatArea(),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: MediaQuery.of(context).size.width < 600
          ? FloatingActionButton(
              onPressed: () => _navigateToSelectClient(context),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_comment, color: Colors.white),
            )
          : null,
    );
  }

  // Мобильная версия списка контактов
  Widget _buildContactListMobile() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        final hasUnread = (contact['unread'] as int) > 0;
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: contact['avatar'] != null
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(contact['avatar'] as String),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.secondary,
                    child: Text(
                      contact['name'].toString().substring(0, 1),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            title: Text(
              contact['name'] as String,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              contact['lastMessage'] as String,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: hasUnread
                ? CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      contact['unread'].toString(),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  )
                : null,
            onTap: () => _selectContact(contact['id'] as String),
          ),
        );
      },
    );
  }

  // Мобильная версия области чата с кнопкой назад
  Widget _buildChatAreaMobile() {
    final contact = _contacts.firstWhere((c) => c['id'] == _selectedContactId);
    
    return Column(
      children: [
        // Заголовок с кнопкой назад
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedContactId = null;
                  });
                },
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  contact['avatar'] as String? ?? '',
                ),
                onBackgroundImageError: (_, __) {},
                child: contact['avatar'] == null
                    ? Icon(Icons.person, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name'] as String,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Онлайн',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildChatAreaContent(),
        ),
        _buildInputFieldMobile(),
      ],
    );
  }

  Widget _buildChatAreaContent() {
    if (_currentChat == null) {
      return const Center(
        child: Text('Выберите чат для общения'),
      );
    }

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _currentChat!.messages.length,
          itemBuilder: (context, index) {
            return _buildMessageBubble(_currentChat!.messages[index]);
          },
        ),
      ),
    );
  }

  Widget _buildInputFieldMobile() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Введите сообщение...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 16),
              onPressed: _sendMessage,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSelectClient(BuildContext context) {
    // Устанавливаем callback в глобальном состоянии
    ChatSelectionState.setCallback(_handleNewContact);
    
    final navigationService = NavigationService.of(context);
    if (navigationService != null) {
      // Используем навигацию через NavigationService
      navigationService.navigateTo('select_client');
    } else {
      // Fallback навигация
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SelectClientScreen(),
        ),
      ).then((newContact) {
        if (newContact != null && newContact is Map<String, dynamic>) {
          _handleNewContact(newContact);
        }
        // Очищаем callback после использования
        ChatSelectionState.clearCallback();
      });
    }
  }


  void _handleNewContact(Map<String, dynamic> newContact) {
    // Создаем новый чат
    MockDataService.getOrCreateEmployeeChat(
      newContact['id'] as String,
      newContact['name'] as String,
      newContact['avatar'] as String?,
    );

    // Перезагружаем контакты
    _loadContacts();

    // Показываем уведомление о начале чата
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Чат с ${newContact['name']} начат'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _createNewChat(User client) {
    final newContactId = 'client_${client.id}';
    final newContact = {
      'id': newContactId,
      'name': '${client.firstName} ${client.lastName}',
      'avatar': null,
      'lastMessage': 'Новый чат',
      'time': DateTime.now(),
      'unread': 0,
    };

    _handleNewContact(newContact);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}