import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../blocs/branch_bloc.dart';
import '../events/branch_event.dart';
import '../models/branch.dart';
import '../states/branch_state.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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

  Widget _buildBody(BuildContext context) {
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
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              children: [
                _buildContactCard("images/tu-van-truc-truyen-1.jpeg", label1: 'Chat cùng DPTamDan', label2: 'Hỗ trợ nhanh chóng', TextButton: "Chat ngay",),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          _buildContactCard("images/tu-van-truc-tuyen2.jpeg", label1: 'Liên hệ dược sỹ', label2: 'Tư vấn miễn phí', TextButton: "Gọi ngay",),
          const SizedBox(height: 40.0),
        ],
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
            "Tư vấn trực tuyến",
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

  Container _buildContactCard(String image, { String label1 = "", String label2 = "", String TextButton = ""}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.blueGrey.shade200),
      ),
      margin: EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Image.asset(
                image,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 12.0),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label1,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        label2,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      TextButton,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8.0),
      //   side: BorderSide(color: Colors.grey, width: 2.0),
      // ),
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
              color: Colors.grey,
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
        children: [
          SizedBox(
            width: 40,
            child: Icon(
              Icons.map,
              color: Colors.grey,
            ),
          ),
          Text(
            "Chỉ đường",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

}
