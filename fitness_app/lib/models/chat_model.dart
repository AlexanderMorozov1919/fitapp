import 'package:flutter/material.dart';

enum MessageType {
  text,
  image,
  system,
}

enum MessageSender {
  user,
  admin,
  system,
}

class ChatMessage {
  final String id;
  final String chatId;
  final MessageType type;
  final MessageSender sender;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? senderName;
  final String? senderAvatar;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.type,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.senderName,
    this.senderAvatar,
  });

  bool get isUserMessage => sender == MessageSender.user;
  bool get isAdminMessage => sender == MessageSender.admin;
  bool get isSystemMessage => sender == MessageSender.system;

  Color get bubbleColor {
    switch (sender) {
      case MessageSender.user:
        return Colors.blue;
      case MessageSender.admin:
        return Colors.grey[300]!;
      case MessageSender.system:
        return Colors.transparent;
    }
  }

  Color get textColor {
    switch (sender) {
      case MessageSender.user:
        return Colors.white;
      case MessageSender.admin:
        return Colors.black;
      case MessageSender.system:
        return Colors.grey;
    }
  }

  Alignment get alignment {
    switch (sender) {
      case MessageSender.user:
        return Alignment.centerRight;
      case MessageSender.admin:
        return Alignment.centerLeft;
      case MessageSender.system:
        return Alignment.center;
    }
  }
}

class Chat {
  final String id;
  final String userId;
  final String adminId;
  final String adminName;
  final String? adminAvatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatMessage> messages;
  final bool isActive;
  final int unreadCount;

  Chat({
    required this.id,
    required this.userId,
    required this.adminId,
    required this.adminName,
    this.adminAvatar,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
    this.isActive = true,
    this.unreadCount = 0,
  });

  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  bool get hasUnreadMessages => unreadCount > 0;
}