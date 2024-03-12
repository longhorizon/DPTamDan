import 'package:DPTamDan/models/notification_data.dart';
import 'package:DPTamDan/models/product.dart';

abstract class NotiScreenState {
  const NotiScreenState();

  @override
  List<Object> get props => [];
}

class InitialState extends NotiScreenState {}

class LoadingState extends NotiScreenState {}

class LoadedState extends NotiScreenState {
  final List<NotificationData> notis;

  LoadedState({
    required this.notis,
  });

  @override
  List<Object> get props => [notis];
}

class SearchState extends NotiScreenState {
  final List<Product> products;

  SearchState({
    required this.products,
  });

  @override
  List<Object> get props => [products];
}

class ErrorState extends NotiScreenState {
  final String errorMessage;
  final int errorsCode;

  const ErrorState(this.errorMessage, {this.errorsCode = 400});

  @override
  List<Object> get props => [errorMessage];
}
