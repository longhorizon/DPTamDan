import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/cart_bloc.dart';
import '../events/cart_event.dart';
import '../models/cart_item.dart';
import '../states/cart_state.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartBloc>(context).add(LoadCartData());
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
          if (state is CartError) {
            return Scaffold(
              body: Center(
                child: Text("Đã xảy ra sự cố!"),
              ),
            );
          } else if (state is CartLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
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
                      "Giỏ hàng",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height - 200,
                    decoration: BoxDecoration(
                      color: const Color(0xfff7e7da),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.only(top: 16),
                    child: state is CartLoaded && state.cartItems.isNotEmpty
                        ? _buildCartList(state.cartItems, state.total,
                            state.total - state.discount)
                        : Center(
                            child: Text('Giỏ hàng trống'),
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

  Widget _buildCartList(
      List<CartItem> cartItems, int total, int discountPrice) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "images/ic-discount.png",
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Khuyến mại",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Dành riêng cho bạn",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _enterdiscount(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Chọn ngay",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color(0xffdfdfdf),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Checkbox(
                    //   value: _isAllSelected(cartItems),
                    //   onChanged: (value) {},
                    // ),
                    Text(
                      // "Chọn tất cả (${_selectedItemCount(cartItems)}/${cartItems.length})",
                      "Tổng sản phẩm (${cartItems.length})",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView(
                  children: [
                    for (var item in cartItems)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Checkbox(
                                //   value: item.isSelected,
                                //   onChanged: (value) {
                                //   },
                                // ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        formatCurrency(item.product.price) +
                                            " VND",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      _buildButtonUdateQuantity(item),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete_outline),
                                      onPressed: () {
                                        BlocProvider.of<CartBloc>(context)
                                            .add(RemoveItem(item.product.id));
                                      },
                                    ),
                                    Text('Xóa'),
                                  ],
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
            ],
          ),
          Container(
            // margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _enterdiscount(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.only(
                      left: 16,
                      top: 8,
                      right: 16,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
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
                            SizedBox(width: 4),
                            Text('Chọn hoặc nhập mã giảm giá',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                )),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.red),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tổng tiền:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatCurrency(total) + " VND",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  color: const Color(0xffdfdfdf),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Tạm tính:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency(discountPrice) + " VND",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/checkout');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Mua ngay",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonUdateQuantity(CartItem item) {
    return Container(
      height: 30,
      width: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (item.quantity > 1) {
                BlocProvider.of<CartBloc>(context).add(UpdateCartItemQuantity(
                  item.product.id,
                  --item.quantity,
                ));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey),
                ),
              ),
              child: Icon(Icons.remove),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${item.quantity}',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<CartBloc>(context).add(UpdateCartItemQuantity(
                item.product.id,
                ++item.quantity,
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey),
                ),
              ),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  bool _isAllSelected(List<CartItem> cartItems) {
    for (var item in cartItems) {
      if (!item.isSelected) {
        return false;
      }
    }
    return true;
  }

  int _selectedItemCount(List<CartItem> cartItems) {
    int count = 0;
    for (var item in cartItems) {
      if (item.isSelected) {
        count++;
      }
    }
    return count;
  }

  String calculateTotalPrice(List<CartItem> cartItems) {
    double totalPrice = 0;
    for (var item in cartItems) {
      if (item.isSelected) {
        totalPrice += item.product.price * item.quantity;
      }
    }
    return '${totalPrice.toStringAsFixed(2)} VND';
  }

  void _enterdiscount(BuildContext context) {
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
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text("Processing..."),
                          ],
                        ),
                      );
                    },
                  );
                  BlocProvider.of<CartBloc>(context)
                      .add(ApplyDiscountCode(discountCode: code));
                  Navigator.of(context).pop();
                }
                // String mess = discount > 0 ? 'Thêm mã giảm giá thành công!' : 'Mã không hợp lệ!';
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       title: Text(mess),
                //       actions: [
                //         TextButton(
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //           child: Text('OK'),
                //         ),
                //       ],
                //     );
                //   },
                // );
              },
            ),
          ],
        );
      },
    );
  }
}
