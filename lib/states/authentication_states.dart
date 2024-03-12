// import 'package:equatable/equatable.dart';

abstract class AuthenticationState {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String token;

  const AuthenticationSuccess({required this.token});

  @override
  List<Object> get props => [token];
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  const AuthenticationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
