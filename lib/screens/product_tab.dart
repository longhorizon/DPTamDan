import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home_bloc.dart';
import '../blocs/navigation_bloc.dart';
import '../const/const.dart';
import '../events/home_event.dart';
import '../events/navigation_event.dart';
import '/models/category.dart';
import '/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'contact_screen.dart';
import 'detail_screen.dart';

class ProductTab extends StatefulWidget {
  @override
  _ProductTabState createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  List<CategoryItem> _categories = [];
  List<Product> _products = [];
  String _currentCategoryId = "";
  String _categoryName = "Tất cả sản phẩm";
  bool _isLoading = false;
  bool _isLoadmore = false;
  int _page = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData(_currentCategoryId);
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!_isLoading) {
      setState(() {
        _page++;
      });
      await _fetchData(_currentCategoryId);
    }
  }

  Future<void> _fetchData(String categoryId) async {
    try {
      setState(() {
        if(_page == 1)
          _isLoading = true;
        else
          _isLoadmore = true;
      });
      if (_currentCategoryId != categoryId) {
        setState(() {
          _page = 1;
        });
      }
      var uri = Uri.https(Constants.apiUrl, 'api/client/products');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json
            .encode({"page": _page, "limit": 20, "category_id": categoryId}),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<CategoryItem> categories =
            (data['categories'] as Map<String, dynamic>)
                .values
                .map((categoryJson) => CategoryItem.fromJson(categoryJson))
                .toList();
        final List<Product> products = (data['result'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        categories = categories;
        CategoryItem allProductsCategory = CategoryItem(
            id: "",
            name: "Tất cả sản phẩm",
            iconUrl:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw-uwpT8ZiaSVi_zG9pDidCfGEHsdojikWaxMiOoEczQ&s",
            link: '',
            type: "",
            imageUrl: '');
        categories.insert(0, allProductsCategory);
        setState(() {
          _categories = categories;
          _products.addAll(products);
          _currentCategoryId = categoryId;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildBody(context),
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
        children: [
          const SizedBox(height: 30.0),
          _buildSearchField(),
          const SizedBox(height: 16.0),
          Image.asset('images/ic-coupon.png'),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 100,
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _fetchData(_categories[index].id);
                          setState(() {
                            _categoryName = _categories[index].name;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _categories[index].id == _currentCategoryId
                                ? Colors.red
                                : Colors.white,
                            image: DecorationImage(
                              image: AssetImage('images/right-bg-cateicon.jpg'),
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.centerRight,
                            ),
                            border: Border(
                              bottom: BorderSide(color: Colors.red),
                            ),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(_categories[index]
                                            .iconUrl !=
                                        ""
                                    ? _categories[index].iconUrl
                                    : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw-uwpT8ZiaSVi_zG9pDidCfGEHsdojikWaxMiOoEczQ&s"),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Text(
                                  _categories[index].name,
                                  style: TextStyle(
                                    color: _categories[index].id !=
                                            _currentCategoryId
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 110,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.red)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.red),
                            bottom: BorderSide(color: Colors.red),
                          ),
                        ),
                        child: _categoryName == "Tất cả sản phẩm"
                            ? SizedBox(height: 1, width: double.infinity)
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Text(
                                      _categoryName.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Icon(Icons.double_arrow_outlined,
                                      color: Colors.red),
                                ],
                              ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          child: GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          product: _products[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFC6C6C6)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.only(
                                    left: 6,
                                    right: 6,
                                    top: 10,
                                    bottom: 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                _products[index].image),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Center(
                                          child: Text(
                                        _products[index].name,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              context.read<NavigationBloc>().add(ChangeTabEvent(2));
            },
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute (
                  builder: (BuildContext context) => const ContactScreen(),
                ),
              );
            },
            child: Icon(Icons.chat, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
