import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../events/register_event.dart';
import '../states/register_state.dart';
import '../const/const.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterButtonPressed) {
      yield RegisterLoading();
      try {
        var uri = Uri.https(Constants.apiUrl, 'api/user/signup');
        final response = await http.post(
          // Uri.parse('https://tamdan.devone.vn/api/user/signup'),
          uri,
          headers: {
            "Content-Type": "application/json",
            "access-control-allow-headers":
                "access-control-allow-origin, accept",
            "access-control-allow-origin": "*",
          },
          body: jsonEncode({
            'name': event.name,
            'username': event.username,
            'password': event.password,
            'password_confirm': event.password_confirm,
          }),
        );

        final responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          yield RegisterSuccess();
        } else if (responseData['status'] == 400) {
          final errors = responseData['result'];
          yield RegisterFailure(
            error: "validation",
            nameError: errors['name'] ?? '',
            usernameError: errors['username'] ?? '',
            passwordError: errors['password'] ?? '',
          );
        } else {
          yield RegisterFailure(error: 'Đăng ký thất bại');
        }
      } catch (error) {
        yield RegisterFailure(error: 'Đã xảy ra lỗi: $error');
      }
    }
  }
}
