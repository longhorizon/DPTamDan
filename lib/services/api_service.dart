import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const/const.dart';

class APIService {
  fetchData() async {
    try {
      final response = await http.post(
        Uri.https(Constants.apiUrl, 'api/client/home'),
        headers: {
          "Content-Type": "application/json",
          "access-control-allow-headers": "access-control-allow-origin, accept",
          "access-control-allow-origin": "*",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['result'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  fetchUserInfo() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      final response = await http.post(
        Uri.https(Constants.apiUrl, 'api/client/profile'),
        headers: {
          "Content-Type": "application/json",
          "access-control-allow-headers": "access-control-allow-origin, accept",
          "access-control-allow-origin": "*",
        },
        body: jsonEncode({
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  search(String key) async {
    try {
      final response = await http.post(
        Uri.https(Constants.apiUrl, 'api/client/search'),
        headers: {
          "Content-Type": "application/json",
          "access-control-allow-headers": "access-control-allow-origin, accept",
          "access-control-allow-origin": "*",
        },
        body: jsonEncode({
          'q': key,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['result'];
      } else {
        throw Exception('Failed to searching');
      }
    } catch (error) {
      throw Exception('Error searching: $error');
    }
  }
}
