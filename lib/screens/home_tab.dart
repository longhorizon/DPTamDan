import 'package:DPTamDan/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/home_bloc.dart';
import '../events/home_event.dart';
import '../models/gallery.dart';
import '../models/product.dart';
import '../states/home_state.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String name = "";

  @override
  void initState() {
    super.initState();
    context.read<HomeScreenBloc>().add(FetchDataEvent());
    getUserName();
  }

  getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('last_name').toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is DataLoadedState) {
          final Gallery galleries = state.galleries;
          final Category categories = state.categories;
          final List<Product> products = state.products;
          return Scaffold(
            // appBar: _buildAppBar(),
            body: _buildBody(context, galleries, categories, products),
          );
        }
        if (state is ErrorState) {
          final String e = state.errorMessage;
          print("lỗi: $e");
        }
        return Scaffold();
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      title: const Text(
        'DPTamDan',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, Gallery galleries,
      Category categories, List<Product> products) {
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
              _buildUserInfo(),
              const SizedBox(height: 16.0),
              _buildBanner(galleries.data),
              const SizedBox(height: 16.0),
              _buildServiceDivider(),
              const SizedBox(height: 16.0),
              _buildServiceGridView(),
              const SizedBox(height: 16.0),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: products.length,
              //     itemBuilder: (context, index) {
              //       return ProductItem(product: products[index]);
              //     },
              //   ),
              // ),
              ProductContainer(
                products: products,
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(List<GalleryItem> galleryItems) {
    // return Padding(
    //   padding: EdgeInsets.zero,
    //   child: Image.asset(
    //     "images/banner.jpg",
    //     width: double.infinity,
    //   ),
    // );
    return BannerSlider(
      galleryItems: galleryItems,
    );
  }

  Widget _buildHeader() {
    return const Padding(
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
        ));
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Row(
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
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xfff7e7da),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Xin chào, ',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Text(
                name ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const Row(
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
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
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                serviceItems[index]['icon'],
                // height: 32.0,
                // width: 32.0,
                color: const Color(0xffb33535),
              ),
            ),
          ),
          // SizedBox(height: 4.0),
          Expanded(
            child: Text(
              serviceItems[index]['text'],
              textAlign: TextAlign.center,
              style: const TextStyle(
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

class BannerSlider extends StatefulWidget {
  final List<GalleryItem> galleryItems;

  BannerSlider({required this.galleryItems});

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      if (mounted) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.galleryItems.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildBannerItem(widget.galleryItems[index]);
        },
      ),
    );
  }

  Widget _buildBannerItem(GalleryItem item) {
    return Image.network(
      item.imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class ProductContainer extends StatelessWidget {
  final List<Product> products;

  ProductContainer({required this.products});
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: double.infinity,
    //   // height: 200, // Điều chỉnh chiều cao theo ý muốn của bạn
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //       colors: [Color(0xffa0bde7), Colors.white],
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       stops: [0.0, 1.0],
    //       tileMode: TileMode.clamp,
    //     ),
    //   ),
    //   child: Column(
    //     children:
    //         products.map((product) => ProductItem(product: product)).toList(),
    //   ),
    // );
    return Container(
      height: MediaQuery.of(context).size.height + 100,
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
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductItem(product: products[index]);
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
        children: [
          Container(
            height: 160,
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
                      fit: BoxFit.cover,
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
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        product.price.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(
                          left:
                              BorderSide(color: Color(0xff6899e0), width: 2.0)),
                    ),
                    child: Icon(Icons.shopping_cart, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
