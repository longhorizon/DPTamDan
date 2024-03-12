import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const/const.dart';
import '../events/cart_event.dart';
import '../models/cart_item.dart';
import '../services/cart_reponsitory.dart';
import '../states/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartEmpty());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is LoadCartData) {
      yield* _mapLoadCartDataToState();
    } else if (event is AddToCart) {
      yield* _mapAddToCartToState(event);
    } else if (event is RemoveItem) {
      yield* _mapRemoveItemToState(event);
    } else if (event is UpdateCartItemQuantity) {
      yield* _mapUpdateItemToState(event);
    } else if (event is ApplyDiscountCode) {
      yield* _mapApplyDiscountCode(event);
    }
  }

  List<CartItem> parseProductsFromJson(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<dynamic> productsJson = data['result'];
    return productsJson
        .map((productJson) => CartItem.fromJson(productJson))
        .toList();
  }

  Stream<CartState> _mapLoadCartDataToState() async* {
    yield CartLoading();
    try {
      var uri = Uri.https(Constants.apiUrl, 'api/client/cart/info');
      CartRepository cartRepository = CartRepository(apiUrl: uri.toString());
      final cartDataRaw = await cartRepository.fetchCartData();
      final cartDataJson = json.decode(cartDataRaw);
      if (cartDataJson['status'] == 419) {
        yield CartError("Phiên đăng nhập đã hết hạn", errorCode: 419);
      }
      if (cartDataJson['status'] == 400) {
        yield CartError(cartDataJson['message']);
      }
      final List<CartItem> cartData = parseProductsFromJson(cartDataRaw);
      int total = calculateTotalPrice(cartData);
      yield CartLoaded(cartData, total: total);
    } catch (e) {
      yield CartError('Failed to load cart data: $e');
    }
  }

  Stream<CartState> _mapAddToCartToState(AddToCart event) async* {
    try {
      addItemToCartOnServer(1, event.product.id).then((value) async* {
        if (value == 419)
          yield CartError("Phiên đăng nhập đã hết hạn!", errorCode: 419);
        if (value == 400)
          yield CartError("Thêm vào giỏ hàng thất bại!");
        else
          yield CartError("Đã có lỗi xảy ra!");
      });
      if (state is CartLoaded) {
        List<CartItem> cartItems = List.from((state as CartLoaded).cartItems);

        bool isProductAlreadyInCart = false;
        for (CartItem item in cartItems) {
          if (item.product.id == event.product.id) {
            isProductAlreadyInCart = true;
            item.quantity++;
            break;
          }
        }

        if (!isProductAlreadyInCart) {
          cartItems.add(CartItem(product: event.product));
        }
        int total = (state as CartLoaded).total + event.product.price;
        yield CartLoaded(cartItems, total: total);
      } else if (state is CartEmpty) {
        yield CartLoaded([CartItem(product: event.product)],
            total: event.product.price);
      }
    } catch (e) {
      print('Error adding item to cart: $e');
      yield CartError("Failed to add item to cart.");
    }
  }

  Stream<CartState> _mapUpdateItemToState(UpdateCartItemQuantity event) async* {
    if (state is CartLoaded) {
      updateItemToCartOnServer(event.quantity, event.id).then((value) async* {
        if (value == 419)
          yield CartError("Phiên đăng nhập đã hết hạn!", errorCode: 419);
        if (value == 400)
          yield CartError("Cập nhật giỏ hàng thất bại!");
        else
          yield CartError("Đã có lỗi xảy ra!");
      });
      ;
      int total = calculateTotalPrice((state as CartLoaded).cartItems);
      List<CartItem> updatedItems = List.from((state as CartLoaded).cartItems);
      for (int i = 0; i < updatedItems.length; i++) {
        if (updatedItems[i].product.id == event.id) {
          total += updatedItems[i].product.price *
              (event.quantity - updatedItems[i].quantity);
          if (event.quantity > 0) {
            updatedItems[i] = CartItem(
                product: updatedItems[i].product, quantity: event.quantity);
          } else {
            updatedItems = (state as CartLoaded)
                .cartItems
                .where((item) => item.product.id != event.id)
                .toList();
          }
          break;
        }
      }
      yield CartLoaded(updatedItems, total: total);
    }
  }

  Stream<CartState> _mapRemoveItemToState(RemoveItem event) async* {
    removeItemToCartOnServer(event.id).then((value) async* {
      if (value == 419)
        yield CartError("Phiên đăng nhập đã hết hạn!", errorCode: 419);
      if (value == 400)
        yield CartError("Xoá sản phẩm khỏi giỏ hàng thất bại!");
      else
        yield CartError("Đã có lỗi xảy ra!");
    });
    ;
    CartItem item = (state as CartLoaded)
        .cartItems
        .where((item) => item.product.id == event.id)
        .first;
    int total = (state as CartLoaded).total;
    if (item != null) {
      total -= item.quantity * item.product.price;
    }
    final updatedCartItems = (state as CartLoaded)
        .cartItems
        .where((item) => item.product.id != event.id)
        .toList();

    yield CartLoaded(updatedCartItems, total: total);
  }

  int calculateTotalPrice(List<CartItem> cartItems) {
    int totalPrice = 0;
    for (CartItem item in cartItems) {
      totalPrice += item.product.price * item.quantity;
    }
    return totalPrice;
  }

  Future<int> addItemToCartOnServer(int total, String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/cart/add');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json.encode({
          "total": total,
          "id": id,
          "uid": uid,
          "token": token,
        }),
      );

      if (response.statusCode == 200) {
        print('Item added to cart on server successfully');
        final data = json.decode(response.body);
        if (data['status'] == 200)
          return 200;
        else if (data['status'] == 419)
          return 419;
        else
          return 400;
      } else {
        print('Failed to add item to cart on server: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item to cart on server: $e');
    }
    return 500;
  }

  Future<int> updateItemToCartOnServer(int total, String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/cart/update');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json.encode({
          "total": total,
          "id": id,
          "uid": uid,
          "token": token,
        }),
      );

      if (response.statusCode == 200) {
        print('Item added to cart on server successfully');
        final data = json.decode(response.body);
        if (data['status'] == 200)
          return 200;
        else if (data['status'] == 419)
          return 419;
        else
          return 400;
      } else {
        print('Failed to add item to cart on server: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item to cart on server: $e');
    }
    return 500;
  }

  Future<int> removeItemToCartOnServer(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/cart/remove');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json.encode({
          "id": id,
          "uid": uid,
          "token": token,
        }),
      );

      if (response.statusCode == 200) {
        print('Item added to cart on server successfully');
        final data = json.decode(response.body);
        if (data['status'] == 200)
          return 200;
        else if (data['status'] == 419)
          return 419;
        else
          return 400;
      } else {
        print('Failed to add item to cart on server: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding item to cart on server: $e');
    }
    return 500;
  }

  Stream<CartState> _mapApplyDiscountCode(ApplyDiscountCode event) async* {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri =
          Uri.https(Constants.apiUrl, 'api/client/cart/check/discountcode');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json.encode({
          "discount_code": event.discountCode,
          "uid": uid,
          "token": token,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 200) {
          yield CartLoaded(
            List.from((state as CartLoaded).cartItems),
            total: (state as CartLoaded).total,
            discode: event.discountCode,
            discount: responseData['discount_price'],
            isAddDiscount: true,
          );
        } else if (responseData['status'] == 419) {
          yield CartError("Phiên đăng nhập đã hết hạn", errorCode: 419);
        } else {
          yield CartLoaded(
            List.from((state as CartLoaded).cartItems),
            total: (state as CartLoaded).total,
            isAddDiscount: true,
          );
        }
      } else {
        yield CartError('Failed to apply discount code');
      }
    } catch (e) {
      print('Error apply discount code: $e');
    }
  }
}
