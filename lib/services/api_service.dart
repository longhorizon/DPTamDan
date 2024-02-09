import 'dart:convert';
import 'package:http/http.dart' as http;

import '../const/conts.dart';

class APIService {
  fetchData() async {
    try {
      final response = await http.post(
        Uri.https(Constants.apiUrl, 'api/client/home'),
        // Uri.parse(Constants.apiUrl + '/api/client/home'),
        headers: {
          "Content-Type": "application/json",
          "access-control-allow-headers": "access-control-allow-origin, accept",
          "access-control-allow-origin": "*",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['result']; // as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}
