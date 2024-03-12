import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/home_bloc.dart';
import '../const/const.dart';
import '../states/home_state.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mstController = TextEditingController();
  TextEditingController gdpController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String avatar = "";
  String mst_image = "";
  String gpdkkd = "";
  String gdp_gpp = "";
  String diploma = "";
  String avatar_url = "";
  String mst_image_url = "";
  String gpdkkd_url = "";
  String gdp_gpp_url = "";
  String diploma_url = "";
  bool isDataLoaded = false;

  bool isChecked = true;

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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Chỉnh sửa thông tin cá nhân",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is DataLoadedState) {
          if (!isDataLoaded) {
            nameController.text = state.user.name;
            phoneController.text = state.user.phone;
            emailController.text = state.user.email;
            mstController.text = state.user.mst;
            gdpController.text = state.user.gdpGpp;
            addressController.text = state.user.address;
            avatar = state.user.avatar ?? "";
            mst_image = state.user.mstImage ?? "";
            gpdkkd = state.user.gpdkkd ?? "";
            gdp_gpp = state.user.gdpGppDuration ?? "";
            diploma = state.user.diploma ?? "";
            avatar_url = state.user.avatarUrl ?? "";
            mst_image_url = state.user.mstImageUrl ?? "";
            gpdkkd_url = state.user.gpdkkdUrl ?? "";
            gdp_gpp_url = state.user.gdpGppDurationUrl ?? "";
            diploma_url = state.user.diplomaUrl ?? "";
            isDataLoaded = true;
          }
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/home-bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Chỉnh sửa thông tin cá nhân",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            width:
                                40), // Điều chỉnh khoảng cách giữa icon và text
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: state.user.role == "9"
                        ? _bodyRole9(context)
                        : state.user.role == "8"
                            ? _bodyRole8(context)
                            : _bodyRole7(context),
                  ),
                ],
              ),
            ),
          );
        } else
          return SizedBox.shrink();
      },
    );
  }

  Widget _bodyRole7(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _selectAvatar(
            avatar_url,
            onImageSelected: (selectedImage) {
              _uploadImage(selectedImage).then((value) {
                setState(() {
                  var data = jsonDecode(value);
                  avatar = data['image'];
                  avatar_url = data['image_url'];
                });
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Họ và tên *", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Nhập họ và tên của bạn",
                ),
              ),
              const SizedBox(height: 16),
              const Text("Điện thoại *", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Nhập số điện thoại của bạn",
                ),
              ),
              const SizedBox(height: 16),
              _customField(
                "Địa chỉ nhận hàng *",
                addressController,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String token = prefs.getString('token').toString();
              String name = nameController.text;
              String phone = phoneController.text;
              String address = addressController.text;
              var uri =
                  Uri.https(Constants.apiUrl, 'api/client/profile/update');
              final headers = {'Content-Type': 'text/plain'};
              final body = {
                'token': token,
                'avatar': avatar,
                'name': name,
                'phone': phone,
                'address': address
              };

              postData(jsonEncode(body));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                const Text("Xác nhận", style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _bodyRole8(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Khách hàng nhà thuốc/Bác sĩ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _selectAvatar(
            avatar_url,
            onImageSelected: (selectedImage) {
              _uploadImage(selectedImage).then((value) {
                setState(() {
                  var data = jsonDecode(value);
                  avatar = data['image'];
                  avatar_url = data['image_url'];
                });
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customField(
                "Họ và tên *",
                nameController,
              ),
              const SizedBox(height: 16),
              _customField(
                "Email *",
                emailController,
              ),
              const SizedBox(height: 16),
              imagePickerField(
                'Ảnh giấy phép kinh doanh *',
                gpdkkd_url,
                onImageSelected: (selectedImage) {
                  _uploadImage(selectedImage).then((value) {
                    setState(() {
                      var data = jsonDecode(value);
                      gpdkkd = data['image'];
                      gpdkkd_url = data['image_url'];
                    });
                  });
                },
              ),
              const SizedBox(height: 16),
              _customField(
                "Mã số thuế *",
                mstController,
              ),
              const SizedBox(height: 16),
              imagePickerField(
                'Ảnh giấy đăng ký mã số thuế *',
                mst_image_url,
                onImageSelected: (selectedImage) {
                  _uploadImage(selectedImage).then((value) {
                    setState(() {
                      var data = jsonDecode(value);
                      mst_image = data['image'];
                      mst_image_url = data['image_url'];
                    });
                  });
                },
              ),
              const SizedBox(height: 16),
              _customDateField(
                context,
                gdpController,
                "Thời hạn GDP/GPP *",
              ),
              const SizedBox(height: 16),
              imagePickerField(
                'Ảnh GDP/GPP *',
                gdp_gpp_url,
                onImageSelected: (selectedImage) {
                  _uploadImage(selectedImage).then((value) {
                    setState(() {
                      var data = jsonDecode(value);
                      gdp_gpp = data['image'];
                      gdp_gpp_url = data['image_url'];
                    });
                  });
                },
              ),
              const SizedBox(height: 16),
              imagePickerField(
                'Ảnh bằng Dược sĩ/Bác sĩ *',
                diploma_url,
                onImageSelected: (selectedImage) {
                  _uploadImage(selectedImage).then((value) {
                    setState(() {
                      var data = jsonDecode(value);
                      diploma = data['image'];
                      diploma_url = data['image_url'];
                    });
                  });
                },
              ),
              const SizedBox(height: 16),
              _customField(
                "Địa chỉ kinh doanh *",
                addressController,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String token = prefs.getString('token').toString();
              String name = nameController.text;
              String email = emailController.text;
              String mst = mstController.text;
              // String mst_image = "";
              // String gpdkkd = "";
              String gdp = gdpController.text;
              // String gdp_gpp = "";
              // String diploma = "";
              String address = addressController.text;
              final body = {
                'token': token,
                'avatar': avatar,
                'name': name,
                'info_email': email,
                "mst": mst,
                "mst_image": mst_image,
                "gpdkkd": gpdkkd,
                "gdp_gpp_duration": gdp_gpp,
                "gdp_gpp": gdp,
                "diploma": diploma,
                "address": address
              };
              postData(jsonEncode(body));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                const Text("Xác nhận", style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _bodyRole9(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Khách hàng bệnh viện",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _selectAvatar(
            avatar_url,
            onImageSelected: (selectedImage) {
              _uploadImage(selectedImage).then((value) {
                setState(() {
                  var data = jsonDecode(value);
                  avatar = data['image'];
                  avatar_url = data['image_url'];
                });
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customField(
                "Tên bệnh viện *",
                nameController,
              ),
              const SizedBox(height: 12),
              _customField(
                "Số điện thoại *",
                phoneController,
              ),
              const SizedBox(height: 12),
              _customField(
                "Email *",
                emailController,
              ),
              const SizedBox(height: 12),
              _customField(
                "Mã số thuế *",
                mstController,
              ),
              const SizedBox(height: 12),
              _customDateField(
                context,
                gdpController,
                "Thời hạn GDP/GPP *",
              ),
              const SizedBox(height: 12),
              _customField(
                "Địa chỉ kinh doanh *",
                addressController,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text("Tôi đồng ý giao hàng online cho khách hàng tiêu dùng *")),
                  Container(
                    width: 40,
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: ElevatedButton(
            onPressed: () async {
              if(!isChecked){
                _showDialog(context, 'Thất bại', "Bạn chưa chấp thuận giao hàng online cho người tiêu dùng!");
                return;
              }
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String token = prefs.getString('token').toString();
              String name = nameController.text;
              String email = emailController.text;
              String phone = phoneController.text;
              String mst = mstController.text;
              String gdp_gpp = gdpController.text;
              String address = addressController.text;
              var uri =
                  Uri.https(Constants.apiUrl, 'api/client/profile/update');
              final headers = {'Content-Type': 'text/plain'};
              final body = {
                'token': token,
                'avatar': avatar,
                'info_name': name,
                'info_email': email,
                'info_phone': phone,
                'contract_duration': "0000-00-00 00:00:00",
                "mst": mst,
                "gdp_gpp": gdp_gpp,
                "address": address
              };
              postData(jsonEncode(body));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                const Text("Xác nhận", style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  postData(String body) async {
    var uri = Uri.https(Constants.apiUrl, 'api/client/profile/update');
    final headers = {'Content-Type': 'text/plain'};

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('API call successful');
        final data = jsonDecode(response.body);
        if (data['status'] == 200) {
          _showDialog(context, 'Thành công', data['message']);
        } else if (data['status'] == 400) {
          String errors = "";
          Map<String, dynamic> result = data['result'];
          for (var value in result.values) {
            errors = errors + "\n   $value";
          }
          _showDialog(context, 'Thất bại', data['message'] + errors);
        } else {
          _showDialog(context, 'Thất bại', data['message']);
        }
      } else {
        print('API call failed with status ${response.statusCode}');
        _showDialog(context, 'Thất bại', 'Không thể kết nối với server!');
      }
    } catch (error) {
      print('Error during API call: $error');
      _showDialog(context, 'Thất bại', 'Đã có lỗi sảy ra!');
    }
  }

  TextField _customDateField(
      BuildContext context, TextEditingController gdpController, String label) {
    return TextField(
      controller: gdpController,
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey, // Đổi màu chữ tại đây
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          String formattedDate =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDate);
          setState(() {
            gdpController.text = formattedDate;
          });
        } else {
          print("Date is not selected");
        }
      },
    );
  }

  Future<dynamic> _showDialog(
      BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _customField(
    String label,
    TextEditingController controller, {
    String hintText = "",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Widget _selectAvatar(String url, {required Function(File?) onImageSelected}) {
    File? _selectedImage;

    Future<void> _pickImage() async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        onImageSelected(_selectedImage);
      }
    }

    return Row(
      children: [
        CircleAvatar(
          backgroundImage: url != ""
              ? NetworkImage(url)
              : AssetImage('images/avatar_default.png') as ImageProvider,
          radius: 30,
        ),
        SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: _pickImage,
            child: Text(
              "Bấm cập nhật ảnh đại diện",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget imagePickerField(String label, String url,
      {required Function(File?) onImageSelected}) {
    File? _selectedImage;

    Future<void> _pickImage() async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        onImageSelected(_selectedImage);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: url != ""
                  ? Image.network(
                      url,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey[600],
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(8),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<String> _uploadImage(File? _selectedImage) async {
    if (_selectedImage == null) {
      return "";
    }
    String url = "";
    final bytes = await _selectedImage!.readAsBytes();
    final base64Image = base64Encode(bytes);
    final mime = lookupMimeType(_selectedImage!.path);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    var uri = Uri.https(Constants.apiUrl, 'api/client/upload');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': base64Image,
        'token': token,
        'name': 'avatar_image',
        'mime': mime ?? 'image/jpeg',
        'size': bytes.length,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 200) {
        url = jsonEncode(data['result']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hình ảnh đã được tải lên thành công'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Tải hình ảnh lên không thành công: ${data['message']}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi khi tải lên hình ảnh'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return url;
  }
}
