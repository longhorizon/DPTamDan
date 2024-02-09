import 'package:DPTamDan/blocs/authentication_bloc.dart';
import 'package:DPTamDan/blocs/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/home_bloc.dart';
import 'blocs/navigation_bloc.dart';
import 'screens/splash_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(context),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider<HomeScreenBloc>(
          create: (context) => HomeScreenBloc(
            apiService: APIService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'DPTamDan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => BlocProvider.value(
              value: context.read<AuthenticationBloc>(),
              child: const LoginScreen()),
          '/register': (context) => BlocProvider.value(
              value: context.read<RegisterBloc>(),
              child: const RegisterScreen()),
          '/home': (context) => BlocProvider.value(
              value: context.read<HomeScreenBloc>(), child: const HomeScreen()),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
