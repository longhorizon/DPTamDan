import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/cart_bloc.dart';
import '../const/const.dart';
import '../states/cart_state.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedValue = '';
  List<Map<String, dynamic>> paymentMethods = [];

  @override
  void initState() {
    super.initState();
    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('user_id').toString();
    String token = prefs.getString('token').toString();
    var uri = Uri.https(Constants.apiUrl, 'api/client/payments');
    final response = await http.post(
      // Uri.parse('https://tamdan.devone.vn/api/client/payments'),
      uri,
      headers: {'Content-Type': 'text/plain'},
      body: jsonEncode({"uid": uid, "token": token}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 200) {
        setState(() {
          paymentMethods = List<Map<String, dynamic>>.from(data['result']);
        });
      } else {
        AlertDialog(
          title: Text('Lỗi'),
          content:
              Text('Không nhận được dữ liệu phương thức thanh toán từ server!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      }
    } else {
      AlertDialog(
        title: Text('Lỗi'),
        content: Text('Không thể kết nối với server!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/home-bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 16.0),
            Container(
              height: 56.0,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Phương thức thanh toán",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff7e7da),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _buildElement((state as CartLoaded).discode),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildElement(String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              color: const Color(0xffdfdfdf),
              padding: const EdgeInsets.all(8.0),
              margin: EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  "Chọn phương thức thanh toán",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              height: 350,
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: paymentMethods.length,
                itemBuilder: (BuildContext context, int index) {
                  final method = paymentMethods[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = method['id'];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        // border: Border(
                        //   bottom: BorderSide(color: Colors.grey),
                        // ),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Radio(
                            value: method['id'],
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value.toString();
                              });
                            },
                          ),
                          Container(
                            child: method['image'] != ''
                                ? Image.network(
                                    method['image'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.payment),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String uid = prefs.getString('user_id').toString();
              String token = prefs.getString('token').toString();
              if (selectedValue.isNotEmpty) {
                var uri =
                    Uri.https(Constants.apiUrl, 'api/client/cart/payment');
                Map<String, String> headers = {
                  'Content-Type': 'text/plain',
                };
                String body = jsonEncode({
                  'payment_id': selectedValue,
                  'discount_code': code,
                  'uid': uid,
                  'token': token,
                });

                try {
                  final response = await http.post(
                    uri,
                    headers: headers,
                    body: body,
                  );
                  if (response.statusCode == 200) {
                    var responseData = jsonDecode(response.body);
                    if (responseData['status'] == 419) {
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
                    else if(responseData['status'] == 200)
                      {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông báo'),
                              content: Text(responseData['message'] ?? ""),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    else if(responseData['status'] == 400)
                      {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thất bại'),
                              content: Text(responseData['message'] ?? ""),
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Lỗi'),
                          content: Text('Đã có lỗi xảy ra khi gửi dữ liệu!'),
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
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Đã có lỗi xảy ra khi gửi dữ liệu!'),
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
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Cảnh báo'),
                      content:
                          Text('Vui lòng chọn một phương thức thanh toán!'),
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "Xác nhận",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
