import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/branch_bloc.dart';
import '../events/branch_event.dart';
import '../models/branch.dart';
import '../states/branch_state.dart';

class ListBranchScreen extends StatefulWidget {
  const ListBranchScreen({super.key});

  @override
  State<ListBranchScreen> createState() => _ListBranchScreenState();
}

class _ListBranchScreenState extends State<ListBranchScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BranchScreenBloc>().add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<BranchScreenBloc, BranchScreenState>(
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
      child: BlocBuilder<BranchScreenBloc, BranchScreenState>(
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
                    child: state.branchs.length > 0
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (Branch item in state.branchs)
                                  BranchInfoWidget(
                                    branch: item,
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
            "Hệ thống nhà thuốc",
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

class BranchInfoWidget extends StatelessWidget {
  final Branch branch;

  BranchInfoWidget({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameRow(branch.name),
            SizedBox(height: 10.0),
            _buildAddressRow(branch.address),
            _buildOpenRow(branch.businessHours),
            _buildMapsRow(branch.link),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _buildNameRow(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: Color(0xff65AC4E),
            ),
          ),
          Icon(
            Icons.star_border_purple500_rounded,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.blueGrey,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenRow(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Icon(
              Icons.access_time,
              color: Colors.grey,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0xff65AC4E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapsRow(String url) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 40,
            child: Icon(
              Icons.map,
              color: Colors.grey,
            ),
          ),
          InkWell(
            onTap: ()async {
              if (!await launchUrl(Uri.parse(url))) {
                throw Exception('Could not launch $url');
              }
            },
            child: Text(
              "Chỉ đường",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
