import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  late String userName;
  late String lastName;
  TextEditingController nameControlle = new TextEditingController();
  TextEditingController phoneControlle = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('user_name').toString();
    lastName = prefs.getString('last_name').toString();
    nameControlle.text = lastName;
    phoneControlle.text = userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/home-bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          const Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Center(
              child: Text(
                "Chỉnh sửa thông tin cá nhân",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Khách hàng tiêu dùng",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // const Row(
                //   children: [
                //     CircleAvatar(
                //       backgroundImage: AssetImage('images/avatar_default.png'),
                //       radius: 30,
                //     ),
                //     SizedBox(width: 16),
                //     Expanded(
                //       child: Text(
                //         "Bấm cập nhật ảnh đại diện",
                //         style: TextStyle(color: Colors.blue),
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AvatarUpdateRow(),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Họ và tên *",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameControlle,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Nhập họ và tên của bạn",
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Điện thoại *",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: phoneControlle,
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
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Xác nhận
                    },
                    style: ElevatedButton.styleFrom(
                      // background: Colors.red,
                      backgroundColor: Colors.red, // màu

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Xác nhận",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarUpdateRow extends StatefulWidget {
  @override
  _AvatarUpdateRowState createState() => _AvatarUpdateRowState();
}

class _AvatarUpdateRowState extends State<AvatarUpdateRow> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          // backgroundImage: _selectedImage != null
          //     ? FileImage(_selectedImage!)
          //     : AssetImage('images/avatar_default.jpg'),
          backgroundImage: _selectedImage != null
              ? FileImage(_selectedImage!)
              : AssetImage('images/avatar_default.png') as ImageProvider,

          radius: 30,
        ),
        SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: _pickImage,
            child: Text(
              "Bấm cập nhật ảnh đại diện",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
