import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../blocs/order_bloc.dart';
import '../events/order_event.dart';
import '../models/order.dart';
import '../states/order_state.dart';
import 'order_detail_screen.dart';

class ListOrderScreen extends StatefulWidget {
  const ListOrderScreen({super.key});

  @override
  State<ListOrderScreen> createState() => _ListOrderScreenState();
}

class _ListOrderScreenState extends State<ListOrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderScreenBloc>().add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<OrderScreenBloc, OrderScreenState>(
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
      child: BlocBuilder<OrderScreenBloc, OrderScreenState>(
        builder: (context, state) {
          if (state is LoadedState) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/home-bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  _buildHead(context),
                  const SizedBox(height: 30.0),
                  Expanded(
                    child: state.orders.length > 0
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (Order item in state.orders)
                                  OrderInfoWidget(
                                    order: item,
                                  ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text("Bạn chưa thực hiện đơn hàng nào!"),
                          ),
                  ),
                ],
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

  Padding _buildHead(BuildContext context) {
    return Padding(
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
            "Đơn của tôi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 40),
        ],
      ),
    );
  }
}

class OrderInfoWidget extends StatelessWidget {
  final Order order;

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return formatCurrency.format(amount);
  }

  OrderInfoWidget({required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Navigator.of(context).push(MaterialPageRoute (
          builder: (BuildContext context) => OrderDetailScreen(id: order.id,),
        ));
        },
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.code,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    order.statusLabel,
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              Container(height: 2, color: Colors.grey[300]),
              SizedBox(height: 10.0),
              _buildInfoRow("Số sản phẩm:", order.total.toString()),
              _buildPriceRow("Tổng:", order.totalPrice.toString()),
              _buildPriceRow("Shipping:", order.feeShipping.toString()),
              _buildPriceRow("khuyến mãi:", order.discountPrice.toString()),
              _buildPriceRow("Thanh toán:", order.paymentPrice.toString()),
              _buildInfoRow("Ngày tạo:", order.createdAt),
              _buildStatusRow("Trạng thái thanh toán:", order.paymentStatusLabel),
              SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[400],
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[400],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[400],
            ),
          ),
          Text(
            // formatCurrency(value) + "VND/",
            value + " VND",
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
