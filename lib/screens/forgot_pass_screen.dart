import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication_bloc.dart';
import '../events/authentication_events.dart';
import '../states/authentication_states.dart';

class ForgorPasswordScreen extends StatefulWidget {
  const ForgorPasswordScreen({super.key});

  @override
  _ForgorPasswordScreenState createState() => _ForgorPasswordScreenState();
}

class _ForgorPasswordScreenState extends State<ForgorPasswordScreen> {
  bool _isPasswordObscured = true;
  // final AuthenticationBloc _authBloc = AuthenticationBloc();
  late AuthenticationBloc _authBloc;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authBloc = AuthenticationBloc(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildTextField(
                        "Email", "Nhập email của bạn", _usernameController),
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
          SizedBox(
            height: 4,
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
          SizedBox(
            height: 4,
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
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Đăng nhập",
            style: TextStyle(color: Color(0xFF073f84)),
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
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Color(0xff073f65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Gửi",
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
