abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String name;
  final String password;
  final String password_confirm;

  RegisterButtonPressed({
    required this.username,
    required this.name,
    required this.password,
    required this.password_confirm,
  });
}
