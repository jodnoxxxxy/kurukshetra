import 'consumer_product.dart';

class CartItem {
  final ConsumerProduct product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.pricePerUnit * quantity;

  CartItem copyWith({
    ConsumerProduct? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
