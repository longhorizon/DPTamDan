import 'package:DPTamDan/blocs/authentication_bloc.dart';
import 'package:DPTamDan/blocs/branch_bloc.dart';
import 'package:DPTamDan/blocs/noti_bloc.dart';
import 'package:DPTamDan/blocs/order_bloc.dart';
import 'package:DPTamDan/blocs/register_bloc.dart';
import 'package:DPTamDan/screens/address_screen.dart';
import 'package:DPTamDan/screens/branch_screen.dart';
import 'package:DPTamDan/screens/list_order_screen.dart';
import 'package:DPTamDan/screens/noti_screen.dart';
import 'package:DPTamDan/screens/order_screen.dart';
import 'package:DPTamDan/screens/search_screen.dart';
import 'package:DPTamDan/screens/tadavina_screen.dart';
import 'package:DPTamDan/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/address_bloc.dart';
import 'blocs/cart_bloc.dart';
import 'blocs/home_bloc.dart';
import 'blocs/navigation_bloc.dart';
import 'screens/payment_screen.dart';
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
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        BlocProvider<OrderScreenBloc>(
          create: (context) => OrderScreenBloc(),
        ),
        BlocProvider<NotiScreenBloc>(
          create: (context) => NotiScreenBloc(),
        ),
        BlocProvider<BranchScreenBloc>(
          create: (context) => BranchScreenBloc(),
        ),
        BlocProvider<AddressScreenBloc>(
          create: (context) => AddressScreenBloc(),
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
          '/checkout': (context) => BlocProvider.value(
              value: context.read<HomeScreenBloc>(),
              child: const OrderScreen()),
          '/payment': (context) => PaymentScreen(),
          '/search': (context) => SearchScreen(),
          '/address': (context) => AddressScreen(),
          '/user-profile': (context) => UserProfileScreen(),
          '/orders': (context) => BlocProvider.value(
              value: context.read<OrderScreenBloc>(),
              child: const ListOrderScreen()),
          '/notification': (context) => BlocProvider.value(
              value: context.read<NotiScreenBloc>(),
              child: const ListNotiScreen()),
          '/branch': (context) => ListBranchScreen(),
          '/tadavina': (context) => TadavinaScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
