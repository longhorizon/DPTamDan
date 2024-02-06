import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String name = "lan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          // Xử lý sự kiện mở left menu
        },
      ),
      title: Text(
        'DPTamDan',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // Xử lý sự kiện mở thông báo
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/home-bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          children: [
            SizedBox(height: 16.0),
            Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    Text("DPTamDan", style: TextStyle(color: Colors.white)),
                    Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ],
                )),
            SizedBox(height: 16.0),
            _buildSearchField(),
            SizedBox(height: 16.0),
            _buildUserInfo(),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.zero,
              child: Image.asset(
                "images/banner.jpg",
                width: double.infinity,
              ),
            ),
            SizedBox(height: 16.0),
            _buildServiceDivider(),
            SizedBox(height: 16.0),
            _buildServiceGridView(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8.0),
            Text(
              'Tìm tên thuốc, bệnh lý, ...',
              style: TextStyle(color: Color(0xffc7c7c7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Color(0xfff7e7da),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Xin chào, ',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Text(
                name ?? "",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                '10',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xffe8ae25)),
              ),
              SizedBox(width: 4.0),
              Text('điểm thưởng'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.red,
            height: 2.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'DỊCH VỤ',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.red,
            height: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceGridView() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 32,
        right: 32,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildServiceItem(index);
        },
      ),
    );
  }

  Widget _buildServiceItem(int index) {
    List<Map<String, dynamic>> serviceItems = [
      {'icon': "images/icons/nhathuoc.svg", 'text': 'Nhà thuốc'},
      {'icon': "images/icons/thuoc-trangchu.svg", 'text': 'Thuốc'},
      {
        'icon': "images/icons/thucphamchucnang-trangchu.svg",
        'text': 'Thực phẩm chức năng'
      },
      {'icon': "images/icons/voucher.svg", 'text': 'Voucher'},
      {'icon': "images/icons/thuvienbenhly.svg", 'text': 'Thư viện bệnh lý'},
      {'icon': "images/icons/tuvantructuyen.svg", 'text': 'Tư vấn trực tuyến'},
    ];

    return Container(
      // color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // color: Colors.red,
              ),
              padding: EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                serviceItems[index]['icon'],
                // height: 32.0,
                // width: 32.0,
                color: Color(0xffb33535),
              ),
            ),
          ),
          // SizedBox(height: 4.0),
          Expanded(
            child: Text(
              serviceItems[index]['text'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Color(0xff5b5b5b),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
