import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../const/const.dart';
import '../events/authentication_events.dart';
import '../states/authentication_states.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final BuildContext context;
  AuthenticationBloc(this.context) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is LoginEvent) {
      yield AuthenticationLoading();
      try {
        var uri = Uri.https(Constants.apiUrl, 'api/user/login');
        final response = await http.post(
          uri,
          headers: {
            "Content-Type": "application/json",
            "access-control-allow-headers":
                "access-control-allow-origin, accept",
            "access-control-allow-origin": "*",
          },
          body: json.encode({
            'username': event.username,
            'password': event.password,
          }),
        );

        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          if( responseData['status'] == 200)
          {
            final token = responseData['result']['token'];
            saveTokenToSharedPreferences(token);
            yield AuthenticationSuccess(token: token);
            Navigator.pushReplacementNamed(context, '/home');
          }
          else if( responseData['status'] == 400)
          {
            yield AuthenticationFailure(error: responseData['message'] ?? "");
          }
          else
            AuthenticationFailure(error: "Tài khoản không tồn tại hoặc mật khẩu không chính xác.");
        }
        // else {
        //   print(message);
        //   yield AuthenticationFailure(error: message);
        // }
      } catch (error) {
        print(error.toString());
        yield AuthenticationFailure(
            // error: "Tài khoản không tồn tại hoặc mật khẩu không chính xác.");
            error: error.toString() ??
                "Tài khoản không tồn tại hoặc mật khẩu không chính xác.");
      }
    }
  }

  Future<void> saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    try {
      var uri = Uri.https(Constants.apiUrl, 'api/user/info');
      final response = await http.post(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: json.encode({
          'token': token,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        await prefs.setString('user_id', responseData['result']['id']);
        await prefs.setString('user_name', responseData['result']['username']);
        await prefs.setString('last_name', responseData['result']['last_name']);
      }
    } catch (error) {
      print(error);
    }
  }
}
