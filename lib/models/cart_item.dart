import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isSelected;

  CartItem({required this.product, this.quantity = 1, this.isSelected = false});

  CartItem copyWith({Product? product, int? quantity, bool? isSelected}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json),
      quantity: json['total'] as int,
    );
  }

}