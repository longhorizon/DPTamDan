import 'package:DPTamDan/models/category.dart';
import 'package:DPTamDan/models/user.dart';
import 'package:DPTamDan/screens/branch_screen.dart';
import 'package:DPTamDan/screens/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../blocs/cart_bloc.dart';
import '../blocs/home_bloc.dart';
import '../blocs/navigation_bloc.dart';
import '../events/cart_event.dart';
import '../events/home_event.dart';
import '../events/navigation_event.dart';
import '../models/gallery.dart';
import '../models/product.dart';
import '../states/cart_state.dart';
import '../states/home_state.dart';
import 'blog_screen.dart';
import 'detail_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String name = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    context.read<HomeScreenBloc>().add(FetchDataEvent());
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
        } else if (state is SearchState) {
          Navigator.pushNamed(context, "/search");
        }
      },
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          if (state is DataLoadedState) {
            UserProfile user = state.user;
            final Gallery galleries = state.galleries;
            final Category categories = state.categories;
            final List<Product> products = state.products;
            return Scaffold(
              key: _scaffoldKey,
              body: _buildBody(context, user, galleries, categories, products),
              drawer: buildDrawer(context, user.name),
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

  Drawer buildDrawer(BuildContext context, String username) {
    return Drawer(
            child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xffc34238),
                ),
                child: Image.asset(
                  "images/home-logo.png",
                  height: 30,
                ),
              ),
              Text("Xin chào!"),
              ListTile(
                title: Text(username,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Về Tadavina',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/tadavina").then((value) {
                    context.read<HomeScreenBloc>().add(FetchDataEvent());
                  });
                },
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Đăng xuất',
                    style: TextStyle(
                      color: Color(0xffd10d0d),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                },
              ),
            ],
          ),
        );
  }

  Widget _buildBody(BuildContext context, UserProfile user, Gallery galleries,
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
              _buildHeader(context),
              const SizedBox(height: 16.0),
              _buildSearchField(),
              const SizedBox(height: 16.0),
              _buildUserInfo(user.name),
              const SizedBox(height: 16.0),
              _buildBanner(galleries.data),
              const SizedBox(height: 16.0),
              _buildServiceDivider(),
              const SizedBox(height: 8.0),
              _buildServiceGridView(categories),
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

  Widget _buildBanner(List<GalleryItem> galleryItems) {
    return BannerSlider(
      galleryItems: galleryItems,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            Image.asset(
              "images/home-logo.png",
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/notification');
              },
              child: Stack(
                children: <Widget>[
                  Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height:10,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      // child: Text(
                      //   '5', // Số lượng thông báo
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 12,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                    ),
                  ),
                ],
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
                decoration: InputDecoration(
                  hintText: 'Tìm tên thuốc, bệnh lý, ...',
                  hintStyle: TextStyle(color: Color(0xffc7c7c7)),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value != "") {
                    BlocProvider.of<HomeScreenBloc>(context)
                        .add(SearchEvent(value));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String name) {
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
                name == "null" ? "" : name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Image.asset(
                'images/ic-dong-xu.png',
                width: 16,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                '0',
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

  Widget _buildServiceGridView(Category categories) {
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
          mainAxisSpacing: 4.0,
        ),
        itemCount: categories.data.length,
        itemBuilder: (context, index) {
          return _buildServiceItem(index, categories);
        },
      ),
    );
  }

  Widget _buildServiceItem(int index, Category categories) {
    return InkWell(
      onTap: () {
        if (categories.data[index].type == "1") {
          context.read<NavigationBloc>().add(ChangeTabEvent(1));
        } else if (categories.data[index].name == "Tư vấn trực tuyến") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ContactScreen(),
            ),
          );
        } else if (categories.data[index].name == "Nhà thuốc") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ListBranchScreen(),
            ),
          );
        } else if (categories.data[index].name == "Thư viện bệnh lý") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => BlogScreen(),
            ),
          );
        } else {

        }
      },
      child: Container(
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
                ),
                padding: const EdgeInsets.all(16.0),
                child: categories.data[index].imageUrl == ""
                    ? SvgPicture.asset(
                        'images/icons/nhathuoc.svg',
                        color: const Color(0xffb33535),
                      )
                    : Image.network(
                        categories.data[index].imageUrl,
                      ),
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Text(
                categories.data[index].name,
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
        if (_currentPage == widget.galleryItems.length - 1) {
          _pageController.animateToPage(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
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
              "Sản phẩm nổi bật",
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
          height: MediaQuery.of(context).size.height / 2 + 100,
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
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductItem(product: products[index]);
            },
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
