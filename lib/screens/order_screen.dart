import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/cart_bloc.dart';
import '../events/cart_event.dart';
import '../models/cart_item.dart';
import '../states/cart_state.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<CartBloc>(context).add(LoadCartData());
  }

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartError && state.errorCode == 419) {
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
        } else if (state is CartLoaded && state.isAddDiscount) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(state.discount > 0 ? 'Thành công!' : 'Thất bại!'),
                content: Text(state.discount > 0
                    ? 'Bạn đã thêm mã khuyến mãi thành công.'
                    : 'Mã khuyến mãi không tồn tại!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
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
                          "Xác nhận đơn hàng",
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
                    child: state is CartLoaded
                        ? _buildCartList(
                            state.cartItems, state.total, state.discount)
                        : Center(
                            child: Text('Empty cart'),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    String code = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text("Mã giảm giá"),
          ),
          content: TextField(
            onChanged: (value) {
              code = value;
            },
            decoration: InputDecoration(hintText: "Nhập mã"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Huỷ"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Kiểm tra"),
              onPressed: () {
                if (code == "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Vui lòng nhập mã code!"),
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
                } else {
                  BlocProvider.of<CartBloc>(context)
                      .add(ApplyDiscountCode(discountCode: code));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCartList(List<CartItem> cartItems, int total, int voucher) {
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
              "Tổng hóa đơn cần thanh toán(${cartItems.length})",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var item in cartItems)
                  Column(
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
                                // borderRadius: BorderRadius.circular(8),
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
                  ),
              ],
            ),
          ),
        ),
        Container(
          height: 2,
          color: const Color(0xffdfdfdf),
        ),
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "images/ic-discount-small.png",
                    height: 30,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Mã giảm giá:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  _showInputDialog(context);
                },
                child: Text(
                  "Chọn hoặc nhập mã",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          color: const Color(0xffdfdfdf),
        ),
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tổng tiền hàng:"),
                Text(
                  formatCurrency(total) + " VND",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Giảm giá trực tiếp:"),
                Text(
                  formatCurrency(0) + " VND",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Giảm giá voucher:"),
                Text(
                  formatCurrency(voucher) + " VND",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tiết kiệm được:"),
                Text(
                  formatCurrency(voucher) + " VND",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Phí vận chuyển:"),
                Text(
                  "... VND",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Container(
              height: 2,
              color: const Color(0xffdfdfdf),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Thành tiền:"),
                Text(
                  formatCurrency(total - voucher) + " VND",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Điểm thưởng:"),
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
                      "+ 900",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffe8ae25),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
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
            onPressed: () {
              Navigator.pushNamed(context, '/payment');
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
