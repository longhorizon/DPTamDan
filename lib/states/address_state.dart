import '../models/address.dart';

abstract class AddressScreenState {
  const AddressScreenState();

  @override
  List<Object> get props => [];
}

class InitialState extends AddressScreenState {}

class LoadingState extends AddressScreenState {}

class LoadedState extends AddressScreenState {
  final List<Address> addresses;

  LoadedState({
    required this.addresses,
  });

  @override
  List<Object> get props => [addresses];
}

class ErrorState extends AddressScreenState {
  final String errorMessage;
  final int errorsCode;

  const ErrorState(this.errorMessage, {this.errorsCode = 400});

  @override
  List<Object> get props => [errorMessage];
}
