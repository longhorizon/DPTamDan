import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/cart_bloc.dart';
import '../blocs/home_bloc.dart';
import '../events/cart_event.dart';
import '../events/home_event.dart';
import '../models/product.dart';
import '../states/cart_state.dart';
import '../states/home_state.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
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
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          if (state is SearchState) {
            searchController.text = state.key;
            final List<Product> products = state.products;
            return Scaffold(
              body: _buildBody(context, products),
            );
          }
          if (state is ErrorState) {
            final String e = state.errorMessage;
            print("lỗi: $e");
            return Scaffold(
              body: Center(
                child: Text("Đã xảy ra sự cố!"),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Product> products) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/home-bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              _buildHeader(),
              const SizedBox(height: 16.0),
              _buildSearchField(),
              const SizedBox(height: 16.0),
              ProductContainer(
                products: products,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
                context.read<HomeScreenBloc>().add(FetchDataEvent());
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              ),
            ),
            Image.asset(
              "images/home-logo.png",
              height: 30,
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed('/notification');
              },
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Container(
        // height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
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
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm tên thuốc, bệnh lý, ...',
                  hintStyle: TextStyle(color: Color(0xffc7c7c7)),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value != "")
                    BlocProvider.of<HomeScreenBloc>(context)
                        .add(SearchEvent(value));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductContainer extends StatelessWidget {
  final List<Product> products;

  ProductContainer({required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              color: Color(0xffa0bde7),
            ),
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 8,
            ),
            child: Text(
              "Kết qủa tìm kiếm",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                shadows: [
                  Shadow(
                    color: Colors.red,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffa0bde7), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          padding: EdgeInsets.only(top: 10),
          child: products.length > 0
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductItem(product: products[index]);
                  },
                )
              : Center(
                  child: Text(
                    "Không tìm thấy kết quả phù hợp",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return formatCurrency.format(amount);
  }

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(product: product),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              border: Border.all(color: Color(0xff6899e0), width: 2.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 2.0,
                          color: Color(0xff6899e0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 4, left: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              formatCurrency(product.price) +
                                  "VND/" +
                                  product.unit,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 8),
                          // decoration: BoxDecoration(
                          //   border: Border(
                          //       left: BorderSide(
                          //           color: Color(0xff6899e0), width: 2.0)),
                          // ),
                          // color: Colors.blue,
                          child: InkWell(
                            onTap: () {
                              BlocProvider.of<CartBloc>(context)
                                  .add(AddToCart(product));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã thêm vào giỏ hàng'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child:
                                Image.asset('images/ic-trang-chu-gio-hang.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}
