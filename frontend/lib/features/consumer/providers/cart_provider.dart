import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/consumer_product.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addToCart(ConsumerProduct product, int quantity) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      final updatedList = List<CartItem>.from(state);
      updatedList[existingIndex] = updatedList[existingIndex].copyWith(
        quantity: updatedList[existingIndex].quantity + quantity,
      );
      state = updatedList;
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final updatedList = List<CartItem>.from(state);
    final index = updatedList.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      updatedList[index] = updatedList[index].copyWith(quantity: newQuantity);
      state = updatedList;
    }
  }

  void clearCart() {
    state = [];
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => state.isNotEmpty ? 50.0 : 0.0;
  double get total => subtotal + deliveryFee;
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);
