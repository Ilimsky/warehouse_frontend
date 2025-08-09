import 'package:intl/intl.dart';

class OrderItem {
  final int productId;
  final String productName;
  final int quantity;
  final double pricePerUnit;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      pricePerUnit: json['pricePerUnit'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
    };
  }
}

enum OrderStatus {
  NEW,
  PROCESSING,
  SHIPPED,
  DELIVERED,
  CANCELLED,
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.NEW:
        return 'NEW';
      case OrderStatus.PROCESSING:
        return 'PROCESSING';
      case OrderStatus.SHIPPED:
        return 'SHIPPED';
      case OrderStatus.DELIVERED:
        return 'DELIVERED';
      case OrderStatus.CANCELLED:
        return 'CANCELLED';
    }
  }

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'NEW':
        return OrderStatus.NEW;
      case 'PROCESSING':
        return OrderStatus.PROCESSING;
      case 'SHIPPED':
        return OrderStatus.SHIPPED;
      case 'DELIVERED':
        return OrderStatus.DELIVERED;
      case 'CANCELLED':
        return OrderStatus.CANCELLED;
      default:
        throw ArgumentError('Unknown order status: $status');
    }
  }
}

class Order {
  final int id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String deliveryAddress;
  final DateTime orderDate;
  final OrderStatus status;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.deliveryAddress,
    required this.orderDate,
    required this.status,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<OrderItem> items = itemsList
        .map((item) => OrderItem.fromJson(item))
        .toList();

    return Order(
      id: json['id'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      deliveryAddress: json['deliveryAddress'],
      orderDate: DateTime.parse(json['orderDate']),
      status: OrderStatusExtension.fromString(json['status']),
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'deliveryAddress': deliveryAddress,
      'orderDate': orderDate.toIso8601String(),
      'status': status.name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  String get formattedDate {
    return DateFormat('dd.MM.yyyy HH:mm').format(orderDate);
  }

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.pricePerUnit * item.quantity));
  }
}