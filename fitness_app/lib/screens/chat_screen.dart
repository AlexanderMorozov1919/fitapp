import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/chat_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_styles.dart';
import '../widgets/common_widgets.dart';
import '../utils/formatters.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late Chat _chat;

  @override
  void initState() {
    super.initState();
    _chat = MockDataService.userChat;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
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
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final newMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: _chat.id,
      type: MessageType.text,
      sender: MessageSender.user,
      content: message,
      timestamp: DateTime.now(),
      isRead: true,
    );

    // Сохраняем сообщение в сервисе
    MockDataService.addMessageToChat(newMessage);
    
    setState(() {
      _chat = MockDataService.userChat;
    });
    
    // Прокручиваем после обновления UI
    _scrollToBottom();

    _messageController.clear();
    _scrollToBottom();

    // Имитация ответа администратора через 2 секунды
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final adminReply = ChatMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          chatId: _chat.id,
          type: MessageType.text,
          sender: MessageSender.admin,
          content: 'Спасибо за ваше сообщение! Мы ответим вам в ближайшее время.',
          timestamp: DateTime.now(),
          isRead: false,
          senderName: _chat.adminName,
          senderAvatar: _chat.adminAvatar,
        );

        // Сохраняем ответ администратора в сервисе
        MockDataService.addMessageToChat(adminReply);
        
        setState(() {
          _chat = MockDataService.userChat;
        });
        
        // Прокручиваем после обновления UI
        _scrollToBottom();
        _scrollToBottom();
      }
    });
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUserMessage = message.isUserMessage;
    final isSystemMessage = message.isSystemMessage;

    if (isSystemMessage) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppStyles.borderRadiusLg,
        ),
        child: Text(
          message.content,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUserMessage)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: AppColors.shadowSm,
              ),
              child: Icon(
                Icons.support_agent,
                size: 20,
                color: Colors.white,
              ),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUserMessage ? const Radius.circular(20) : const Radius.circular(6),
                  bottomRight: isUserMessage ? const Radius.circular(6) : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isUserMessage && message.senderName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName!,
                        style: AppTextStyles.caption.copyWith(
                          color: message.textColor.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: message.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormatters.formatTime(message.timestamp),
                    style: AppTextStyles.overline.copyWith(
                      color: message.textColor.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUserMessage)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
                boxShadow: AppColors.shadowSm,
              ),
              child: Icon(
                Icons.person,
                size: 20,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 120,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppStyles.borderRadiusLg,
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Введите сообщение...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                maxLines: null,
                textInputAction: TextInputAction.newline,
                onChanged: (_) {
                  // Автоматическая прокрутка при вводе длинного сообщения
                  _scrollToBottom();
                },
                onSubmitted: (_) {
                  // Отправка по Enter только если не Shift+Enter
                  if (!_messageController.text.contains('\n')) {
                    _sendMessage();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _chat.adminName,
              style: AppTextStyles.headline6.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Онлайн',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _focusNode.unfocus(),
              child: Container(
                color: AppColors.background,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16), // Минимальный отступ снизу
                  itemCount: _chat.messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(_chat.messages[index]);
                  },
                ),
              ),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}