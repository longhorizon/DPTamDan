import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/home_bloc.dart';
import '../blocs/navigation_bloc.dart';
import '../const/const.dart';
import '../events/home_event.dart';
import '../events/navigation_event.dart';
import '../states/home_state.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  @override
  void initState() {
    super.initState();
    context.read<HomeScreenBloc>().add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {
        if (state is ErrorState && state.errorsCode == 419) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Phiên đăng nhập đã hết hạn'),
              content: Text('Vui lòng đăng nhập lại để tiếp tục.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('ok'),
                ),
              ],
            ),
          );
        }
      },
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          if (state is DataLoadedState) {
            return Scaffold(
              body: _buildBody(context, state),
            );
          }
          if (state is ErrorState) {
            final String e = state.errorMessage;
            print("lỗi: $e");
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DataLoadedState state) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/home-bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      padding: const EdgeInsets.only(
        top: 30,
      ),
      child: ListView(
        children: [
          // const SizedBox(height: 16.0),
          _buildHeader(),
          const SizedBox(height: 16.0),
          _buildUserInfo(
              state.user.name, state.user.avatarUrl, state.user.username),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xfff7e7da),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Đơn của tôi",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/orders');
                      },
                      child: Text(
                        "Xem tất cả",
                        style: TextStyle(
                          color: Color(0xff3c58e4),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffebebeb),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.black54),
                  ),
                  padding: EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _deliveryItem("Đang xử lý", "images/ic-dang-xu-ly.png"),
                      _deliveryItem(
                          "Đang giao", "images/ic-dang-giao-hang.png"),
                      _deliveryItem("Đã giao", "images/ic-da-giao-hang.png"),
                      _deliveryItem("Đổi/Trả", "images/ic-doi-tra.png"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Tài khoản",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffebebeb),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Column(
                    children: [
                      _lableItem("Thông tin cá nhân", "images/ic-tai-khoan.png",
                          "/user-profile"),
                      _lableItem(
                          "Quản lý sổ địa chỉ", "images/ic-location.png", "/address"),
                      _lableItem("Lịch sử mua hàng",
                          "images/ic-lich-su-don-hang.png", "/orders"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Về nhà thuốc",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffebebeb),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Column(
                    children: [
                      _lableItem("Về Tadavina",
                          "images/ic-tai-khoan-nha-thuoc.png", ""),
                      _lableItem(
                          "Hệ thống nhà thuốc",
                          "images/ic-tai-khoan-chi-nhanh-nha-thuoc.png",
                          "/branch"),
                      _lableItem(
                        "Sản phẩm",
                        "images/ic-tai-khoan-san-pham.png",
                        "",
                        ontap: () {
                          context.read<NavigationBloc>().add(ChangeTabEvent(1));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      child: Text(
                        "Đăng xuất",
                        style: TextStyle(
                          color: Color(0xffd10d0d),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryItem(String lable, String image, {onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            Image.asset(
              image,
              width: 40,
              height: 40,
            ),
            Text(
              lable,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _lableItem(String lable, String image, String path,
      {Function()? ontap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 6,
        bottom: 6,
      ),
      child: InkWell(
        onTap: ontap ??
            () {
              if (path != "") {
                Navigator.pushNamed(context, path).then((value) {
                  context.read<HomeScreenBloc>().add(FetchDataEvent());
                });
              }
            },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  image,
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 8),
                Text(
                  lable,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              "Thông tin tài khoản",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String name, String avatar, String username) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xfff7e7da),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            // backgroundImage: _selectedImage != null
            //     ? FileImage(_selectedImage!)
            //     : AssetImage('images/avatar_default.jpg'),
            backgroundImage: avatar != ""
                ? NetworkImage(avatar)
                : AssetImage('images/avatar_default.png') as ImageProvider,

            radius: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name == "null" ? "" : name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                username,
              ),
            ],
          ),
          SizedBox(width: 1),
          SizedBox(width: 1),
          SizedBox(width: 1),
          Row(
            children: [
              Image.asset(
                'images/ic-dong-xu.png',
                width: 16,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                '0',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xffe8ae25),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
