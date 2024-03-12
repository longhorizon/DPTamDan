import 'package:DPTamDan/models/order.dart';
import 'package:DPTamDan/models/product.dart';

abstract class OrderScreenState {
  const OrderScreenState();

  @override
  List<Object> get props => [];
}

class InitialState extends OrderScreenState {}

class LoadingState extends OrderScreenState {}

class LoadedState extends OrderScreenState {
  final List<Order> orders;

  LoadedState({
    required this.orders,
  });

  @override
  List<Object> get props => [orders];
}

class SearchState extends OrderScreenState {
  final List<Product> products;

  SearchState({
    required this.products,
  });

  @override
  List<Object> get props => [products];
}

class ErrorState extends OrderScreenState {
  final String errorMessage;
  final int errorsCode;

  const ErrorState(this.errorMessage, {this.errorsCode = 400});

  @override
  List<Object> get props => [errorMessage];
}
