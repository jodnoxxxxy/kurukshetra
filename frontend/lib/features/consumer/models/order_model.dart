import 'cart_item.dart';

enum OrderStatus { pending, confirmed, outForDelivery, delivered, cancelled }

class OrderModel {
  final String id;
  final String consumerId;
  final String farmerId;
  final String farmerName;
  final List<CartItem> items;
  final double totalAmount;
  final double deliveryFee;
  final DateTime orderDate;
  final OrderStatus status;
  final String deliveryAddress;

  OrderModel({
    required this.id,
    required this.consumerId,
    required this.farmerId,
    required this.farmerName,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.orderDate,
    required this.status,
    required this.deliveryAddress,
  });

  String get formattedStatus {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending Approval';
      case OrderStatus.confirmed:
        return 'Confirmed by Farmer';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
