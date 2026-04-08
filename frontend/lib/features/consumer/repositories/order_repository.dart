import '../models/order_model.dart';
import '../models/cart_item.dart';

abstract class OrderRepository {
  Future<OrderModel> placeOrder({
    required String consumerId,
    required String farmerId,
    required String farmerName,
    required List<CartItem> items,
    required double totalAmount,
    required double deliveryFee,
    required String deliveryAddress,
  });

  Future<List<OrderModel>> getConsumerOrders(String consumerId);
}

class OrderRepositoryImpl implements OrderRepository {
  final List<OrderModel> _mockOrders = [];

  @override
  Future<OrderModel> placeOrder({
    required String consumerId,
    required String farmerId,
    required String farmerName,
    required List<CartItem> items,
    required double totalAmount,
    required double deliveryFee,
    required String deliveryAddress,
  }) async {
    // Simulated network delay
    await Future.delayed(const Duration(seconds: 2));

    final newOrder = OrderModel(
      id: '#ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      consumerId: consumerId,
      farmerId: farmerId,
      farmerName: farmerName,
      items: items,
      totalAmount: totalAmount,
      deliveryFee: deliveryFee,
      orderDate: DateTime.now(),
      status: OrderStatus.pending,
      deliveryAddress: deliveryAddress,
    );

    _mockOrders.insert(0, newOrder);
    return newOrder;
  }

  @override
  Future<List<OrderModel>> getConsumerOrders(String consumerId) async {
    // Simulated network delay
    await Future.delayed(const Duration(seconds: 1));
    return _mockOrders.where((o) => o.consumerId == consumerId).toList();
  }
}
