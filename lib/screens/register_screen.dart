import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';

import '../blocs/register_bloc.dart';
import '../events/register_event.dart';
import '../states/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordObscured = true;
  final _phoneNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCFController = TextEditingController();

  String fullNameError = '';
  String phoneNumberError = '';
  String passwordError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tạo tài khoản thành công!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is RegisterFailure) {
            setState(() {
              fullNameError =
                  state.nameError != null ? state.nameError.toString() : "";
              phoneNumberError = state.usernameError != null
                  ? state.usernameError.toString()
                  : "";
              passwordError = state.passwordError != null
                  ? state.passwordError.toString()
                  : "";
            });
          }
        },
        child: Container(
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
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.asset('images/register-logo.png'),
                    ),
                    const SizedBox(height: 30.0),
                    _buildTextField("SỐ ĐIỆN THOẠI", "Nhập số điện thoại",
                        _phoneNumberController, phoneNumberError),
                    _buildTextField("HỌ VÀ TÊN", "Nhập họ và tên bạn",
                        _fullNameController, fullNameError),
                    _buildPasswordTextField(
                        "MẬT KHẨU TRUY CẬP",
                        "Nhập mật khẩu của bạn",
                        _passwordController,
                        passwordError),
                    _buildPasswordTextField("NHẬP LẠI MẬT KHẨU",
                        "Nhập mật khẩu truy cập", _passwordCFController, ""),
                    const SizedBox(height: 16.0),
                    _buildRegisterButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      TextEditingController controller, String errorText) {
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
              errorText: errorText != "" ? errorText : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField(String label, String hint,
      TextEditingController controller, String errorText) {
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
              errorText: errorText != "" ? errorText : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: () {
          BlocProvider.of<RegisterBloc>(context).add(
            RegisterButtonPressed(
              username: _phoneNumberController.text,
              name: _fullNameController.text,
              password: _passwordController.text,
              password_confirm: _passwordCFController.text,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: Color(0xff073f65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text("ĐĂNG KÝ",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
      ),
    );
  }
}
