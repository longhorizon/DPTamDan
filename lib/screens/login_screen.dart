import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication_bloc.dart';
import '../events/authentication_events.dart';
import '../states/authentication_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordObscured = true;
  // final AuthenticationBloc _authBloc = AuthenticationBloc();
  late AuthenticationBloc _authBloc;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authBloc = AuthenticationBloc(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _usernameController.text = "0166166166";
    _passwordController.text = "admin123";

    return BlocProvider(
      create: (context) => _authBloc,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg_register.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Image.asset('images/register-logo.png'),
                    ),
                    const SizedBox(height: 30.0),
                    _buildTextField("SỐ ĐIỆN THOẠI", "Nhập số điện thoại",
                        _usernameController),
                    _buildPasswordTextField(
                        "MẬT KHẨU", "Nhập mật khẩu", _passwordController),
                    const SizedBox(height: 16.0),
                    _buildLoginButton(context),
                    const SizedBox(height: 8.0),
                    _buildAdditionalOptions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF073f84)),
          ),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField(
      String label, String hint, TextEditingController controller) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF073f84)),
          ),
          TextField(
            controller: controller,
            obscureText: _isPasswordObscured,
            style: const TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
                icon: Icon(
                  _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: const Text(
            "Quên mật khẩu",
            style: TextStyle(color: Color(0xFF073f84)),
          ),
        ),
        const SizedBox(width: 8.0),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/register');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text("Đăng ký", style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return const CircularProgressIndicator();
          // } else if (state is AuthenticationFailure) {
          //   return Text(state.error);
        } else {
          return Column(
            children: [
              if (state is AuthenticationFailure)
                Text(state.error.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                    )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    _authBloc.add(
                        LoginEvent(username: username, password: password));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("ĐĂNG NHẬP",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
