import 'package:flutter/material.dart';
import 'product_model.dart';

class Purchase {
  final String id;
  final DateTime purchaseDate;
  final List<CartItem> items;
  final double totalAmount;
  final PurchaseStatus status;
  final String? paymentMethod;
  final String? transactionId;

  Purchase({
    required this.id,
    required this.purchaseDate,
    required this.items,
    required this.totalAmount,
    this.status = PurchaseStatus.completed,
    this.paymentMethod,
    this.transactionId,
  });

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final purchaseDay = DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day);

    if (purchaseDay == today) {
      return 'Сегодня, ${_formatTime(purchaseDate)}';
    } else if (purchaseDay == today.subtract(const Duration(days: 1))) {
      return 'Вчера, ${_formatTime(purchaseDate)}';
    } else {
      return '${_formatDate(purchaseDate)}, ${_formatTime(purchaseDate)}';
    }
  }

  String get formattedTotalAmount => '${totalAmount.toInt()} ₽';

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Purchase copyWith({
    String? id,
    DateTime? purchaseDate,
    List<CartItem>? items,
    double? totalAmount,
    PurchaseStatus? status,
    String? paymentMethod,
    String? transactionId,
  }) {
    return Purchase(
      id: id ?? this.id,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}

enum PurchaseStatus {
  pending,
  completed,
  cancelled,
  refunded,
}

extension PurchaseStatusExtension on PurchaseStatus {
  String get text {
    switch (this) {
      case PurchaseStatus.pending:
        return 'Ожидает оплаты';
      case PurchaseStatus.completed:
        return 'Завершена';
      case PurchaseStatus.cancelled:
        return 'Отменена';
      case PurchaseStatus.refunded:
        return 'Возвращена';
    }
  }

  Color get color {
    switch (this) {
      case PurchaseStatus.pending:
        return Colors.orange;
      case PurchaseStatus.completed:
        return Colors.green;
      case PurchaseStatus.cancelled:
        return Colors.red;
      case PurchaseStatus.refunded:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case PurchaseStatus.pending:
        return Icons.pending;
      case PurchaseStatus.completed:
        return Icons.check_circle;
      case PurchaseStatus.cancelled:
        return Icons.cancel;
      case PurchaseStatus.refunded:
        return Icons.refresh;
    }
  }
}