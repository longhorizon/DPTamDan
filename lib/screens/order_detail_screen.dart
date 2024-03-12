import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/order_bloc.dart';
import '../const/const.dart';
import '../events/order_event.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatefulWidget {
  String id;
  OrderDetailScreen({super.key, required this.id});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool isLoading = false;
  late Order order;
  List<CartItem> cartItems = [];
  int statusCode = 200;

  @override
  void initState() {
    super.initState();
    fetchProductDetail(widget.id);
  }

  List<CartItem> parseCartItemFromJson(List<dynamic> productsJson) {
    return productsJson
        .map((productJson) => CartItem.fromJson(productJson))
        .toList();
  }

  Future<Order> fetchProductDetail(String id) async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.https(Constants.apiUrl, 'api/client/order');

    final Map<String, String> headers = {'Content-Type': 'text/plain'};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('user_id').toString();
    String token = prefs.getString('token').toString();
    final Map<String, dynamic> data = {
      "id": id,
      "uid": uid,
      "token": token,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 419) {
        setState((){
          statusCode = 419;
        });
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
      if (jsonResponse['status'] == 400) {
        setState((){
          statusCode = 400;
        });
      }
      if (jsonResponse['status'] == 200) {
        Order _order = Order.fromJson(jsonResponse['result']);
        final List<CartItem> _cartItems = parseCartItemFromJson(jsonResponse['result']['pod']);
        setState(() {
          order = _order;
          cartItems = _cartItems;
          isLoading = false;
          statusCode = 200;
        });
        return _order;
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load order detail');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load order detail');
    }
  }

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ?
      Center(
        child: CircularProgressIndicator(),
      ) : statusCode == 200 ?
      _buildBody(context) :
      Center(
        child: Text("Lấy thông tin đơn hàng không thành công!"),
      ) ,
      floatingActionButton: _cancelButton(context),
    );
  }

  FloatingActionButton? _cancelButton(BuildContext context) {
    return (isLoading || statusCode != 200) ? null : !order.cancel ? null :
    FloatingActionButton(
      onPressed: () {
        _showInputDialog(context, order.id ?? "");
      },
      child: Icon(Icons.cancel_outlined, color: Colors.white, size: 40,),
      backgroundColor: Colors.blue,
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
                    order.code,
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
              child: order != null
                  ? _buildProductList(
                  cartItems, order)
                  : Center(
                child: Text('Empty cart'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<CartItem> cartItems, Order order) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xffdfdfdf),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              "Danh sách sản phẩm(${cartItems.length})",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var item in cartItems)
                  _productItem(item),
              ],
            ),
          ),
        ),
        Container(
          height: 4,
          color: Colors.white,
        ),
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tổng tiền:"),
                Text(
                  formatCurrency(order.totalPrice) + " VND",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 3.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mã giảm giá:"),
                Text(
                  order.discountCode,
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tổng giảm giá:"),
                Text(
                  formatCurrency(order.discountPrice) + " VND",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 3.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Phí giao hàng:"),
                Text(
                  formatCurrency(order.feeShipping) + " VND",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 3.0),
            Container(
              height: 2,
              color: const Color(0xffdfdfdf),
            ),
            const SizedBox(height: 3.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tổng thanh toán:"),
                Text(
                  formatCurrency(order.paymentPrice) + " VND",
                  style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ]),
        ),
        Container(
          height: 4,
          color: Colors.white,
        ),
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Thời gian đặt:"),
                Text(
                  order.createdAt,
                ),
              ],
            ),
            const SizedBox(height: 3.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tình trạng:"),
                Text(
                  order.statusLabel,
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 3.0),
            order.note != "" ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Note: "),
                Text(
                  order.note,
                ),
              ],
            ) : SizedBox.shrink(),
            const SizedBox(height: 30.0),
          ]),
        ),
        // Container(
        //   margin: const EdgeInsets.all(0),
        //   padding: const EdgeInsets.all(30),
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(15),
        //   ),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/payment');
        //     },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.red,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //     ),
        //     child: Text(
        //       "Xác nhận",
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _productItem(CartItem item) {
    return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.network(
                              item.product.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formatCurrency(item.product.price) + " VND",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "x${item.quantity}",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: const Color(0xffdfdfdf),
                    ),
                  ],
                );
  }

  cancelOrder(String id, String note) async {
    var uri = Uri.https(Constants.apiUrl, 'api/client/order/cancel');

    final Map<String, String> headers = {'Content-Type': 'text/plain'};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('user_id').toString();
    String token = prefs.getString('token').toString();
    final Map<String, dynamic> data = {
      "id": id,
      "uid": uid,
      "token": token,
      "note": note,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {print(response.body);
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 419) {
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
      if (jsonResponse['status'] == 400) {
        String mess = jsonResponse['message'];
        _showMessage("Thất bại", mess);
      }
      if (jsonResponse['status'] == 200) {
        String mess = jsonResponse['message'];
        _showMessage("Thành công", mess, isSuccess: true);
      } else {
        throw Exception('Failed to cancel order');
      }
    } else {
      throw Exception('Failed to cancel order');
    }
  }

  Future<dynamic> _showMessage(String title, String message, {bool isSuccess = false}) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if(isSuccess)
                  {
                    Navigator.of(context).pop();
                    context.read<OrderScreenBloc>().add(FetchDataEvent());
                  }
              },
              child: Text('ok'),
            ),
          ],
        ),
      );
  }

  void _showInputDialog(BuildContext context, String id,) {
    String note = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text("Huỷ đơn hàng"),
          ),
          content: TextField(
            onChanged: (value) {
              note = value;
            },
            decoration: InputDecoration(hintText: "Nhập lý do huỷ đơn"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Huỷ"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Xác nhận"),
              onPressed: () {
                cancelOrder(id, note,);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
