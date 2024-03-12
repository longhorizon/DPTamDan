import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartRepository {
  final String apiUrl;
  CartRepository({required this.apiUrl});

  fetchCartData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('user_id').toString();
    String token = prefs.getString('token').toString();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'text/plain'},
      body: json.encode({"uid": uid, "token": token}),
    );

    if (response.statusCode == 200) {
      // final List<CartItem> products = parseProductsFromJson(response.body);
      // return products;
      return response.body;
    } else {
      throw Exception('Failed to load cart data');
    }
  }

  List<CartItem> parseProductsFromJson(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<dynamic> productsJson = data['result'];
    return productsJson
        .map((productJson) => CartItem.fromJson(productJson))
        .toList();
  }
}
