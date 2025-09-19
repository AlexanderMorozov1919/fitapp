import 'package:flutter/material.dart';
import './mock_data_service.dart';

class ChatNotificationService {
  static VoidCallback? _onUnreadCountChanged;

  static void registerCallback(VoidCallback callback) {
    _onUnreadCountChanged = callback;
  }

  static void unregisterCallback() {
    _onUnreadCountChanged = null;
  }

  static void notifyUnreadCountChanged() {
    _onUnreadCountChanged?.call();
  }

  static int getUnreadCount() {
    return MockDataService.getEmployeeUnreadMessagesCount();
  }
}