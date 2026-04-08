import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';
import '../repositories/order_repository.dart';
import '../../consumer_auth/providers/consumer_auth_provider.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl();
});

class ActiveOrdersNotifier extends Notifier<List<OrderModel>> {
  @override
  List<OrderModel> build() => [];

  Future<void> loadOrders() async {
    final consumer = ref.read(consumerAuthProvider);
    if (consumer == null) return;

    final repo = ref.read(orderRepositoryProvider);
    final orders = await repo.getConsumerOrders(consumer.id);
    state = orders;
  }

  Future<OrderModel?> placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required double deliveryFee,
    required String deliveryAddress,
  }) async {
    final consumer = ref.read(consumerAuthProvider);
    if (consumer == null || items.isEmpty) return null;

    final repo = ref.read(orderRepositoryProvider);
    
    // In a real app, orders might be grouped by farmer. 
    // Here we're using the first farmer for demonstration.
    final farmerId = items.first.product.farmerId;
    final farmerName = items.first.product.farmerName;

    final newOrder = await repo.placeOrder(
      consumerId: consumer.id,
      farmerId: farmerId,
      farmerName: farmerName,
      items: items,
      totalAmount: totalAmount,
      deliveryFee: deliveryFee,
      deliveryAddress: deliveryAddress,
    );

    state = [newOrder, ...state];
    return newOrder;
  }
}

final activeOrdersProvider = NotifierProvider<ActiveOrdersNotifier, List<OrderModel>>(ActiveOrdersNotifier.new);
