import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserTab extends StatefulWidget {
  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: _buildBody(context),
        );
  }


  Widget _buildBody(BuildContext context) {
    return Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('images/home-bg.png'),
      fit: BoxFit.fill,
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Xử lý khi nhấn nút trở về
              },
            ),
            Text("Chỉnh sửa thông tin cá nhân", style: TextStyle(color: Colors.white)),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                // Xử lý khi nhấn thông báo
              },
            ),
          ],
        ),
      ),
      SizedBox(height: 16.0),
      Container(
        width: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              "Khách hàng tiêu dùng",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/avatar_default.jpg'), // Hình ảnh avatar mặc định
                  radius: 30,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Bấm cập nhật ảnh đại diện",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Họ và tên *", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Nhập họ và tên của bạn",
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Điện thoại *", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: "Nhập số điện thoại của bạn",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn nút Xác nhận
                },
                style: ElevatedButton.styleFrom(
                  // background: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Xác nhận", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    ],
  ),
);
}

  
}
