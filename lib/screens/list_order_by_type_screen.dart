import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../blocs/order_bloc.dart';
import '../events/order_event.dart';
import '../models/order.dart';
import '../states/order_state.dart';
import 'order_detail_screen.dart';

class ListOrderByTypeScreen extends StatefulWidget {
  int type;
  ListOrderByTypeScreen({super.key, required this.type});

  @override
  State<ListOrderByTypeScreen> createState() => _ListOrderByTypeScreenState();
}

class _ListOrderByTypeScreenState extends State<ListOrderByTypeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderScreenBloc>().add(FetchDataEvent(type: widget.type));
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
                            child: Text("Không có gì ở đây!"),
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
            widget.type == 0 ? "Đơn đang xử lý" : widget.type == 1 ? "Đơn đang giao" : widget.type == 3 ? "Đơn đã giao" : "Đổi trả"  ,
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
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.0),
              softWrap: true,
            ),
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
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.blue,
              ),
              softWrap: true,
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
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              // formatCurrency(value) + "VND/",
              value + " VND",
              style: TextStyle(color: Colors.red, fontSize: 14.0),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}