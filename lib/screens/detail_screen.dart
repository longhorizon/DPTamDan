import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../blocs/cart_bloc.dart';
import '../blocs/home_bloc.dart';
import '../blocs/navigation_bloc.dart';
import '../const/const.dart';
import '../events/cart_event.dart';
import '../events/home_event.dart';
import '../events/navigation_event.dart';
import '../models/product.dart';
import 'contact_screen.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Product product;
  int tap = 1;
  late String userName;
  late String lastName;
  TextEditingController nameControlle = new TextEditingController();
  TextEditingController phoneControlle = new TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    product = widget.product;
    super.initState();
    fetchProductDetail(widget.product.slug);
  }

  @override
  void didUpdateWidget(covariant DetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.product.slug != oldWidget.product.slug) {
      if (widget.product.slug != "") {
        fetchProductDetail(widget.product.slug);
      }
    } else {
      fetchProductDetail(oldWidget.product.slug);
    }
  }

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return formatCurrency.format(amount);
  }

  Future<Product> fetchProductDetail(String slug) async {
    setState(() {
      isLoading = true;
    });
    var uri = Uri.https(Constants.apiUrl, 'api/client/product/detail');

    final Map<String, String> headers = {'Content-Type': 'text/plain'};
    final Map<String, dynamic> data = {'slug': slug};

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 200) {
        Product pro = Product.fromJson(jsonResponse['result']);
        setState(() {
          product = pro;
          isLoading = false;
        });
        return pro;
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load product detail');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load product detail');
    }
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(child: _buildSearchField()),
            ],
          ),
          const SizedBox(height: 16.0),
          isLoading ? Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) :
          Expanded(
            child: Stack(
              children: [
                _buildProductDetail(product),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildListButton(product),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetail(Product pro) {
    List<String> allImages = [pro.image, ...pro.gallery];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('images/ic-logo-sp-detai.png'),
          Container(
            color: const Color(0xfff7e7da),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                ProductImages(
                  images: allImages,
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    pro.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    formatCurrency(pro.price) + ' VND/' + pro.unit,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giá bao gồm thuế.',
                        ),
                        Text(
                            'Phí vận chuyển và các chi phí khác ( nếu có ) sẽ được hiển thị khi đặt hàng.'),
                      ]),
                ),
                SizedBox(height: 16),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hình thức giao hàng",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'Freeship ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  decoration: TextDecoration.none),
                            ),
                            TextSpan(
                              text: 'cho mọi đơn hàng ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  decoration: TextDecoration.none),
                            ),
                            TextSpan(
                              text: 'từ 00:01 ngày 01/11 đến 23:59 ngày 31/12',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, top: 2, right: 8, bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              'Viettel Post',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 8, top: 2, right: 8, bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              'Ahamove',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                tap = 1;
                              });
                            },
                            child: Text(
                              "Thông tin sản phẩm",
                              style: TextStyle(
                                color: tap == 1 ? Colors.blue : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                tap = 2;
                              });
                            },
                            child: Text(
                              "Thương hiệu",
                              style: TextStyle(
                                color: tap == 2 ? Colors.blue : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16),
                      tap == 1
                          ? _builDetail(pro.des)
                          : _builDetail(pro.attributes.length > 0
                              ? pro.attributes.first.value
                              : ""),
                    ],
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _builDetail(String container) {
    return HtmlWidget(container);
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       "Công dụng: ",
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     SizedBox(height: 16),
    //     Text(
    //       "Đối với người sử dụng: ",
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     SizedBox(height: 16),
    //     Text(
    //       "Thành phần chính: ",
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     SizedBox(height: 16),
    //     Text(
    //       "Hướng dẫn sử dụng: ",
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     SizedBox(height: 16),
    //   ],
    // );
  }

  Container _buildListButton(Product pro) {
    return Container(
      color: Colors.white,
      // width: 60,
      // padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute (
                  builder: (BuildContext context) => const ContactScreen(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 25),
              child: Image.asset(
                "images/tu-van-truc-tuyen.png",
                width: 35,
                height: 35,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.red),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<CartBloc>(context).add(AddToCart(pro));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã thêm vào giỏ hàng'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: SvgPicture.asset(
              "images/icons/them-vao-gio.svg",
              width: 30,
              height: 30,
            ),
          ),
          Container(
            width: 1,
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<CartBloc>(context).add(AddToCart(pro));
              Navigator.pushNamed(context, '/checkout');
            },
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.all(10),
              child: Text(
                'MUA NGAY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // height: 30,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 8.0),
                Flexible(
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm tên thuốc, bệnh lý, ...',
                        hintStyle: TextStyle(color: Color(0xffc7c7c7)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value != "") {
                          BlocProvider.of<HomeScreenBloc>(context)
                              .add(SearchEvent(value));
                          Navigator.pushNamed(context, "/search");
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
              context.read<NavigationBloc>().add(ChangeTabEvent(2));
            },
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ProductImages extends StatefulWidget {
  final List<String> images;

  ProductImages({required this.images});

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.white,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.images[index],
                fit: BoxFit.contain,
              );
            },
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                int index = widget.images.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
