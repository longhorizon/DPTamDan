import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../blocs/address_bloc.dart';
import '../events/address_event.dart';
import '../models/address.dart';
import '../states/address_state.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isLoading = false;
  int statusCode = 200;

  final List<String> items = ['Option 1', 'Option 2', 'Option 3'];
  String selectedValue1 = 'Option 1';
  String selectedValue2 = 'Option 1';
  String inputValue = '';
  @override
  void initState() {
    super.initState();
    context.read<AddressScreenBloc>().add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      floatingActionButton: _addButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<AddressScreenBloc, AddressScreenState>(
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
      child: BlocBuilder<AddressScreenBloc, AddressScreenState>(
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
                    child: state.addresses.length > 0
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (Address item in state.addresses)
                                  AddressWidget(
                                    address: item,
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
        _showAddModal(context);
      },
      child: Icon(Icons.add, color: Colors.white, size: 40,),
      backgroundColor: Colors.blue,
    );
  }

  void _showAddModal(BuildContext context) {
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
                    // DropdownButtonFormField<String>(
                    //   value: selectedValue1,
                    //   onChanged: (String? value) {
                    //     if (value != null) {
                    //       setState(() {
                    //         selectedValue1 = value;
                    //       });
                    //     }
                    //   },
                    //   items: items.map((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   decoration: InputDecoration(labelText: 'Tỉnh/TP'),
                    // ),
                    // SizedBox(height: 16),
                    // DropdownButtonFormField<String>(
                    //   value: selectedValue2,
                    //   onChanged: (String? value) {
                    //     if (value != null) {
                    //       setState(() {
                    //         selectedValue2 = value;
                    //       });
                    //     }
                    //   },
                    //   items: items.map((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   decoration: InputDecoration(labelText: 'Quận/Huyện'),
                    // ),
                    // SizedBox(height: 16),
                    // DropdownButtonFormField<String>(
                    //   value: selectedValue2,
                    //   onChanged: (String? value) {
                    //     if (value != null) {
                    //       setState(() {
                    //         selectedValue2 = value;
                    //       });
                    //     }
                    //   },
                    //   items: items.map((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   decoration: InputDecoration(labelText: 'Phường/Xã'),
                    // ),
                    // SizedBox(height: 16),
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
                // print('Tỉnh/TP: $selectedProvince');
                // print('Phường/Xã: $selectedDistrict');
                // print('Địa chỉ: $address');
                context.read<AddressScreenBloc>().add(AddAddressEvent(address: address));
                Navigator.of(context).pop();
                context.read<AddressScreenBloc>().add(FetchDataEvent());
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
  final Address address;
  AddressWidget({required this.address});

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
            _buildInfoRow("Địa chỉ:", address.address),
            // _buildInfoRow("Phường/Xã:", address.infoAddress),
            // _buildInfoRow("Quận/Huyện:", address.infoAddress),
            // _buildInfoRow("Tỉnh/TP:", address.infoAddress),
            Container(height: 2, color: Colors.grey[300]),
            SizedBox(height:12,),
            SizedBox(height: 6.0),
            buildCardButton(context, address),
          ],
        ),
      ),
    );
  }

  Widget buildCardButton(BuildContext context ,Address address) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4,),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      _showEditModal(context, address);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.mode_edit_outline_outlined, color: Colors.white),
                        SizedBox(width: 4.0),
                        Text("Chỉnh sửa", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap:(){
                    _showDeleteModal(context, address);
                  },
                  child: Container(
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
                ),
              ],
            );
  }

  _showEditModal(BuildContext context, Address addr) {
    TextEditingController addressController = TextEditingController(text: addr.address);
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
                    TextFormField(
                      controller: addressController,
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
                String address = addressController.text;
                context.read<AddressScreenBloc>().add(UpdateAddressEvent(address: address, id: addr.id));
                Navigator.of(context).pop();
                context.read<AddressScreenBloc>().add(FetchDataEvent());
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  _showDeleteModal(BuildContext context, Address addr) {
    TextEditingController addressController = TextEditingController(text: addr.address);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xoá địa chỉ'),
          content: Text("Bạn muốn xoá địa chỉ này?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Huỷ'),
            ),
            ElevatedButton(
              onPressed: () {
                String address = addressController.text;
                context.read<AddressScreenBloc>().add(DeleteAddressEvent(id: addr.id));
                Navigator.of(context).pop();
                context.read<AddressScreenBloc>().add(FetchDataEvent());
              },
              child: Text('Xoá'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
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
}
