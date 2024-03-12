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

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isLoading = false;
  int statusCode = 200;

  final List<String> items = ['Option 1', 'Option 2', 'Option 3'];
  String selectedValue1 = 'Option 1'; // Giá trị mặc định của dropdown 1
  String selectedValue2 = 'Option 1'; // Giá trị mặc định của dropdown 2
  String inputValue = ''; // Giá trị mặc định của input field
  @override
  void initState() {
    super.initState();
    context.read<OrderScreenBloc>().add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      floatingActionButton: _addButton(context),
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
                                  AddressWidget(
                                    order: item,
                                  ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text("Danh sách địa chỉ chưa được thêm!"),
                          ),
                  ),
                  SizedBox(height: 50.0),
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
            "Sổ địa chỉ",
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

  FloatingActionButton? _addButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showInputDialog(context);
      },
      child: Icon(Icons.add, color: Colors.white, size: 40,),
      backgroundColor: Colors.blue,
    );
  }

  void _showInputDialog(BuildContext context) {
    String selectedProvince = '';
    String selectedDistrict = '';
    String address = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quản lý địa chỉ'),
          content: Container(
            padding: EdgeInsets.all(12),
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.88,
            child: Material(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedValue1,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            selectedValue1 = value;
                          });
                        }
                      },
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Tỉnh/TP'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedValue2,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            selectedValue2 = value;
                          });
                        }
                      },
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Quận/Huyện'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedValue2,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            selectedValue2 = value;
                          });
                        }
                      },
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Phường/Xã'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      onChanged: (String value) {
                        setState(() {
                          address = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Địa chỉ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                print('Tỉnh/TP: $selectedProvince');
                print('Phường/Xã: $selectedDistrict');
                print('Địa chỉ: $address');
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

}

class AddressWidget extends StatelessWidget {
  final Order order;
  AddressWidget({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Số nhà:", order.infoAddress),
            _buildInfoRow("Phường/Xã:", order.infoAddress),
            _buildInfoRow("Quận/Huyện:", order.infoAddress),
            _buildInfoRow("Tỉnh/TP:", order.infoAddress),
            Container(height: 2, color: Colors.grey[300]),
            SizedBox(height: 6.0),
            buildCardButton(),
          ],
        ),
      ),
    );
  }

  Row buildCardButton() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4,),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mode_edit_outline_outlined, color: Colors.white),
                      SizedBox(width: 4.0),
                      Text("Chỉnh sửa", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4,),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.white),
                      SizedBox(width: 4.0),
                      Text("Xoá", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ],
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
}
