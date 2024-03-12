import 'package:DPTamDan/screens/product_tab.dart';
import 'package:DPTamDan/screens/user_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation_bloc.dart';
import '../states/home_state.dart';
import '../states/navigation_state.dart';
import '../events/navigation_event.dart';
import './home_tab.dart';
import 'cart_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int tabIndex = 0;
        if (state is TabChangedState) {
          tabIndex = state.tabIndex;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              _buildBody(tabIndex),
              if (state is LoadingState)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          bottomNavigationBar: _buildCustomBottomNavBar(context),
        );
      },
    );
  }

  Widget _buildCustomBottomNavBar(BuildContext context) {
    final state = context.watch<NavigationBloc>().state;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffc34238), Color(0xffc34238)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red,
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            "images/icons/trangchu.svg",
            'Trang chủ',
            0,
            state,
          ),
          _buildNavItem(
            context,
            "images/icons/sanpham-menu.svg",
            'Sản phẩm',
            1,
            state,
          ),
          _buildNavItem(
            context,
            "images/icons/giohang-menu.svg",
            'Giỏ hàng',
            2,
            state,
          ),
          _buildNavItem(
            context,
            "images/icons/user-circle.svg",
            'Tài khoản',
            3,
            state,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String icon,
    String label,
    int index,
    NavigationState state,
  ) {
    final isSelected = (state is TabChangedState) && (state.tabIndex == index);

    return InkWell(
      onTap: () {
        context.read<NavigationBloc>().add(ChangeTabEvent(index));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8, top:16, right: 8, bottom: 12),
        decoration: isSelected
            ? BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/nav-bg.jpg'),
              fit: BoxFit.fitHeight,
            ),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   icon,
            //   color: isSelected ? Colors.white : Colors.grey,
            // ),
            SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                icon,
                color: Colors.white,
                width: 30,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return ProductTab();
      case 2:
        return const CartTab();
      case 3:
        return const UserTab();
      default:
        return const HomeTab();
    }
  }
}
