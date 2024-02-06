import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation_bloc.dart';
import '../states/navigation_state.dart';
import '../events/navigation_event.dart';
import './home_tab.dart';

class HomeScreen extends StatelessWidget {
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
          body: _buildBody(tabIndex),
          bottomNavigationBar: _buildCustomBottomNavBar(context),
        );
      },
    );
  }

  Widget _buildCustomBottomNavBar(BuildContext context) {
    final state = context.watch<NavigationBloc>().state;

    return Container(
      decoration: BoxDecoration(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              "images/icons/giohang-menu.svg",
              'Tài khoản',
              3,
              state,
            ),
          ],
        ),
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
        padding: EdgeInsets.all(8.0),
        // decoration: isSelected
        //     ? BoxDecoration(
        //         border: Border(
        //           top: BorderSide(width: 2.0, color: Colors.white),
        //           bottom: BorderSide(width: 2.0, color: Colors.white),
        //         ),
        //       )
        //     : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   icon,
            //   color: isSelected ? Colors.white : Colors.grey,
            // ),
            Container(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                width: 30,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
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
        return HomeTab();
        return Center(
          child: Text("ho"),
        );
      case 1:
        return Center(
          child: Text("Sản phẩm"),
        );
      case 2:
        return Center(
          child: Text("Giỏ hàng"),
        );
      case 3:
        return Center(
          child: Text("Cài đặt"),
        );
      default:
        return HomeTab();
    }
  }
}
