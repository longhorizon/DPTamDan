abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;
  String? nameError ;
  String? usernameError;
  String? passwordError;

  RegisterFailure({required this.error, this.nameError, this.passwordError, this.usernameError});
}
