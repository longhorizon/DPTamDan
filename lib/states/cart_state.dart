import '../models/cart_item.dart';

abstract class CartState {}

class CartEmpty extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  bool isAddDiscount;
  int total;
  String discode;
  int discount;
  CartLoaded(this.cartItems, {this.total = 0, this.discode = "", this.discount = 0, this.isAddDiscount = false,});
}

class CartError extends CartState {
  final String errorMessage;
  int errorCode;

  CartError(this.errorMessage,{this.errorCode = 400});
}
