import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:DPTamDan/models/gallery.dart';
import 'package:DPTamDan/models/category.dart';
import 'package:DPTamDan/models/product.dart';

import '../const/conts.dart';

class APIService {
  Future<Map<String, dynamic>> fetchData() async {
    try {
      final response = await http.post(
        Uri.https(Constants.apiUrl, 'api/client/home'),
        // Uri.parse(Constants.apiUrl + '/api/client/home'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['result'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}
