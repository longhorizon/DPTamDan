import '../models/product.dart';

abstract class CartEvent {}

class LoadCartData extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;

  AddToCart(this.product);
}

class SelectItem extends CartEvent {
  final int index;

  SelectItem(this.index);
} 

class UpdateCartItemQuantity extends CartEvent {
  final String id;
  final int quantity;

  UpdateCartItemQuantity(this.id, this.quantity);
}

class RemoveItem extends CartEvent {
  final String id;

  RemoveItem(this.id);
}

class ApplyDiscountCode extends CartEvent {
  final String discountCode;

  ApplyDiscountCode({
    required this.discountCode,
  });
}
